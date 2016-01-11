//
//  OrderDropDownView.h
//  Carte
//
//  Created by ligh on 14-12-30.
//
//

#import "XibView.h"

@protocol OrderDropDownDelegate <NSObject>
- (void)dropDownViewCellClicked:(NSInteger)index;
- (void)dropDownViewDismiss;
@end

@interface OrderDropDownView : XibView

@property (nonatomic, assign) id <OrderDropDownDelegate> delegate;

- (void)orderDropDownViewShowInView:(UIView *)view withShow:(BOOL)show withBottomHeight:(CGFloat)bottomHeight;
- (void)orderDropDownViewHidden;
- (void)setImageAndLabelWith:(BOOL)show;

@end
