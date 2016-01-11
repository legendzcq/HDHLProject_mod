//
//  AppActionSheet.m
//  PMS
//
//  Created by ligh on 14/11/3.
//
//

#import "AppActionSheet.h"

@interface AppActionSheet() {
    IBOutlet UIButton       *_cancelButton;
}
@end

@implementation AppActionSheet

- (void)dealloc {
    RELEASE_SAFELY(_actionBlock);
    RELEASE_SAFELY(_cancelButton);
}

- (void)showActionSheetInView:(UIView *)inView withTitleArray:(NSArray *)titleArray actionBlock:(AppActionSheetBlock )actionBlock {
    self.width = inView.width;
    self.actionBlock = actionBlock;
    
    float y = MARGIN_L;
    
    for (int i=0; i<titleArray.count; i++) {
        NSString *title = titleArray[i];
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton setBackgroundImage:UIImageForName(@"msg_alert_t_bg2") forState:UIControlStateNormal];
        [titleButton setTitle:title forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        titleButton.titleLabel.font = FONT_L1;
        titleButton.frame = CGRectMake(30, y, self.width - 60, 40);
        y = titleButton.bottom + MARGIN_M;
        [titleButton addTarget:self action:@selector(didSelectItemAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:titleButton];
    }
    
    _cancelButton.top = y;
    self.contentView.height = _cancelButton.bottom+MARGIN_M;

    [self showPickerInView:inView];
}

- (void)didSelectItemAction:(UIButton *)itemButton {
    [self dismissPicker];
    if(_actionBlock) {
        _actionBlock([itemButton titleForState:UIControlStateNormal],itemButton.tag);
    }
}

@end
