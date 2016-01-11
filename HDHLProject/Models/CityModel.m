//
//  CityModel.m
//  Carte
//
//  Created by ligh on 14-3-26.
//
//

#import "CityModel.h"

@implementation CityModel

+(NSString *)formatCityName:(NSString *)cityName
{
    
    if (!cityName)
    {
        return cityName;
    }
    
    NSRange range =  [cityName rangeOfString:@"市"];
    if (range.length > 0)
    {
        cityName = [cityName substringWithRange:NSMakeRange(0,cityName.length - range.length)];
    }

    return cityName;

}

@end
