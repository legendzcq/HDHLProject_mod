//
//  BookSeatDateModel.h
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import <UIKit/UIKit.h>
#import "HoursModel.h"

/**
 *  预定座位支持的时间
 */
@interface PayInfoDateModel : BaseModelObject

@property (retain,nonatomic) NSString *md;//日期
@property (retain,nonatomic) NSString *week;//星期几
@property (retain,nonatomic) NSString *order_time;//时间
@property (retain,nonatomic) NSString *mdtime;//时间

@property (retain,nonatomic) NSArray  *hours;

-(NSString *) orderTimeOfForamt;

@end
