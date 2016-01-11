//
//  VersionServiceManager.m
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "VersionServiceManager.h"
#import "VersionDetectionRequest.h"

@interface VersionServiceManager () {
    BOOL _foreUpate; //是否强制更新
}
@end

@implementation VersionServiceManager

DEF_SINGLETON(VersionServiceManager)

- (void)dealloc {

}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (BOOL)isFirstRunning
{
    NSString *localVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"localVersion"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([localVersion isEqualToString:appVersion]) {
        return NO;
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:appVersion forKey:@"localVersion"];
        return YES;
    }
}

//强制更新
- (void)isHasNewVersionForeUpate {
    if (_foreUpate) {
        [self isHasNewVersion:NO];
    }
}

//发送版本更新请求
- (void)isHasNewVersion:(BOOL)showNoNewVersionsMessage {
    //无 user_id 不能开启强制更新
    if ([NSString isBlankString:User_Id]) {
        return;
    }
    
    // app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow(infoDictionary);
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"-------------当前版本：%@",app_Version);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:app_Version forKey:@"app_version"];
    [params setObject:@"ios" forKey:@"app_type"];
    
    [VersionDetectionRequest requestWithParameters:params withIndicatorView:showNoNewVersionsMessage ? KAPP_WINDOW : nil onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess) {
            VersionModel *versionModel = request.resultDic[KRequestResultDataKey];
            if (versionModel.isnew.intValue == 1) {
                //强制升级
                if (versionModel.up.intValue == 1) {
                    _foreUpate  = YES;
                    NSArray *subViewAry = [NSArray arrayWithArray:[KAPP_WINDOW subviews]];
                    for (UIView *subView in subViewAry) {
                        if ([subView isKindOfClass:[MessageAlertView class]]) {
                            return ;
                        }
                    }
                    [[MessageAlertView viewFromXIB] showAlertViewInView:KAPP_WINDOW msgXML:versionModel.desc cancelTitle:nil confirmTitle:@"立即升级" onCanleBlock:nil onConfirmBlock:^{
                        [self startAppStore];
                    }];
                } else {
                    [[MessageAlertView viewFromXIB]showAlertViewInView:KAPP_WINDOW msgXML:versionModel.desc cancelTitle:@"取消" confirmTitle:@"立即升级" onCanleBlock:nil onConfirmBlock:^{
                        [self startAppStore];
                    }];
                }
            } else {
                if (showNoNewVersionsMessage) {
                    [[MessageAlertView viewFromXIB]showAlertViewInView:KAPP_WINDOW msg:request.resultDic[@"msg"] cancelTitle:@"取消" confirmTitle:@"确定" onCanleBlock:nil onConfirmBlock:nil];
                }
            }
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
         
    }];
}

/**
 *  启动app store
 */
- (void)startAppStore
{
    if (IOS_VERSION_CODE  < 7) {
        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@",[ConfigHelper appleID]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
    } else {
        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",[ConfigHelper appleID]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
    }
}

@end
