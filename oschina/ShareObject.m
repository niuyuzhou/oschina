//
//  ShareObject.m
//  oschina
//
//  Created by wangjun on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareObject.h"

@implementation ShareObject

@synthesize title;
@synthesize url;
@synthesize content;


- (id)initWithParameters:(NSString *)ntitle andUrl:(NSString *)nurl andContent:(NSString *)ncontent
{
    ShareObject *s = [[ShareObject alloc] init];
    s.title = ntitle;
    s.url = nurl;
    s.content = ncontent;
    return s;
}


@end
