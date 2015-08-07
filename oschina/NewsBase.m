//
//  NewsBase.m
//  oschina
//
//  Created by wangjun on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsBase.h"

@implementation NewsBase
@synthesize segment_title;
@synthesize newsView;

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
    self.tabBarItem.image = [UIImage imageNamed:@"info"];
    self.tabBarItem.title = @"News Feed";

    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"News",
                                   @"Blogs",
//                                   @"Recommended",
                                   nil];
    self.segment_title = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
    self.segment_title.selectedSegmentIndex = 0;
    self.segment_title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.segment_title.segmentedControlStyle = UISegmentedControlStyleBar;
    self.segment_title.frame = CGRectMake(0, 0, 300, 30);
    [self.segment_title addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segment_title;
    
    //子页面初始化
    self.newsView = [[NewsView alloc] init];
    self.newsView.catalog = 1;
    [self addChildViewController:self.newsView];
    [self.view addSubview:self.newsView.view];
    self.newsView.view.frame = self.view.bounds;
    self.newsView.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //添加发布动弹的按钮
//    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:nil];
//    btnSearch.image = [UIImage imageNamed:@"searchWhite"];
//    [btnSearch setAction:@selector(clickSearch:)];
//    self.navigationItem.rightBarButtonItem = btnSearch;
//    
//    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        [btn setImage:[UIImage imageNamed:@"searchBlue"] forState:UIControlStateNormal];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0,10, 0, -10);
    }
        
    else
        [btn setImage:[UIImage imageNamed:@"searchWhite"] forState:UIControlStateNormal];
    
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = btnSearch;
    
    //适配iOS7uinavigationbar遮挡tableView的问题
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)clickSearch:(id)sender
{
    SearchView * sView = [[SearchView alloc] init];
    sView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sView animated:YES];
}
- (void)segmentAction:(id)sender
{
    [self.newsView reloadType:self.segment_title.selectedSegmentIndex+1];
}
- (NSString *)getSegmentTitle
{
    switch (self.segment_title.selectedSegmentIndex) {
        case 0:
            return @"News";
        case 1:
            return @"Blogs";
/*
        case 2:
            return @"Recommended";
*/
    }
    return @"";
}

#pragma mark - View lifecycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.segment_title = nil;
    self.newsView = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (self.newsView == nil || self.segment_title == nil) 
    {
        [self myInit];
    }
}

@end
