//
//  ShareView.h
//  oschina
//
//  Created by wangjun on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OAuthEngine.h"
//#import "WeiboClient.h"
//#import "OAuthController.h"
#import "Tool.h"
#import "ShareObject.h"
#import "UITap.h"
#import "WXApi.h"

#define SinaAppKey @"3616966952"
#define WeChatKey @"wx41be5fe48092e94c"

@interface ShareView : UIViewController<WXApiDelegate>
{
    NSString * url;
    NSString * content;
    
    UIAlertView *progressView;
    
    UITap *tapSina;
    UITap *tapQQ;
    UITap *tapWechatCircle;
    UITap *tapWechatFriend;
    
    BOOL isInitialize;
    
    MBProgressHUD * hud;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imgSina;
@property (strong, nonatomic) IBOutlet UIImageView *imgQQ;
@property (strong, nonatomic) IBOutlet UIImageView *imgWechatCircle;
@property (strong, nonatomic) IBOutlet UIImageView *imgWechatFriend;


@property (copy,nonatomic) NSString * url;
@property (copy,nonatomic) NSString * content;

- (IBAction)click_qqshare:(id)sender;
- (IBAction)click_weibo:(id)sender;
- (IBAction)click_wechatCircle:(id)sender;
- (IBAction)click_wechatFriend:(id)sender;

@end
