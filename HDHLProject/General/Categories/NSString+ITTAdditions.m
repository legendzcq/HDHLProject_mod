//
//  NSString+ITTAdditions.m
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "UIFont+ITTAdditions.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (ITTAdditions)

- (NSInteger)numberOfLinesWithFont:(UIFont*)font
                     withLineWidth:(NSInteger)lineWidth{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByTruncatingTail];
    NSInteger lines = size.height / [font ittLineHeight];
    return lines;
}

- (CGFloat)heightWithFont:(UIFont*)font
            withLineWidth:(NSInteger)lineWidth{
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByTruncatingTail];
	return size.height;
}

//获取文本行数
- (NSInteger)numberOfLinesWithFont:(UIFont*)font boundingRectWithWidth:(CGFloat)lineWidth {
    CGFloat height = [self sizeWithFont:font boundingRectWithSize:CGSizeMake(lineWidth, CGFLOAT_MAX)].height;
    return height / [font ittLineHeight] + 1;
}

//获取文本宽度，高度
- (CGFloat)widthWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size {
    return [self sizeWithFont:font boundingRectWithSize:size].width;
}

- (CGFloat)heightWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size {
    return [self sizeWithFont:font boundingRectWithSize:size].height;
}

- (CGSize)sizeWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size {
    if (IOS_SDK_7_LATER) {
        CGSize resultSize = [self boundingRectWithSize:size
                                               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil].size;
        return resultSize;
    } else {
        CGSize resultSize2 = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingTail];
        return resultSize2;
    }
}

- (NSString *)md5{
	const char *concat_str = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
	NSMutableString *hash = [NSMutableString string];
	for (int i = 0; i < 16; i++){
		[hash appendFormat:@"%02X", result[i]];
	}
	return [hash lowercaseString];
}

+ (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//非空字符串
- (NSString *)nonemptyString
{
    if (!self.length) {
        return @"";
    } else if ([self isEqualToString:@"<null>"]) {
        return @"";
    }
    return self;
}

@end

