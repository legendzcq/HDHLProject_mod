//
//  ConfigHelper.h
//  Carte
//
//  Created by ligh on 14-7-1.
//
//

#import <Foundation/Foundation.h>

@interface ConfigHelper : NSObject

+ (id)objectForInfoDictionaryKey:(NSString *)key;
+ (NSString *)appScheme;
+ (NSString *)appleID;

@end
