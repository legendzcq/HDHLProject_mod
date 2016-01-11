//
//  AppActionSheet.h
//  PMS
//
//  Created by ligh on 14/11/3.
//
//

#import "AnimationPicker.h"

typedef void(^AppActionSheetBlock)(NSString *,NSInteger);

//app 
@interface AppActionSheet : AnimationPicker
//
@property (copy,nonatomic) AppActionSheetBlock actionBlock;

//显示actionSheet
- (void)showActionSheetInView:(UIView *) inView withTitleArray:(NSArray *) titleArray actionBlock:(AppActionSheetBlock) actionBlock;

@end
