//
//  OrderDropButtonView.h
//  Carte
//
//  Created by ligh on 14-12-30.
//
//

#import "XibView.h"

@protocol DropButtonViewDelegate <NSObject>
- (void)dropButtonSelected;
- (void)dropButtonNormal;
@end

@interface OrderDropButtonView : XibView

@property (nonatomic, assign) id <DropButtonViewDelegate> delegate;

- (void)setImageChange:(BOOL)selected;
- (void)setTitleText:(NSString *)text;

@end
