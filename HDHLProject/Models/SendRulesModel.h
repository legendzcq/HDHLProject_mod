//
//  SendRulesModel.h
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import <UIKit/UIKit.h>

/**
 *  送餐规则
 */
@interface SendRulesModel : BaseModelObject

@property (retain,nonatomic) NSString *send_intro;//	送餐须知
@property (retain,nonatomic) NSString *stime;//		送餐时间
@property (retain,nonatomic) NSString *etime;//		送餐时间
@property (retain,nonatomic) NSString *box_price;//		餐盒价格
@property (retain,nonatomic) NSString *send_price;//    送餐费
@property (retain,nonatomic) NSString *min_price;//		最低起送价格
@property (retain,nonatomic) NSString *is_discount;//	外卖是否支持折扣（不支持按照 市场价计算，支持按照购买价计算）

@property (retain,nonatomic) NSString *time_overplus;//当前时间段商家是否支持外卖

@property (retain,nonatomic) NSString *discount_rules;//	折扣描述


@end
