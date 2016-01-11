//
//  MyDishCardCell.m
//  Carte
//
//  Created by liu on 15-4-14.
//
//

#import "MyDishCardCell.h"
#import  <QuartzCore/QuartzCore.h>
#import "SDWebImageManager.h"

#define MyDishCell_BackView_LeftEdgas 40  //黑色条的左间距
#define MyDishCell_BackView_HeadEdgas 10 //黑色条的上间距
#define MyDishCell_ImageView_LeftEdgas 10 //图片左间距


@implementation MyDishCardCell

- (void)awakeFromNib
{
    self.contentView.backgroundColor = UIColorFromRGB_BGColor;
    self.storeNameLabel.textColor = ColorForHexKey(AppColor_Label_Text);
    [self roundViewWithView:self.storePhotoView];
    [self roundViewWithView:self.storeNameBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self roundViewTwoCornerWithView:self.backGroudView];
}

- (void)configerWithDataSource:(id)objectData
{
    if(![objectData isKindOfClass:[BrandModel class]]){
        return ;
    }
    BrandModel *brandModel = objectData;
    [self.storePhotoView setImageWithUrlString:brandModel.image_big placeholderImage:KMiddPlaceHolderImage];
    self.storeNameLabel.text = brandModel.store_name;
    self.DistanceLabel.text = brandModel.distance;
}


- (void)roundViewWithView:(UIView *)view
{
    view.layer.masksToBounds = YES ;
    view.layer.cornerRadius  = 6 ;
}
- (void)showDistanceOrNotWithBool:(BOOL)locationSucess
{
    if(locationSucess){
        self.DistanceLabel.hidden = NO ;
        self.addressImageView.hidden = NO;
    }else{
        self.DistanceLabel.hidden = YES ;
        self.addressImageView.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
//圆俩角
- (void)roundViewTwoCornerWithView:(UIView *)view
{
    UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:
                              UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc] init];
    maskLayer.frame=self.contentView.bounds;
    maskLayer.path=maskPath.CGPath;
    view.layer.mask=maskLayer;
    view.layer.masksToBounds=YES;
}
- (void)dealloc
{
    RELEASE_SAFELY(self.brandModel);
}
- (IBAction)ChooseStoreBtnClick:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(startToChooseStoreWithModel:)])
    {
        [self.delegate startToChooseStoreWithModel:self.brandModel];
    }
}
@end
