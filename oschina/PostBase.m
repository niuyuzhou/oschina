//
//  PostBase.m
//  oschina
//
//  Created by wangjun on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostBase.h"

@implementation PostBase
@synthesize segment_title;
@synthesize postsView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self myInit];
    }
    return self;
}
- (void)myInit
{
    self.tabBarItem.image = [UIImage imageNamed:@"answer"];
    self.tabBarItem.title = @"问答";
    
    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"问答",
                                   @"分享",
                                   @"Roundup",
                                   @"职业",
                                   @"站务",
                                   nil];
    self.segment_title = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    self.segment_title.selectedSegmentIndex = 0;
    self.segment_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segment_title.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segment_title.frame = CGRectMake(0, 0, 300, 30);
    [self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment_title;
    //子页面初始化
    self.postsView = [[PostsView alloc] init];
    self.postsView.catalog = 1;
    [self addChildViewController:self.postsView];
    [self.view addSubview:self.postsView.view];
    self.postsView.view.frame = self.view.bounds;
    self.postsView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //添加发布动弹的按钮
//    UIBarButtonItem *btnPubPost = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
//    btnPubPost.title = @"";
//    btnPubPost.image = [UIImage imageNamed:@"question24"];
//    [btnPubPost setAction:@selector(clickPubPost:)];
//    self.navigationItem.rightBarButtonItem = btnPubPost;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn addTarget:self action:@selector(clickPubPost:) forControlEvents:UIControlEventTouchUpInside];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        [btn setImage:[UIImage imageNamed:@"questionBlue"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0,10, 0, -10);
    }
        
    else
        [btn setImage:[UIImage imageNamed:@"question24"] forState:UIControlStateNormal];
    
    UIBarButtonItem *btnPubPost = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnPubPost;
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)clickPubPost:(id)sender
{
    if ([Config Instance].isLogin == NO) {
        [Tool noticeLogin:self.view andDelegate:self andTitle:@"请先登录后再发表问答"];
        return;
    }
    
    PostPubView *pub = [[PostPubView alloc] init];
    pub.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pub animated:YES];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [Tool processLoginNotice:actionSheet andButtonIndex:buttonIndex andNav:self.navigationController andParent:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)segmentAction:(id)sender
{
    [self.postsView reloadType:self.segment_title.selectedSegmentIndex + 1];
}
- (NSString *)getSegmentTitle
{
    switch (self.segment_title.selectedSegmentIndex) {
        case 0:
            return @"问答";
        case 1:
            return @"分享";
        case 2:
            return @"Roundup";
        case 3:
            return @"职业";
        case 4:
            return @"站务";
    }
    return @"";
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segment_title = nil;
    self.postsView = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:[Config Instance].isCookie ? @"1" : @"0"];
    if (self.segment_title == nil || self.postsView == nil) {
        [self myInit];
    }
}

@end
