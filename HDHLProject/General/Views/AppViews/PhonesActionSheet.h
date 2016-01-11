//
//  PhonesActionSheet.h
//  PMS
//
//  Created by ligh on 14-8-13.
//
//

#import "XibView.h"

@interface PhonesActionSheet : XibView

//根据电话号码显示actionsheet 电话号码可以是多个号码 可以用,和 空格分隔
-(void) showInView:(UIView *) inView phoneString:(NSString *) phoneString;

@end
