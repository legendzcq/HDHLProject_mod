//
//  TimeSegment.h
//  Carte
//
//  Created by ligh on 14-5-10.
//
//

#import "BaseModelObject.h"

/**
 *  送餐时间
 */
@interface TimeSegment : BaseModelObject

@property (retain,nonatomic) NSString *minute;//送餐时间
@property (retain,nonatomic) NSString *time;//时间戳


@end
