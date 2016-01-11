//
//  PhoneNumberHelper.h
//  Carte
//
//  Created by ligh on 14-5-17.
//
//

#import <Foundation/Foundation.h>

@interface PhoneNumberHelper : NSObject

+ (NSArray *)parseText:(NSString *)text;
+ (void)callPhoneWithText:(NSString *)text;
+ (BOOL)validateMobile:(NSString *)phoneNumber;

@end
