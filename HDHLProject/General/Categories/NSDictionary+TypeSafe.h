//
//  NSDictionary+TypeSafe.h
//  testNetworking
//
//  Created by zhaojunwei on 14/11/21.
//  Copyright (c) 2014年 yxp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (TypeSafe)

- (NSString *)stringForKey:(id)aKey;
- (NSArray *)arrayForKey:(id)aKey;
- (NSDictionary *)dictionaryForKey:(id)aKey;
- (NSInteger)integerForKey:(id)aKey; // 值为数字、字符串都可以
- (CGFloat)floatForKey:(id)aKey; // 值为数字、字符串都可以
- (BOOL)boolForKey:(id)aKey; // 值为布尔、数字、字符串都可以

@end
