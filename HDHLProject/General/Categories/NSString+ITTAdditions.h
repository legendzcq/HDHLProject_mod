//
//  NSString+ITTAdditions.h
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (ITTAdditions)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth;
- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth;

//获取文本宽度，高度
- (CGFloat)widthWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size;
- (CGFloat)heightWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size;
//获取文本行数
- (NSInteger)numberOfLinesWithFont:(UIFont*)font boundingRectWithWidth:(CGFloat)lineWidth;

- (NSString *)md5;

+ (BOOL)isBlankString:(NSString *)string;
- (NSString *)nonemptyString; //非空字符串

@end

