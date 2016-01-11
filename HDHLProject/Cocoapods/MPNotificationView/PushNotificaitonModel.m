//
//  RemoteNotificaitonModel.m
//  Carte
//
//  Created by ligh on 14-5-28.
//
//

#import "PushNotificaitonModel.h"
#import "LoginVC.h"
#import "MessageCenterVC.h"
#import "WebVC.h"

@implementation PushNotificaitonModel

- (id)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
        self.user_id    = [dict stringForKey:@"user_id"];
        self.brand_name = [dict stringForKey:@"brand_name"];
        self.content    = [dict stringForKey:@"content"];
        self.type       = [dict stringForKey:@"type"];
        self.order_id   = [dict stringForKey:@"id"];
        self.alert      = [[dict dictionaryForKey:@"aps"] stringForKey:@"alert"];
    }
    return self;
}

- (void)handle {
    //未登录状态
    if (![AccountHelper isLogin]) {
        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType) {
            //登录完成后 如果当前登录用户的id和推送返回的uid一致 则显示推送消息 否则返回到首页
            if ([User_Id isEqualToString:_user_id]) {
                [self gotoPushNotificaitonVC];
            } else {
                [[KAPP_DELEGATE navigationController] popToRootViewControllerAnimated:YES];
            }
        }];
        //登陆页
        LoginVC *loginVC = [[LoginVC alloc] init];
        [[KAPP_DELEGATE navigationController] pushViewController:loginVC animated:YES];
    } else {
        if ([User_Id isEqualToString:_user_id]) {
            [self gotoPushNotificaitonVC];
        }
    }
}

//从推送消息跳转到指定页面
- (void)gotoPushNotificaitonVC {
    if (_type.intValue ==  PushNotificaitonTypeMessage) {
        MessageCenterVC *messageVC = [[MessageCenterVC alloc] init];
         [[KAPP_DELEGATE navigationController] pushViewController:messageVC animated:YES];
    } else {
        if (!_order_id) {
            return;
        }
        WebVC *webVC= [[WebVC alloc]initWithContentID:_order_id];
        [[KAPP_DELEGATE navigationController] pushViewController:webVC  animated:YES];
    }
}


@end
