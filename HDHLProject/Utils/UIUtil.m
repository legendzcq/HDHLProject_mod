//
//  UIUtil.m
//  
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"


typedef enum{
	kTypeImageRectangleV,
	kTypeImageRectangleH,
	kTypeImageSquare
} ImageType;


//other consts
typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;


@implementation UIUtil

// Remove all the subviews of the given view.
+ (void)removeSubviews: (UIView *)superview{
	for( UIView* view in superview.subviews ){
		[view removeFromSuperview];
	}
}

// Return the formated string by a given date and seperator.
+ (NSString *)getStringWithDate:(NSDate *)date seperator:(NSString *)seperator{
	return [self getStringWithDate:date seperator:seperator includeYear:YES];
}

// Return the formated string by a given date and seperator.
+ (NSDate *)getDateWithString:(NSString *)str formate:(NSString *)formate{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSDate *date = [formatter dateFromString:str];
	return date;
}

+ (NSString *)getStringWithData:(NSDate *)date format:(NSString*)format {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:format];
	NSString *string = [formatter stringFromDate:date];
	return string;
}

// Return the formated string by a given date and seperator, and specify whether want to include year.
+ (NSString *)getStringWithDate:(NSDate *)date seperator:(NSString *)seperator includeYear:(BOOL)includeYear{
	if( seperator==nil ){
		seperator = @"-";
	}
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	if( includeYear ){
		[formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",seperator,seperator]];
	}else{
		[formatter setDateFormat:[NSString stringWithFormat:@"MM%@dd",seperator]];
	}
	NSString *dateStr = [formatter stringFromDate:date];
	
	return dateStr;
}

// return the date by given the interval day by today. interval can be positive, negtive or zero. 
+ (NSDate *)theDateRelativeTodayWithInterval:(NSInteger)interval{
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval)];
}

// return the date by given the interval day by given day. interval can be positive, negtive or zero. 
+ (NSDate *)theDateRelativeGivenDayWithInterval:(NSInteger)interval date:(NSDate *)date{
	NSTimeInterval givenDateSecInterval = [date timeIntervalSinceDate:[self theDateRelativeTodayWithInterval:0]];
	return [NSDate dateWithTimeIntervalSinceNow:(24*60*60*interval+givenDateSecInterval)];
}

+ (NSString *)getWeekdayWithDate:(NSDate *)date{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    
	NSString *weekdayStr = nil;
	[formatter setDateFormat:@"c"];
	NSInteger weekday = [[formatter stringFromDate:date] integerValue];
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
	return weekdayStr;
}

+ (void)showHint:(UIView *)viewToShowHint 
      hintCenter:(CGPoint)hintCenter
     textContent:(NSString*)text{
	[UIUtil showHint:viewToShowHint 
          hintCenter:hintCenter
         textContent:text
	 timeToDisappear:2];
}
+ (void)showHint:(UIView *)viewToShowHint 
      hintCenter:(CGPoint)hintCenter
     textContent:(NSString*)text
 timeToDisappear:(NSInteger)t{
	if (viewToShowHint == nil) {
		viewToShowHint = [UIApplication sharedApplication].keyWindow;
	}
	UIView *hintView = [viewToShowHint viewWithTag:kTagHintView];
	UIFont *textFont = [UIFont systemFontOfSize:28];
	CGFloat maxWidth = 255;
	int textLines = [text numberOfLinesWithFont:textFont
                                  withLineWidth:maxWidth];
//	CGFloat textHeight = [text heightWithFont:textFont
//                                withLineWidth:maxWidth];
	int hintLblTag = 1;
	UILabel *hintLbl;
	if( !hintView ){
		hintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 256, 64)];
		hintView.backgroundColor = [UIColor clearColor]; 
		hintView.tag = kTagHintView;
		[viewToShowHint addSubview:hintView];
		//alert_frameImg_light
		UIImageView *frameImageView = [[UIImageView alloc] initWithFrame:hintView.bounds];
		frameImageView.image = [[UIImage imageNamed:@"alert_frameImg_light.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
		frameImageView.frame = hintView.bounds;		
		[hintView addSubview:frameImageView];
		
		hintLbl = [UILabel labelWithFrame:hintView.bounds
                                                  text:text
                                             textColor:[UIColor whiteColor]
                                                  font:textFont
                                                   tag:hintLblTag
                                             hasShadow:NO];
        hintLbl.textAlignment = UITextAlignmentCenter;
		hintLbl.numberOfLines = textLines;
		//[hintLbl sizeToFit];
		[hintView addSubview:hintLbl];
	}else {
		hintLbl = (UILabel*)[hintView viewWithTag:hintLblTag];
		hintLbl.text = text;
		hintLbl.numberOfLines = textLines;
		//[hintLbl sizeToFit];
	}
	hintLbl.left = round(hintLbl.left);
	hintLbl.top = round(hintLbl.top);
    hintView.center = hintCenter;
	//[UIUtil adjustPositionToPixel:hintLbl];
	
	CATransform3D transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
	hintView.layer.transform = transform;
	hintView.alpha = 0;
	transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	hintView.layer.transform = transform;
	hintView.alpha = 1;
	[UIView commitAnimations];
	
	if (t > 0) {
		transform = CATransform3DMakeScale(0.001, 0.001, 0.001);
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:t];
		[UIView setAnimationDuration:.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		hintView.layer.transform = transform;
		hintView.alpha = 0;
		[UIView commitAnimations];
	}
}

+ (NSString*)urlEncode:(NSString*)url stringEncoding:(NSStringEncoding)stringEncoding {
	NSArray *escapeChars = @[@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,	@"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*"];
	
	NSArray *replaceChars = @[@"%3B" , @"%2F" , @"%3F" , @"%3A" , 
                             @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A"];
	
	int len = [escapeChars count];
	
	NSString *temp = [url stringByAddingPercentEscapesUsingEncoding:stringEncoding];
	
	for(int i = 0; i < len; i++)
	{
		temp = [temp stringByReplacingOccurrencesOfString:escapeChars[i]
                                               withString:replaceChars[i]
                                                  options:NSLiteralSearch
                                                    range:NSMakeRange(0, [temp length])];
	}
	
	NSString *outString = [NSString stringWithString:temp];
	
	return outString;
	
}

+ (void)adjustPositionToPixel:(UIView*)view{
	view.center = CGPointMake(round(view.center.x), round(view.center.y));
}
+ (void)adjustPositionToPixelByOrigin:(UIView*)view{
	view.left = round(view.left);
	view.top = round(view.top);
}

+ (BOOL)isHighResolutionDevice {
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	if (version >= 4.0) { //iOS4
		UIScreen *mainScreen = [UIScreen mainScreen];
		if( mainScreen.scale>1 ){ //iPhone4
		}
		return TRUE;
	}
	return FALSE;
}

+ (NSString*) imageName:(NSString*) name {
	if (![UIUtil isHighResolutionDevice]) {
		name = [name stringByAppendingString:@".png"];
	}
	return name;
}
+ (void)setRoundCornerForView:(UIView*)view 
                   withRadius:(CGFloat)r{
    view.layer.cornerRadius = r;
    [view setNeedsDisplay];
}

+ (void)setBorderForView:(UIView*)view 
               withWidth:(CGFloat)width
               withColor:(UIColor*)color{
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    [view setNeedsDisplay];
}

+ (CGSize)getFillInImageSize:(CGSize)imgSize frameSize:(CGSize)frameSize{
	CGFloat newWidth;
	CGFloat newHeight;
	BOOL isFitWidth = YES;
	if( [[self class] getImageTypeWithSize:imgSize]==kTypeImageRectangleH ){
		if( [[self class] getImageTypeWithSize:frameSize]==kTypeImageRectangleH && frameSize.width/frameSize.height>imgSize.width/imgSize.height ){
			isFitWidth = NO;
		}
	}else if( [[self class] getImageTypeWithSize:imgSize]==kTypeImageRectangleV ){
		isFitWidth = NO;
		if( [[self class] getImageTypeWithSize:frameSize]==kTypeImageRectangleV && frameSize.height/frameSize.width>imgSize.height/imgSize.width ){
			isFitWidth = YES;
		}
	}else{
		if( [[self class] getImageTypeWithSize:frameSize]==kTypeImageRectangleH ){
			isFitWidth = NO;
		}
	}
	if( isFitWidth ){
		newWidth = frameSize.width;
		newHeight = imgSize.height/imgSize.width*newWidth;
	}else{
		newHeight = frameSize.height;
		newWidth = imgSize.width/imgSize.height*newHeight;
	}
	return CGSizeMake(newWidth, newHeight);
}

+ (NSInteger)getImageTypeWithSize:(CGSize)imgSize{
	NSInteger type;
	if( imgSize.width>imgSize.height ){
		type = kTypeImageRectangleH;
	}else if( imgSize.width<imgSize.height ){
		type = kTypeImageRectangleV;
	}else{
		type = kTypeImageSquare;
	}
	return type;
}
+(UIImage*)getImage:(UIImage*)pImage width:(float)width height:(float)heigth
{
    CGSize size = CGSizeMake(width, heigth);
    UIGraphicsBeginImageContext(size);
    [pImage drawInRect:CGRectMake(0,0, size.width, size.height)];
    pImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pImage;
}


+ (void)showHorizontalAnimation:(UIView*)view endX:(CGFloat)endx
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.left = endx;
    [UIView commitAnimations];
}

+ (void)showVerticalAnimation:(UIView*)view endY:(CGFloat)endy
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.top = endy;
    [UIView commitAnimations];
}

@end
