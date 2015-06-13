//
//  ShareObject.h
//  oschina
//
//  Created by wangjun on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareObject : NSObject

@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * url;
@property (copy,nonatomic) NSString * content;

- (id)initWithParameters:(NSString *)ntitle andUrl:(NSString *)nurl andContent:(NSString *) ncontent;

@end
