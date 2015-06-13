//
//  Scan.h
//  oschina
//
//  Created by 江裕诚 on 14-3-20.
//  Copyright (c) 2014年 OSChina.NET All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scan : NSObject

@property (copy,nonatomic) NSString * title;
@property (copy,nonatomic) NSString * url;
@property BOOL requireLogin;
@property int type;

- (id)initWithParameters:(NSString *)newTitle
                  andUrl:(NSString *)newUrl
         andRequireLogin:(BOOL)newRequireLogin
                 andType:(int)newType;

@end
