//
//  MessageCenterModel.h
//  Carte
//
//  Created by zln on 14-9-9.
//
//

#import "BaseModelObject.h"

@interface MessageCenterModel : BaseModelObject

@property (retain,nonatomic) NSNumber *message_id;
//消息标题
@property (retain,nonatomic) NSString *title;
//消息时间
@property (retain,nonatomic) NSString *addtime;
//消息内容
@property (retain,nonatomic) NSString *content;
//消息状态
@property (retain,nonatomic) NSString *type;

//已读/未读
@property (retain,nonatomic) NSString *status;
//活动ID
@property (retain,nonatomic) NSString *activity_id;
//品牌名称
@property (retain,nonatomic) NSString *brand_name;
//店铺名称
@property (retain,nonatomic) NSString *store_name;
@end
