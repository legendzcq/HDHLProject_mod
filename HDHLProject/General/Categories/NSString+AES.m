//
//  NSString+AES.m
//  iTotemMinFramework
//
//  Created by leslie_home on 13-10-16.
//
//

#import "NSString+AES.h"

@implementation NSString (AES)
#pragma mark - AES加密
//将string转成带密码的data
- (NSData*)encryptAESDatakey:(NSString *)key
{
    //将nsstring转化为nsdata
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES256EncryptWithKey:key];
    return encryptedData;
}

//将带密码的data转成string
+ (NSString*)decryptAESData:(NSData*)data key:(NSString *)key
{
    //使用密码对data进行解密
    NSData *decryData = [data AES256DecryptWithKey:key];
    //将解了密码的nsdata转化为nsstring
    NSString *string = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return string;
}

@end
