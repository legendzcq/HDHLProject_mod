//
//  CityListVC.h
//  Carte
//
//  Created by ligh on 15-1-31.
//
//

#import "BetterTableViewVC.h"
#import "CityModel.h"
/**
 *  城市选择页面
 */

@protocol CityDelegate <NSObject>
- (void)citySelectedAction:(NSString *)cityName;
@end

@interface CityListVC : BetterTableViewVC

-(id)initWithBrandID:(NSString *)brandID;
@property (nonatomic, assign) id <CityDelegate> cityDelegate;

@end
