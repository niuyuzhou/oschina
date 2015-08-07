//
//  ScanViewController.m
//  oschina
//
//  Created by 江裕诚 on 14-3-23.
//  Copyright (c) 2014年 OSChina.NET All rights reserved.
//

#import "ScanView.h"

@interface ScanView ()

@end

@implementation ScanView

- (id) init
{
    self = [super init];
    self.wantsFullScreenLayout = YES;
    self.showsZBarControls = NO;
    self.supportedOrientationsMask = ZBarOrientationMaskAll;
    self.readerDelegate = self;
    [self.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [self setOverLayPickerView];
    return self;
}

- (void)setOverLayPickerView
{
    UIView* up = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    up.alpha = 0.3;
    up.backgroundColor = [UIColor blackColor];
    [self.view addSubview:up];
    
    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 20, 280)];
    left.alpha = 0.3;
    left.backgroundColor = [UIColor blackColor];
    [self.view addSubview:left];
    
    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(300, 80, 20, 280)];
    right.alpha = 0.3;
    right.backgroundColor = [UIColor blackColor];
    [self.view addSubview:right];
    
    UIView * down = [[UIView alloc] initWithFrame:CGRectMake(0, 360, 320, 220)];
    down.alpha = 0.3;
    down.backgroundColor = [UIColor blackColor];
    [self.view addSubview:down];
    
    int barheight = 40;
    
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
        barheight = 60;
    }
    
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, barheight)];
    UIBarButtonItem * button = [[UIBarButtonItem alloc] init];
    [button setTitle:@"取消"];
    [button setTarget:self];
    [button setStyle:UIBarButtonItemStyleBordered];
    [button setAction:@selector(dismissOverlayView)];
    NSMutableArray * buttonItems = [[NSMutableArray alloc] init];
    [buttonItems addObject:button];
    [toolbar setItems:buttonItems];
    [self.view addSubview:toolbar];
}
- (void)dismissOverlayView{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol = nil;
    for(symbol in results)
        break;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSData * scanData = [symbol.data dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * resultDictionary = [scanData objectFromJSONData];
    NSString * url = [resultDictionary objectForKey:@"url"];
    NSString * title = [resultDictionary objectForKey:@"title"];
    NSNumber * type = [resultDictionary objectForKey:@"type"];
    NSNumber * requireLogin = [resultDictionary objectForKey:@"require_login"];
    if (url == nil || title == nil || type == nil || requireLogin == nil) {
        UIAlertView * failAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"无效二维码" delegate:nil cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [failAlert show];
        return;
    }
    Scan * scan = [[Scan alloc] initWithParameters:title andUrl:url andRequireLogin:requireLogin.boolValue andType:type.intValue];
    
    if (scan.requireLogin == YES) {
        if ([Config Instance].isCookie == NO) {
            UIAlertView * loginAlert = [[UIAlertView alloc] initWithTitle:@"未登录" message:@"请先登陆" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [loginAlert show];
            return;
        }
    }
    
    [[AFOSCClient sharedClient] getPath:scan.url parameters:nil
                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    NSString * response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                                    NSDictionary * responseDictonary = [response objectFromJSONString];
                                    NSString * error = [responseDictonary objectForKey:@"error"];
                                    NSString * msg = [responseDictonary objectForKey:@"msg"];
                                    if (msg == nil) {
                                        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"签到失败" message:error delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [errorAlert show];
                                    } else {
                                        UIAlertView * msgAlert = [[UIAlertView alloc] initWithTitle:@"签到成功" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                        [msgAlert show];
                                    }
                                    
                                }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    [Tool ToastNotification:@"网络连接故障" andView:self.view andLoading:NO andIsBottom:NO];
                                }];
    
}
@end
