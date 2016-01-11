//
//  UtilsMacro.h
//  MinFramework
//
//  方便使用的宏定义
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_UtilsMacro_h
#define MinFramework_UtilsMacro_h


//单例定义
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

//单例的实现
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ \
__singleton__ = [[__class alloc] init]; \
} ); \
return __singleton__; \
}


//创建颜色
#define UIColorFromRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)       UIColorFromRGBA(r,g,b,1)


//ios 版本
#define IOS_VERSION_CODE   [[[UIDevice currentDevice] systemVersion] intValue] 
#define IOS_SDK_3          IOS_VERSION_CODE==3
#define IOS_SDK_4          IOS_VERSION_CODE==4
#define IOS_SDK_5          IOS_VERSION_CODE==5
#define IOS_SDK_6          IOS_VERSION_CODE==6
#define IOS_SDK_7          IOS_VERSION_CODE==7
#define IOS_SDK_8          IOS_VERSION_CODE==8
#define IOS_SDK_8_3        ( [[[UIDevice currentDevice] systemVersion] compare:@"8.3"] == NSOrderedSame )

#define IOS_SDK_7_LATER    IOS_VERSION_CODE>=7

//角度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

#define UIImageForName(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

#define RELEASE_SAFELY(__POINTER) { if(__POINTER != nil) { __POINTER = nil;} }

#endif
