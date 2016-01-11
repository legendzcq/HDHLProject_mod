//
//  UMManager.m
//  HDHLProject
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UMManager.h"
#import "MPNotificationView.h"
#import "PushNotificaitonModel.h"

@interface UMManager () {
    BOOL _isWake; //是否从后台唤醒
}
@end
@implementation UMManager

static id instance;
+ (id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)setUMessageLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:UMENG_APPKEY launchOptions:launchOptions];
    //for log
    [UMessage setLogEnabled:NO];
    [UMessage setBadgeClear:NO];
    [UMessage setAutoAlert:NO];
    
#define _IPHONE80_ 80000
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
}

+ (NSString *)retureDeviceToken:(NSData *)deviceToken {
    NSString  *device_token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                stringByReplacingOccurrencesOfString: @">" withString: @""]
                               stringByReplacingOccurrencesOfString: @" " withString: @""];
    return device_token;
}


+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
}

//推送功能未开启
+ (void)didFailToRegisterForRemoteNotifications {
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (type == UIRemoteNotificationTypeNone) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"开启推送功能 请在iPhone的\"设置\"-\"通知\"功能中，找到应用程序更改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
}

#pragma mark -
#pragma mark - HandleRemoteNotificaiton

- (void)isWakeValue:(BOOL)value {
    _isWake = value;
}

/**
 * 处理推送
 *
 *  @param notificationModel 推送内容
 */
- (void)handleRemoteNotificaiton:(NSDictionary *)launchOptions {
    //消息数清空
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //判断程序是不是由推送服务完成的
    if (launchOptions) {
        NSDictionary* pushNotificationKey = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (pushNotificationKey) { //点击通知进来
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //根据model处理消息
                PushNotificaitonModel *pushNotificaitonModel = [[PushNotificaitonModel alloc] initWithDictionary:pushNotificationKey];
                [pushNotificaitonModel handle];
            });
        } else { //在当前程序中
            PushNotificaitonModel *pushNotificaitonModel = [[PushNotificaitonModel alloc] initWithDictionary:launchOptions];
            
            //如果没有登录或者登录信息和推送的user_id不匹配则不显示推送消息
            if(![AccountHelper isLogin] || ![User_Id isEqualToString:pushNotificaitonModel.user_id]) {
                return;
            }
            
            if (_isWake) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [pushNotificaitonModel handle];
                });
            } else {
                NSString *title = [NSString isBlankString:pushNotificaitonModel.brand_name] ? @"新消息" : pushNotificaitonModel.brand_name;
                [MPNotificationView notifyWithText:title detail:pushNotificaitonModel.alert image:[UIImage imageNamed:@"icon"] duration:kMPNotificationDuration andTouchBlock:^(id block) {
                     [pushNotificaitonModel handle];
                }];
            }
        }
    }

    _isWake = NO;
}

//处理从短信或者浏览器打开应用
+ (void)handleRemoteOpenURL:(NSURL *)url {

}

@end
