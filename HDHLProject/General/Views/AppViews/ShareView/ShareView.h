//
//  ShareView.h
//  Carte
//
//  Created by ligh on 14-4-16.
//
//

#import "AnimationPicker.h"
#import "ActivityModel.h"
#import "ActivityShareRequest.h"
/**
 *  分享
 */
@interface ShareView : AnimationPicker

//分享方法
- (void)showInView:(UIView *)inView shareContent:(NSString *)shareContent title:(NSString *)title;
- (void)showInView:(UIView *)inView shareContent:(NSString *)shareContent;
//分享方法（短信）
- (void)showInView:(UIView *)inView currentContainer:(UIViewController *)controller shareContent:(NSString *)shareContent title:(NSString *)title;
- (void)showInView:(UIView *)inView currentContainer:(UIViewController *)controller shareContent:(NSString *)shareContent;

//活动分享
- (void)showInView:(UIView *)inView currentContainer:(UIViewController *)controller title:(NSString *)title withActivityModel:(ActivityModel *)activityModel;
- (void)sendActivityShareWithShareType:(ShareChannelType)shareType;

//分享内容
@property (strong,nonatomic) NSString *shareContent;

@end
