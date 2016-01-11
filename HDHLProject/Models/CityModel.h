//
//  CityModel.h
//  Carte
//
//  Created by ligh on 14-3-26.
//
//

#import "BaseModelObject.h"

/**
 *  城市信息model
 */
@interface CityModel : BaseModelObject

@property (assign,nonatomic) BOOL userCity;

@property (nonatomic,retain) NSString *city_name;
@property (nonatomic,retain) NSString *city_id;
@property (nonatomic,retain) NSString *store_count;

@property (nonatomic,assign) BOOL checked;

+(NSString *) formatCityName:(NSString *) cityName;

@end
