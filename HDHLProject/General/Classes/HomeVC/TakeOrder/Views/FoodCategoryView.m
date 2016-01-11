//
//  FoodCategoryView.m
//  Carte
//
//  Created by ligh on 14-3-27.
//
//

#import "FoodCategoryView.h"
#import "FrameLineView.h"

@interface FoodCategoryView ()
{
    GoodsCategoryModel      *_goodsCategoryModel;
    IBOutlet UIButton       *_numberButton;//选中的数量
    IBOutlet FrameLineView  *_spaceFrameLine;
}
@end

@implementation FoodCategoryView


- (void)dealloc
{
    RELEASE_SAFELY(_goodsCategoryModel);
    RELEASE_SAFELY(_numberButton);
    RELEASE_SAFELY(_categoryNameButton);
    RELEASE_SAFELY(_spaceFrameLine);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
    
    [_categoryNameButton.titleLabel setNumberOfLines:2];
    _categoryNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _spaceFrameLine.top = self.height - 0.5;
}

- (void)setGoodsCategoryModel:(GoodsCategoryModel *)goodsCategoryModel
{
    if (_goodsCategoryModel!= goodsCategoryModel)
    {
        RELEASE_SAFELY(_goodsCategoryModel);
        _goodsCategoryModel = goodsCategoryModel;
    }
 
    [self refreshUI];
}

- (void)refreshUI
{
    [_categoryNameButton setTitle:_goodsCategoryModel.cate_name forState:UIControlStateNormal];
    [_numberButton setTitle:[NSString stringWithFormat:@"%d",(int)_goodsCategoryModel.selectedNumber] forState:UIControlStateNormal];
    _numberButton.hidden = YES; //_goodsCategoryModel.selectedNumber <= 0;
}

- (void)loadColorConfig
{
    [_categoryNameButton setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateSelected];
    [_categoryNameButton setTitleColor:ColorForHexKey(AppColor_Third_Level_Title1) forState:UIControlStateNormal];
    [_numberButton setTitleColor:ColorForHexKey(AppColor_Label_Text) forState:UIControlStateNormal];
}

@end
