//
//  AppColorHelper.m
//  Carte
//
//  Created by ligh on 14-7-15.
//
//

#import "AppColorHelper.h"

@interface AppColorHelper()
{
    NSMutableDictionary *_configDictionaryHex;
    NSMutableDictionary *_homeConfigDictionaryHex;
}
@end

@implementation AppColorHelper

- (id)init
{
    if (self = [super init]) {
        [self loadConfig];
    }
    return self;
}

static id instance;
+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)loadConfig
{
    /*
     *IOS中十六进制的颜色转换为UIColor
     */
    NSString *colorPlistPathHex = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"plist"];
    _configDictionaryHex = [NSMutableDictionary dictionaryWithContentsOfFile:colorPlistPathHex];
    
    NSString *homeColorPlistPathHex = [[NSBundle mainBundle] pathForResource:@"home_color" ofType:@"plist"];
    _homeConfigDictionaryHex = [NSMutableDictionary dictionaryWithContentsOfFile:homeColorPlistPathHex];
}

//获取状态栏色值字段
- (NSString *)valueWithHexForKey:(NSString *)key
{
    return _configDictionaryHex[key];
}

- (NSString *)homeValueWithHexForKey:(NSString *)key
{
    return _homeConfigDictionaryHex[key];
}

+ (NSString *)valueWithHexForKey:(NSString *)key
{
    return [[AppColorHelper shareInstance] valueWithHexForKey:key];
}

+ (NSString *)homeValueWithHexForKey:(NSString *)key
{
    return [[AppColorHelper shareInstance] homeValueWithHexForKey:key];
}

+ (UIStatusBarStyle)preferredStatusBarStyle
{
    NSString *statusStyle = [AppColorHelper homeValueWithHexForKey:AppColor_Home_StatusBarStyle];
    if ([@"white" isEqualToString:statusStyle]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

/*
 *IOS中十六进制的颜色转换为UIColor
 */

- (UIColor *)colorWithHexForKey:(NSString *)key
{
    NSString *RGBString = _configDictionaryHex[key];
    return [self colorWithHexKeyString:RGBString];
}

- (UIColor *)homeColorWithHexForKey:(NSString *)key
{
    NSString *RGBString = _homeConfigDictionaryHex[key];
    return [self colorWithHexKeyString:RGBString];
}

+ (UIColor *)colorWithHexForKey:(NSString *)key
{
    return [[AppColorHelper shareInstance] colorWithHexForKey:key];
}

+ (UIColor *)homeColorWithHexForKey:(NSString *)key
{
    return [[AppColorHelper shareInstance] homeColorWithHexForKey:key];
}

//十六进制的颜色转换为UIColor
- (UIColor *)colorWithHexKeyString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end

