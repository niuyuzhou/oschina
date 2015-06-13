//
//  Scan.m
//  oschina
//
//  Created by 江裕诚 on 14-3-20.
//  Copyright (c) 2014年 OSChina.NET All rights reserved.
//

#import "Scan.h"

@implementation Scan

@synthesize title;
@synthesize url;
@synthesize requireLogin;
@synthesize type;

- (id)initWithParameters:(NSString *)newTitle
                  andUrl:(NSString *)newUrl
         andRequireLogin:(BOOL)newRequireLogin
                 andType:(int)newType
{
    Scan * s = [[Scan alloc] init];
    s.title = newTitle;
    s.url = newUrl;
    s.requireLogin = newRequireLogin;
    s.type = newType;
    return s;
}

@end
