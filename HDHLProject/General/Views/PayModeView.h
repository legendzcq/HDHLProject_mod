//
//  PayModeView.h
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "ComboBoxView.h"

/**
 *  支付方式view
 */

@protocol PayModeViewDelegate <NSObject>
- (void)payModeViewSwitchShow:(BOOL)switchShow;
@end

@interface PayModeView : ComboBoxView

@property (nonatomic, assign) id <PayModeViewDelegate> payModeDelegate;
-(void)setOptionsModelArray:(NSArray *)optionsModelArray;
@end
