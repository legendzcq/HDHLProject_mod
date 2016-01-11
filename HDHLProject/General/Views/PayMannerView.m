//
//  PayMannerView.m
//  Carte
//
//  Created by hdcai on 15/4/15.
//
//

#import "PayMannerView.h"
#import "PayModeModel.h"
#import "FrameLineView.h"

#define PayManner_HightSize    48.0
#define LeftWith_Border    10

@implementation PayMannerView

{
    NSArray * _dataArray;

}

+ (void)showInView:(UIView *)fatherView WithModelArray:(NSArray *)array WithSelectedBlock:(MySelectBlcok)selectBlock
{
    PayMannerView *payMannerView = [PayMannerView viewFromXIB];
    payMannerView.userInteractionEnabled  = YES ;
    payMannerView.selectBlock = selectBlock;
    [payMannerView adjustViewFrameWithArray:array WithView:fatherView];
    [payMannerView creatButtonsWithArray:array];
    [fatherView addSubview:payMannerView];
}

- (void)awakeFromNib
{
//    self.backgroundColor = AddStore_BackGroudColor;
//    self.storeView.layer.masksToBounds = YES ;
//    self.storeView.layer.cornerRadius = AddStore_CornerRadius;
//    titleLabel.textColor = ColorForHexKey(AppColor_About_Share_Text);
//    FrameLineView *lineLabel = [[FrameLineView alloc]initWithFrame:AddStore_LineFrame];
//    lineLabel.backgroundColor =  ColorForHexKey(AppColor_AddDishCard_line);
//    [self. storeView addSubview:lineLabel];
}

//适配视图
- (void)adjustViewFrameWithArray:(NSArray *)modelArray
                        WithView:(UIView *)fatherView
{
    self.frame = CGRectMake(0, 0, fatherView.size.width, fatherView.size.height);
    
    int cardCount = (int)modelArray.count;
    float fatherViewWidth = fatherView.size.width;
    
    _dataArray = [NSArray arrayWithArray:modelArray];
    int  storeViewHeight = cardCount * PayManner_HightSize;
//    self.frame = CGRectMake(0, 0, fatherViewWidth, storeViewHeight);
    self.frame = CGRectMake(0, 0, fatherViewWidth, storeViewHeight);
    fatherView.frame = CGRectMake(0, 0, fatherViewWidth, storeViewHeight);
}
//创建品牌列表
- (void)creatButtonsWithArray:(NSArray *)modelArray
{
    for (int index = 0; index <modelArray.count; index++)
    {
        [self creatButtonsWithIndex:index WithModel:modelArray[index]];
    }
}

- (void)creatButtonsWithIndex:(int)index WithModel:(id)model
{
    PayModeModel *payModeModel = [[PayModeModel alloc]init];
    payModeModel = (PayModeModel*)model;
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    float headRdges = index*PayManner_HightSize;
    
    payBtn.frame = CGRectMake(0, headRdges, self.frame.size.width, PayManner_HightSize);
    payBtn.tag = index;
    [payBtn setTitleColor:ColorForHexKey(AppColor_Amount3) forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payBtn];
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_topup_gray"]];
    imageV.frame = CGRectMake(payBtn.frame.size.width - 32, 12, 25, 25);
//    imageV.hidden = YES;
    [payBtn addSubview:imageV];
    if ([model is_default].intValue) {
        imageV.hidden = NO;
        imageV.image = [UIImage imageNamed:@"order_topup_gray_click"];
        self.selectBlock(model);
    }
    
    UILabel * titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(LeftWith_Border, 8, 100, 32)];
    titleLbl.text = [model pay_name];
    titleLbl.textColor = ColorForHexKey(AppColor_Content_Text3);
    titleLbl.font = [UIFont systemFontOfSize:14];
    [payBtn addSubview:titleLbl];
    
    if (index>0) {
        FrameLineView * partLineLbl = [[FrameLineView alloc]initWithFrame:CGRectMake(LeftWith_Border, 0, self.frame.size.width-LeftWith_Border, 0.5)];
        [payBtn addSubview:partLineLbl];
    }
}

//
- (void)storeBtnClick:(UIButton *)storeBtn
{
    UIImageView * imageV = [storeBtn.subviews firstObject];
//    imageV.hidden = NO;
    imageV.image = [UIImage imageNamed:@"order_topup_gray_click"];
    for (UIButton *btn in self.subviews) {
        if (btn.tag != storeBtn.tag) {
            UIImageView * imageV = [btn.subviews firstObject];
//            imageV.hidden = YES;
            imageV.image = [UIImage imageNamed:@"order_topup_gray"];
        }
    }
    
    if(!_dataArray.count){
        return ;
    }
    id model = _dataArray[storeBtn.tag];
    self.selectBlock(model);
}

- (void)dealloc
{
    RELEASE_SAFELY(_selectBlock);
    RELEASE_SAFELY(_dataArray);
}

@end
