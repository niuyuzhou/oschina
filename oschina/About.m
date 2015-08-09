//
//  About.m
//  oschina
//
//  Created by wangjun on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "About.h"

@implementation About
@synthesize lblVersion;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *btnWeb = [[UIBarButtonItem alloc] initWithTitle:@"访问手机版" style:UIBarButtonItemStyleBordered target:self action:@selector(clickWeb:)];
    self.navigationItem.rightBarButtonItem = btnWeb;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    self.lblVersion.text = [NSString stringWithFormat:@"版本: %@", app_build];
    
    self.navigationItem.title = @"About Me";
    
    if (IS_IPHONE_5) {
        self.lblVersion.center = CGPointMake(self.lblVersion.center.x, self.lblVersion.center.y + 88);
        self.lblOSC.center = CGPointMake(self.lblOSC.center.x, self.lblOSC.center.y + 88);
        self.lblCopyright.center = CGPointMake(self.lblCopyright.center.x, self.lblCopyright.center.y + 88);
        self.img.image = [UIImage imageNamed:@"aboutbg1136.jpg"];
    }
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)clickWeb:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.oschina.net"]];
}
- (void)viewDidUnload
{
    [self setLblVersion:nil];
    [self setLblOSC:nil];
    [self setLblVersion:nil];
    [self setLblCopyright:nil];
    [self setImg:nil];
    [super viewDidUnload];
}

@end
