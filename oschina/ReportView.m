//
//  ReportView.m
//  oschina
//
//  Created by chenhaoxiang on 14-4-21.
//
//

#import "ReportView.h"

@interface ReportView ()

@end

@implementation ReportView

@synthesize reasonContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated
{
    self.parentViewController.navigationItem.title = @"举报原因";
    UIBarButtonItem *btnReport = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStyleBordered target:self action:@selector(clickReport:)];
    self.parentViewController.navigationItem.rightBarButtonItem = btnReport;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([Config Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@"请先登录"];
        return;
    }
    
    [Tool roundTextView:reasonContent];
    [reasonContent becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBackground:(id)sender
{
    [self.reasonContent resignFirstResponder];
}


- (IBAction) clickReport:(id)sender {
    if ([Config Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@"请先登录"];
        return;
    }
    
    NSString *memo = self.reasonContent.text;
    if ([memo isEqual: @""]) {memo = @"其他原因";}
    NSString *url = [[Config Instance].shareObject.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *obj_id =  [[url componentsSeparatedByString:@"_"] lastObject];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView: self.view];
    [Tool showHUD: @"正在提交" andView: self.view andHUD: hud];
    
    [[AFOSCClient sharedClient] postPath: api_report
                              parameters: [NSDictionary dictionaryWithObjectsAndKeys:
                                          memo,    @"memo",
                                          obj_id,  @"obj_id",
                                          @"2",    @"obj_type",
                                          @"4",    @"reason",
                                          url,     @"url", nil]
                                 success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                     [hud hide:YES];
                                     
                                     if ([operation.responseString  isEqual: @""]) {
                                         [Tool ToastNotification:[NSString stringWithFormat:@"举报成功！"] andView:self.view andLoading:NO andIsBottom:NO];
                                     }
                                     else {
                                         [Tool ToastNotification:[NSString stringWithFormat:@"举报失败！"] andView:self.view andLoading:NO andIsBottom:NO];
                                     }
                                 }
                                 failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                     [hud hide:YES];
                                     [Tool ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:NO];
                                 }];
}

@end
