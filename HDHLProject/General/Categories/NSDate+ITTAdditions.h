//
//  NSDate+ITTAdditions.h
//
//  Created by guo hua on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KDefaultDateForamt @"yyyy年MM月dd日"
#define KcouponDateForamt  @"yyyy-MM-dd"

@interface NSDate(ITTAdditions)
+ (NSString *)timeStringWithInterval:(NSTimeInterval) time;
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate;
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval;
- (NSDate *)relativedGivenDateWithInterval:(NSInteger)interval;

+ (NSDate *)dateWithTimeInterval:(NSTimeInterval)timeInterval; //时间戳转NSDate
+ (NSTimeInterval)timeIntervalWithDate:(NSDate *)date;         //NSDate转时间戳
+ (NSString *)monthWithData:(NSDate *)date; //NSDate转 月份
+ (NSString *)yearWithData:(NSDate *)date; //NSDate转 年份

- (NSString *)stringWithSeperator:(NSString *)seperator;
- (NSString *)stringWithFormat:(NSString*)format;
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear;
- (NSString *)weekday;
+ (NSString *)weekdayStringWithPrefix:(NSString *)prefix weekday:(NSInteger)weekday;
- (NSInteger) daysOfEndDate:(NSDate *)endDate;

+ (NSString *)stringOfDefaultFormatWithInterval:(NSTimeInterval) time;

- (NSDateComponents*) components:(NSCalendarUnit)unitFlags;

//节假日
+ (NSString *)getHoliDayDate:(NSDate *)date; //农历阳历节日显示规则
+ (NSString *)getLunarHoliDayDate:(NSDate *)date; //农历节日
+ (NSString *)getSolarHoliDayDate:(NSDate *)date; //阳历节日

@end