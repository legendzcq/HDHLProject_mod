//
//  MoreVC.h
//  Carte
//
//  Created by ligh on 14-4-10.
//
//

#import "BetterVC.h"
/**
 *  设置页面
 */
@protocol LogoutButtonClickDelegate <NSObject>

-(void)didLogoutAction;

@end


@interface MoreVC : BetterVC

@property(nonatomic,assign)id<LogoutButtonClickDelegate>delegate;

- (IBAction)GoToFeedBackAction:(UIButton *)sender;
- (IBAction)AboutUsAction:(UIButton *)sender;

@end
