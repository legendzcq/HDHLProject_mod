//
//  CallPhoneView.h
//  Carte
//
//  Created by ligh on 14-12-30.
//
//

#import "XibView.h"

@interface CallPhoneView : XibView

//单个电话号码（字符串）
- (void)showInView:(UIView *)inView phoneNum:(NSString *)number;
//多个电话号码（数组）
- (void)showInView:(UIView *)inView phoneNumArray:(NSArray *)numberArray;

@end
