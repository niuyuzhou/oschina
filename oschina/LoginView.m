//
//  LoginView.m
//  oschina
//
//  Created by wangjun on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView
@synthesize webView;
@synthesize txt_Name;
@synthesize txt_Pwd;
@synthesize switch_Remember;
@synthesize isPopupByNotice;
//@synthesize parent;
//@synthesize parentClassName;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Tool clearWebViewBackground:webView];
    [self.webView setDelegate:self];
    
    self.navigationItem.title = @"Login";
    //决定是否显示用户名以及密码
    NSString *name = [Config Instance].getUserName;
    NSString *pwd = [Config Instance].getPwd;
    if (name && ![name isEqualToString:@""]) {
        self.txt_Name.text = name;
    }
    if (pwd && ![pwd isEqualToString:@""]) {
        self.txt_Pwd.text = pwd;
    }
    
    UIBarButtonItem *btnLogin = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(click_Login:)];
    self.navigationItem.rightBarButtonItem = btnLogin;
    self.view.backgroundColor = [Tool getBackgroundColor];
    self.webView.backgroundColor = [Tool getBackgroundColor];
    
    NSString *html = @"<body style='background-color:#EBEBF3'>1, You could register an account <a href='http://www.oschina.net'>http://www.oschina.net</a> for free to login <p />2, You can click <a href='http://www.oschina.net/question/12_52232'>here</a> to learn more about the mobile client</body>";
    [self.webView loadHTMLString:html baseURL:nil];
    self.webView.hidden = NO;
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewDidUnload
{
    [self setTxt_Name:nil];
    [self setTxt_Pwd:nil];
    [self setSwitch_Remember:nil];
    [self setWebView:nil];
    [Tool CancelRequest:request];
    [super viewDidUnload];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [Tool CancelRequest:request];
}
- (IBAction)click_Login:(id)sender 
{    
    NSString *name = self.txt_Name.text;
    NSString *pwd = self.txt_Pwd.text;
    request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:api_login_validate]];
    [request setUseCookiePersistence:YES];
    [request setPostValue:name forKey:@"username"];
    [request setPostValue:pwd forKey:@"pwd"];
    [request setPostValue:@"1" forKey:@"keep_login"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestLogin:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在登录" andView:self.view andHUD:request.hud];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
}
- (void)requestLogin:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    [Tool getOSCNotice:request];
    [request setUseCookiePersistence:YES];
    ApiError *error = [Tool getApiError:request];
    if (error == nil) {
        [Tool ToastNotification:request.responseString andView:self.view andLoading:NO andIsBottom:NO];
    }
    switch (error.errorCode) {
        
        case 1:
        {
            [[Config Instance] saveCookie:YES];
            if (isPopupByNotice == NO) 
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            //处理是否记住用户名或者密码
            if (self.switch_Remember.isOn) 
            {
                [[Config Instance] saveUserNameAndPwd:self.txt_Name.text andPwd:self.txt_Pwd.text];
            }
            //否则需要清空用户名于密码
            else
            {
                [[Config Instance] saveUserNameAndPwd:@"" andPwd:@""];
            }
            //返回的处理

            if ([Config Instance].viewBeforeLogin) 
            {
                if([[Config Instance].viewNameBeforeLogin isEqualToString:@"ProfileBase"])
                {
                    ProfileBase *_parent = (ProfileBase *)[Config Instance].viewBeforeLogin;
                    _parent.isLoginJustNow = YES;
                }
            }
            
            //开始分析 uid 等等信息
            [self analyseUserInfo:request.responseString];
            
            //分析是否需要退回
            if (self.isPopupByNotice) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[MyThread Instance] startNotice];
        }
            break;
        case 0:
        case -1:
        {
            [Tool ToastNotification:[NSString stringWithFormat:@"错误 %@",error.errorMessage] andView:self.view andLoading:NO andIsBottom:NO];
        }
            break;
    }
}

- (IBAction)textEnd:(id)sender 
{
    [sender resignFirstResponder];
}

- (IBAction)backgrondTouch:(id)sender 
{
    [self.txt_Pwd resignFirstResponder];
    [self.txt_Name resignFirstResponder];
}


- (void)analyseUserInfo:(NSString *)xml
{
    @try {
        TBXML *_xml = [[TBXML alloc] initWithXMLString:xml error:nil];
        TBXMLElement *root = _xml.rootXMLElement;    
        TBXMLElement *user = [TBXML childElementNamed:@"user" parentElement:root];
        TBXMLElement *uid = [TBXML childElementNamed:@"uid" parentElement:user];
        //获取uid
        [[Config Instance] saveUID:[[TBXML textForElement:uid] intValue]];
    }
    @catch (NSException *exception) {
        [NdUncaughtExceptionHandler TakeException:exception];
    }
    @finally {
        
    }
    
}

#pragma 浏览器链接处理
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[UIApplication sharedApplication] openURL:request.URL];
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) 
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
