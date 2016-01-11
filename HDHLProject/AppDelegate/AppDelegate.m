//
//  AppDelegate.m
//  HDHLProject
//
//  Created by Mac on 15/6/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "VersionServiceManager.h"
#import "LoginVC.h"


static BOOL firstStart = YES ;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc {
    RELEASE_SAFELY(_window);
    RELEASE_SAFELY(_navigationController);
    RELEASE_SAFELY(_rootViewController);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingViewRemove:) name:NotificationLoadingViewRemove object:nil];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:kApp_StatusBarStyle];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self initWithRootViewController];
    
    //友盟推送
    [UMManager setUMessageLaunchingWithOptions:launchOptions];
    //处理推送消息
    [[UMManager shareManager] handleRemoteNotificaiton:launchOptions];
    //注册新浪微博
    [ShareViewManager registerSinaApp];
    //注册微信
    [ShareViewManager registerWeChatApp];
    //注册QQ
    [ShareViewManager registerQQApp];
    //百度地图注册
    [[BMKLocationManager defaultInstance] startBMKMapSettingManager];

    [[SDImageCache sharedImageCache] getDiskSize];
    [[SDImageCache sharedImageCache] getMemorySize];
    
    return YES;
}

- (void)initWithRootViewController {
    //中心控制器
    _rootViewController = [[BetterTabBarController alloc] init];
    [_rootViewController configTabBarWithViewControllerArray:@[@"MyDishCardVC", @"OrderVC", @"MeVC"]];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
    _navigationController.automaticallyAdjustsScrollViewInsets = NO;
    _navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    _navigationController.navigationBar.hidden = YES;
    
    self.window.rootViewController = _navigationController;
    [self.window makeKeyAndVisible];
    
    /*
    //是否第一次运行
    if ([[VersionServiceManager sharedInstance] isFirstRunning]) {
        WelcomeViewController *welcomeVC = [[WelcomeViewController alloc] init];
        [welcomeVC showWelcomeView:welcomeVC finishBlock:^(BOOL removeSuccess) {
        }];
    } else {
        [LoadingViewController showLoadingView];
    }*/
    [LoadingViewController showLoadingView];

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //如果用户按照正常流程支付 则取消程序自动处理home键返回
    AliPayManager *manager =[AliPayManager shareManager];
    [AliPayManager cancelPreviousPerformRequestsWithTarget:manager selector:@selector(handleHomeBack) object:nil];
    
    if([[ShareViewManager sharedInstance] handleOpenURLSina:url])
    {
        return  YES;
    } else if ([[ShareViewManager sharedInstance] handleOpenURLTencentQQ:url]) {
        return YES;
    } else if ([[ShareViewManager sharedInstance] handleOpenURLWeChat:url]) {
        return YES;
    } else if ([[ShareViewManager sharedInstance] handleOpenURLTencentWb:url]) {
        return YES;
    } else if( [[AliPayManager shareManager] handleOpenURL:url]) {
        return YES;
    } else {
        [UMManager handleRemoteOpenURL:url];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //如果用户按照正常流程支付 则取消程序自动处理home键返回
    AliPayManager *manager =[AliPayManager shareManager];
    [AliPayManager cancelPreviousPerformRequestsWithTarget:manager selector:@selector(handleHomeBack) object:nil];
    
    if([[ShareViewManager sharedInstance] handleOpenURLSina:url]) {
        return  YES;
    } else if ([[ShareViewManager sharedInstance] handleOpenURLTencentQQ:url]) {
        return YES;
    } else if ([[ShareViewManager sharedInstance] handleOpenURLWeChat:url]) {
        return YES;
    } else if ([[ShareViewManager sharedInstance] handleOpenURLTencentWb:url]) {
        return YES;
    } else if( [[AliPayManager shareManager] handleOpenURL:url]) {
        return YES;
    } else {
        [UMManager handleRemoteOpenURL:url];
    }
    return YES;
}

#pragma mark -
#pragma mark - RemoteNotifications

//消息推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMManager registerDeviceToken:deviceToken];
    NSString *deviceTokenStr = [UMManager retureDeviceToken:deviceToken];
    [AccountHelper saveDeviceToken:deviceTokenStr];

    if (![NSString isBlankString:User_Id] && ![NSString isBlankString:deviceTokenStr]) {
        [UploadDeviceTokenRequest requestWithParameters:@{@"user_id":([NSString isBlankString:User_Id]) ? @"":User_Id, @"device_tokens":deviceTokenStr, @"device_tokens_from":@"1"} withIndicatorView:nil onRequestFinished:^(ITTBaseDataRequest *request) {
        } onRequestFailed:^(ITTBaseDataRequest *request)
        {
        }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //处理推送消息（友盟后台）
    [UMManager didReceiveRemoteNotification:userInfo];
    //处理推送消息
    [[UMManager shareManager] handleRemoteNotificaiton:userInfo];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    //推送功能未开启
    [UMManager didFailToRegisterForRemoteNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //友盟管理类
    [[UMManager shareManager] isWakeValue:NO];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //友盟管理类
    [[UMManager shareManager] isWakeValue:YES];
    //版本强制更新
    [[VersionServiceManager sharedInstance] isHasNewVersionForeUpate];
    //如果用户通过双击home键返回到app 客户端无法接受此事件 需要手动调用处理
    [[AliPayManager shareManager] performSelector:@selector(handleHomeBack) withObject:nil afterDelay:0.5];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(!firstStart){
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:nil];
    }// 涉及到定位权限改变，网络状态改变，通知主页面更新. 第一次启动发送 此通知将造成主页面刷新失败
    //友盟管理类
    firstStart = NO ;
    [[UMManager shareManager] isWakeValue:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 
#pragma mark - NSNotification
- (void)loadingViewRemove:(NSNotification *)notification {
    //版本检测更新
    [[VersionServiceManager sharedInstance] isHasNewVersion:NO];
}

//全局控制禁止转屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

@end
