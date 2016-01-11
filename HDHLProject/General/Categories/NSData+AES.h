//
//  NSData+AES.h
//  iTotemMinFramework
//
//  Created by leslie_home on 13-10-16.
//
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
