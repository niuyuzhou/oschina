//
//  ShareView.m
//  oschina
//
//  Created by wangjun on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareView.h"
#import "RegexKitLite.h"

@implementation ShareView
@synthesize imgSina;
@synthesize imgQQ;
@synthesize imgWechatCircle;
@synthesize imgWechatFriend;
@synthesize url;
@synthesize content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *titleStr=@"分享";
    self.tabBarItem.title = titleStr;
    self.tabBarItem.image = [UIImage imageNamed:@"share"];
    self.title = titleStr;
    self.navigationController.title = titleStr;
    self.parentViewController.navigationController.title = titleStr;
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.parentViewController.navigationItem.title = @"分享";
    
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBarItem.title = @"分享";
    self.tabBarItem.image = [UIImage imageNamed:@"share"];
    self.title = @"分享";
    self.navigationController.title = @"分享";
    self.parentViewController.navigationController.title = @"分享";
    
    tapSina = [[UITap alloc] initWithTarget:self action:@selector(click_weibo:)];
    [imgSina addGestureRecognizer:tapSina];
    
    tapQQ = [[UITap alloc] initWithTarget:self action:@selector(click_qqshare:)];
    [imgQQ addGestureRecognizer:tapQQ];
    
    tapWechatCircle = [[UITap alloc] initWithTarget:self action:@selector(click_wechatCircle:)];
    [imgWechatCircle addGestureRecognizer:tapWechatCircle];
    
    tapWechatFriend = [[UITap alloc] initWithTarget:self action:@selector(click_wechatFriend:)];
    [imgWechatFriend addGestureRecognizer:tapWechatFriend];
    
    self.view.backgroundColor = [Tool getBackgroundColor];
    
    if (IS_IPHONE_5) {
        self.imgSina.frame = CGRectMake(40, 95, 240, 44);
        self.imgQQ.frame = CGRectMake(40, 175, 240, 44);
        self.imgWechatCircle.frame = CGRectMake(40, 255, 240, 44);
        self.imgWechatFriend.frame = CGRectMake(40, 335, 240, 44);
    }else{
        self.imgSina.frame = CGRectMake(40, 65, 240, 44);
        self.imgQQ.frame = CGRectMake(40, 135, 240, 44);
        self.imgWechatCircle.frame = CGRectMake(40, 205, 240, 44);
        self.imgWechatFriend.frame = CGRectMake(40, 275, 240, 44);
    }
    
}

- (void)viewDidUnload
{
    [self setImgSina:nil];
    [self setImgQQ:nil];
    [self setImgWechatCircle:nil];
    [self setImgWechatFriend:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)click_qqshare:(id)sender {
    
    NSString *share_url = @"http://share.v.t.qq.com/index.php?c=share&a=index";
    NSString *share_Source = @"OSChina";
    NSString *share_Site = @"OSChina.NET";
    NSString *share_AppKey = @"96f54f97c4de46e393c4835a266207f4";
    
    if ([Config Instance].shareObject) {
        NSString *all = [NSString stringWithFormat:@"%@&title=%@&url=%@&appkey=%@&source=%@&site=%@", 
                         share_url,
                         [[Config Instance].shareObject.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         [[Config Instance].shareObject.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         share_AppKey,
                         share_Source,
                         share_Site];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:all]];
    }
}

- (IBAction)click_weibo:(id)sender {
    
    NSString *share_url = @"http://v.t.sina.com.cn/share/share.php";
    if ([Config Instance].shareObject) {
        NSString *all = [NSString stringWithFormat:@"%@?appkey=%@&title=%@&url=%@",
                         
                         share_url,
                         SinaAppKey,
                         [[Config Instance].shareObject.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                         [[Config Instance].shareObject.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:all]];
    }
}

- (IBAction)click_wechatCircle:(id)sender {
    [self sendLinkContent:YES];
}

- (IBAction)click_wechatFriend:(id)sender {
    [self sendLinkContent:NO];
}

- (void) sendLinkContent:(BOOL)toCircle
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [Config Instance].shareObject.title;
    message.description = [Config Instance].shareObject.title;
    NSArray *imageArray = [Tool ExactImagesFrom:[Config Instance].shareObject.content];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    NSString *urlStr = [Config Instance].shareObject.url;
    ext.webpageUrl = [Tool ReplaceString:urlStr useRegExp:@"http://www" byString:@"http://m"] ;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    if (toCircle == YES) {
        req.scene = WXSceneTimeline;
    } else {
        req.scene = WXSceneSession;
    }
   
    if([imageArray count]>0){
        NSURL *imageURL = [NSURL URLWithString:imageArray[0][1]];
        //异步获取网络图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:imageData];
                CGSize size = CGSizeMake(200,200);
                [message setThumbImage:[Tool thumbnailWithImageWithoutScale:image size:size]];
                req.message = message;
                [WXApi sendReq:req];
            });
        });
        return;
    }else{
        [message setThumbImage:[UIImage imageNamed:@"120_120.png"]];
        req.message = message;
        [WXApi sendReq:req];
    }
}

@end
