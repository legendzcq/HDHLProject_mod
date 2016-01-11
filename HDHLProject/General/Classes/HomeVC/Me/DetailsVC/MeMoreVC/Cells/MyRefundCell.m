//
//  MyRefundCell.m
//  HDHLProject
//
//  Created by hdcai on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyRefundCell.h"


@interface MyRefundCell()
{
    //商家名称
    IBOutlet UILabel *_brandNameLabel;
    //退款金额标题
    IBOutlet UILabel *_refundTitleLabel;
    //退款金额
    IBOutlet UILabel *_refundMoneyLabel;
    //详细信息
    IBOutlet UILabel *_detailInfoLabel;
    //退款状态
    IBOutlet UILabel *_dealStatusLabel;
}
@end
@implementation MyRefundCell


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self disableSelectedBackgroundView];
}

- (void)loadColor
{
    _brandNameLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _refundTitleLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _refundMoneyLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    _detailInfoLabel.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    _dealStatusLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
}
-(void)setCellData:(id)cellData
{
    
    
}



@end
