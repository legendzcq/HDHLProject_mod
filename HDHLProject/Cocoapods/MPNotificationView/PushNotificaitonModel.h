//
//  RemoteNotificaitonModel.h
//  Carte
//
//  Created by ligh on 14-5-28.
//
//

//消息类型
typedef NS_ENUM(NSInteger, PushNotificaitonType) {
    PushNotificaitonTypeMessage = 1,
    PushNotificaitonTypeActivity = 2,
};

#import <UIKit/UIKit.h>

/**
 *  远程推送通知
 */
@interface PushNotificaitonModel : BaseModelObject

@property (retain,nonatomic) NSString *alert;//通知提示消息
@property (retain,nonatomic) NSString *user_id;//新消息所属用户
@property (retain,nonatomic) NSString *brand_name;//商家名称
@property (retain,nonatomic) NSString *order_id ;//订单id
@property (retain,nonatomic) NSString *type;//通知类型
@property (retain,nonatomic) NSString *content;

//指定消息处理
- (void)handle;

@end
