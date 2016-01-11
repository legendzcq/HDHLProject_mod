//
//  NSDate+ITTAdditions.m
//
//  Created by guo hua on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+ITTAdditions.h"

@implementation NSDate(ITTAdditions)
+ (NSString *) timeStringWithInterval:(NSTimeInterval)time{
    
    int distance = [[NSDate date] timeIntervalSince1970] - time;
    NSString *string;
    if (distance < 1){//avoid 0 seconds
        string = @"刚刚";
    }
    else if (distance < 60) {
        string = [NSString stringWithFormat:@"%d秒前", (distance)];
    }
    else if (distance < 3600) {//60 * 60
        distance = distance / 60;
        string = [NSString stringWithFormat:@"%d分钟前", (distance)];
    }  
    else if (distance < 86400) {//60 * 60 * 24
        distance = distance / 3600;
        string = [NSString stringWithFormat:@"%d小时前", (distance)];
    }
    else if (distance < 604800) {//60 * 60 * 24 * 7
        distance = distance / 86400;
        string = [NSString stringWithFormat:@"%d天前", (distance)];
    }
    else if (distance < 2419200) {//60 * 60 * 24 * 7 * 4
        distance = distance / 604800;
        string = [NSString stringWithFormat:@"%d周前", (distance)];
    }
    else {
        NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        }
        string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
        [dateFormatter release];
        
    }
    return string;
}

-(NSDateComponents *)components:(NSCalendarUnit)unitFlags
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *targetDateComponents = [gregorian components:unitFlags fromDate:self];
    [gregorian release];
    return  targetDateComponents;
}

- (NSString *)stringWithSeperator:(NSString *)seperator{
	return [self stringWithSeperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)dateWithString:(NSString *)str formate:(NSString *)formate{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	[formatter release];
	return date;
}

- (NSString *)stringWithFormat:(NSString*)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:self];
	[formatter release];
	return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
- (NSString *)stringWithSeperator:(NSString *)seperator includeYear:(BOOL)includeYear{
	if( seperator==nil ){
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear ){
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}else{
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:self];
	[formatter release];
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero. 
+ (NSDate *)relativedDateWithInterval:(NSInteger)interval{
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero. 
- (NSDate *)relativedGivenDateWithInterval:(NSInteger)interval{
	NSTimeInterval givenDateSecInterval = [self timeIntervalSinceDate:[NSDate relativedDateWithInterval:0]];
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

+ (NSDate *)dateWithTimeInterval:(NSTimeInterval)timeInterval {
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSTimeInterval)timeIntervalWithDate:(NSDate *)date {
    return date.timeIntervalSince1970;
}

+ (NSString *)monthWithData:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)yearWithData:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)weekdayStringWithPrefix:(NSString *)prefix weekday:(NSInteger)weekday
{
    if( weekday==1 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"日"];
    }else if( weekday==2 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"一"];
    }else if( weekday==3 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"二"];
    }else if( weekday==4 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"三"];
    }else if( weekday==5 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"四"];
    }else if( weekday==6 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"五"];
    }else if( weekday==7 ){
        return [NSString stringWithFormat:@"%@%@",prefix,@"六"];
    }
    
    return nil;
}

- (NSString *)weekday{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:self] integerValue];
	if( weekday==1 ){
		weekdayStr = @"星期日";
	}else if( weekday==2 ){
		weekdayStr = @"星期一";
	}else if( weekday==3 ){
		weekdayStr = @"星期二";
	}else if( weekday==4 ){
		weekdayStr = @"星期三";
	}else if( weekday==5 ){
		weekdayStr = @"星期四";
	}else if( weekday==6 ){
		weekdayStr = @"星期五";
	}else if( weekday==7 ){
		weekdayStr = @"星期六";
	}
	[formatter release];
	return weekdayStr;
}

-(NSInteger)daysOfEndDate:(NSDate *)endDate
{
    
    NSDate *dayDate = [NSDate dateWithString:[self stringWithFormat:KDefaultDateForamt] formate:KDefaultDateForamt];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:dayDate toDate:endDate options:0];
    
    
    NSInteger days = [components day] ;
    
    NSInteger month = [components month] ;
    
    
    return (month * 30) + days;
}

+ (NSString *)stringOfDefaultFormatWithInterval:(NSTimeInterval)time
{
    return  [[NSDate dateWithTimeIntervalSince1970:time] stringOfDefaultFormat];
}

- (NSString *)stringOfDefaultFormat
{
    return [self stringWithFormat:KDefaultDateForamt];
}

//农历阳历节日显示规则
+ (NSString *)getHoliDayDate:(NSDate *)date {
    NSString *lunarHoliDay = [self getLunarHoliDayDate:date];
    NSString *solarHoliDay = [self getSolarHoliDayDate:date];
    if ([NSString isBlankString:solarHoliDay]) {
        return lunarHoliDay;
    }
    return solarHoliDay;
}

+ (NSString *)getLunarHoliDayDate:(NSDate *)date {
    NSTimeInterval timeInterval_day = 60*60*24;
    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:nextDay_date];
    if (1 == localeComp.month && 1 == localeComp.day) {
        [localeCalendar release];
        return @"除夕";
    }
    NSDictionary *chineseHoliDayDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"春节", @"1-1",
                                    @"元宵节", @"1-15",
                                    @"端午节", @"5-5",
                                    @"七夕节", @"7-7",
                                    @"中元节", @"7-15",
                                    @"中秋节", @"8-15",
                                    @"重阳节", @"9-9",
                                    @"腊八", @"12-8",
                                    @"小年", @"12-24",
                                    nil];
    localeComp = [localeCalendar components:unitFlags fromDate:date];
    NSString *key_str = [NSString stringWithFormat:@"%d-%d", (int)localeComp.month, (int)localeComp.day];
    
    NSString *chineseHoliDay = [chineseHoliDayDic objectForKey:key_str];
    if ([NSString isBlankString:chineseHoliDay]) {
        return @"";
    }
    return chineseHoliDay;
}

+ (NSString *)getSolarHoliDayDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMdd"];
    NSString *key_str = [dateFormatter stringFromDate:date];
    NSDictionary *chineseHoliDayDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"元旦", @"0101",
                                       @"情人节", @"0214",
                                       @"妇女节", @"0308",
                                       @"植树节", @"0312",
                                       @"消费者权益日", @"0315",
                                       @"愚人节", @"0401",
                                       @"劳动节", @"0501",
                                       @"青年节", @"0504",
                                       @"护士节", @"0512",
                                       @"儿童节", @"0601",
                                       @"建党节", @"0701",
                                       @"建军节", @"0801",
                                       @"父亲节", @"0808",
                                       @"毛泽东逝世纪念日", @"0909",
                                       @"教师节", @"0910",
                                       @"孔子诞辰", @"0928",
                                       @"国庆节", @"1001",
                                       @"老人节", @"1006",
                                       @"联合国日", @"1024",
                                       @"孙中山诞辰纪念", @"1112",
                                       @"澳门回归纪念", @"1220",
                                       @"圣诞节", @"1225",
                                       @"毛泽东诞辰纪念日", @"1226 ",
                                       nil];
    NSString *chineseHoliDay = [chineseHoliDayDic objectForKey:key_str];
    if ([NSString isBlankString:chineseHoliDay]) {
        return @"";
    }
    return chineseHoliDay;
}

@end
