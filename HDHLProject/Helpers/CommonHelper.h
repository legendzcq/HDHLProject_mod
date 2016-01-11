//
//  CommonHelper.h
//  Carte
//
//  Created by zln on 14/11/25.
//
//

#import <Foundation/Foundation.h>

//订单类型
typedef enum
{
    
    MessageSeatOrderType = 1,//订座
    MessageTakeOrderType = 2,//点菜
    MessageTakewayOrderType = 4,//外卖
    MessageReminderOrderType = 3,//催单
    
    
} MessageOrderType;

//店员类型
typedef enum
{
    UserGenderIsMan = 1 ,//男士
    UserGenderIsWoman = 2, //女士
    UserGenderIsNo = 0//未知
    
}UserGender;

//外卖类型
typedef enum
{
    OutStatusShowNoAccept = 1,//未处理
    OutStatusShowAccept = 2  //已接受
    
}OutStatusShow;

//消费记录类型
typedef enum
{
    PayMentRecoderSeat = 1,//订座
    PayMentRecoderOrder = 2,//点菜
    PayMentRecoderGroup = 3,//团购
    PayMentRecoderTakeOut = 4,//外卖
    PayMentRecoderFastPay = 8//快捷支付
}PayMentRecoderStyle;

//是否是常用分店
typedef enum
{
    DefaultStoreStyleNO  = 0, //不是
    DefaultStoreStyleYES = 1, //是
}DefaultStoreStyle;

#define SeatOrderListOrderType @"1" //订座
#define TakeOrderListOrderType @"2" //点菜
#define GrouponOrderListOrderType @"3" //团购
#define TakewayOrderListOrderType @"4" //外卖


@interface CommonHelper : NSObject

@end
