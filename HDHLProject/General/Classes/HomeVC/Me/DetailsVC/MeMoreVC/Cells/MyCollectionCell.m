//
//  MyCollectionCell.m
//  HDHLProject
//
//  Created by hdcai on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCollectionCell.h"
@interface  MyCollectionCell()
@property (strong, nonatomic) IBOutlet WebImageView *brandImageView;
@property (strong, nonatomic) IBOutlet UILabel *brandTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceMoneyLabel;



@end



@implementation MyCollectionCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColor];    
    self.contentView.backgroundColor = [UIColor clearColor];
    [self disableSelectedBackgroundView];
}

- (void)loadColor
{
    _brandTitleLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _balanceLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _balanceMoneyLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
}
-(void)setCellData:(id)cellData
{
    

}




- (IBAction)gotoRecharVCAction:(id)sender {
}

@end
