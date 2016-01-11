//
//  ActivityView.m
//  Carte
//
//  Created by liu on 15-5-6.
//
//

#import "ActivityView.h"

@implementation ActivityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    _titleLabel.textColor = ColorForHexKey(AppColor_Content_Text3);

}

@end
