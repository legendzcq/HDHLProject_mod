//
//  NSString+AES.h
//  iTotemMinFramework
//
//  Created by leslie_home on 13-10-16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (AES)
- (NSData*)encryptAESDatakey:(NSString *)key;
+ (NSString*)decryptAESData:(NSData*)data key:(NSString *)key;
@end
