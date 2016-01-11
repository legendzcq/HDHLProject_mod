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
@property (strong, nonatomic) MyCollectionModel *myCollectionModel;

@end



@implementation MyCollectionCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColor];    
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)loadColor
{
    _brandTitleLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _balanceLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _balanceMoneyLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
}
-(void)setCellData:(id)cellData
{
    _myCollectionModel = (MyCollectionModel *)cellData;
    _brandTitleLabel.text = _myCollectionModel.store_name;
    _balanceMoneyLabel.text = [NSString stringWithFormat:@"￥%@",_myCollectionModel.user_money];
    [_brandImageView setImageWithUrlString:_myCollectionModel.image_url placeholderImage:KMiddPlaceHolderImage];
}

- (IBAction)gotoRecharVCAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(checkMyCollectionCellWithModel:WithIndexPath:)]) {
        [self.delegate checkMyCollectionCellWithModel:_myCollectionModel WithIndexPath:self.indexPath];
    }
}

@end
