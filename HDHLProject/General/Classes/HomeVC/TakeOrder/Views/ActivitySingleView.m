//
//  ActivitySingleView.m
//  Carte
//
//  Created by ligh on 15-1-13.
//
//

#import "ActivitySingleView.h"

@interface ActivitySingleView ()
{
    IBOutlet UILabel *_activityTitleLabel;
    
    IBOutlet UIImageView *_selImageView;
    
}
@end

@implementation ActivitySingleView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setDataWithModel:(ActivityModel *)model
{
    _activityTitleLabel.text = model.activity_title;
    
    //填充数据
    
    if (model.selected) { //已选
        
        _selImageView.image = [UIImage imageNamed:@"order_topup_gray_click"];
        self.userInteractionEnabled = YES;
        
    } else {

        _selImageView.image = [UIImage imageNamed:@"order_topup_gray"];
        self.userInteractionEnabled = YES;
        
    }
}

- (void)hiddenSelImageView
{
    _selImageView.hidden = YES;
}

- (void)dealloc
{
    RELEASE_SAFELY(_activityTitleLabel);
    RELEASE_SAFELY(_selButton);
}

@end
