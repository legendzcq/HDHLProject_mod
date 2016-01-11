//
//  AnimationPicker.h
//  PMS
//
//  Created by ligh on 14/11/3.
//
//

#import "XibView.h"

//从底部弹起 并且带有透明遮盖 picker
@interface AnimationPicker : XibView

@property (strong,nonatomic) IBOutlet UIView *alphaView;
@property (strong,nonatomic) IBOutlet UIView *contentView;

- (void)showPickerInView:(UIView *)inView;
- (void)dismissPicker;

- (IBAction)touchAlphaViewAction:(id)sender;
- (IBAction)okAction:(id)sender;
- (IBAction)cancelAction:(id)sender;


@end
