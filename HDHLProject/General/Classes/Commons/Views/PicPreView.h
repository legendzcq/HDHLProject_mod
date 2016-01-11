//
//  PicPreView.h
//  Carte
//
//  Created by user on 14-4-24.
//
//

#import "XibView.h"
#import "GoodsModel.h"
#import "ImageModel.h"

@protocol PicPreViewDelegate;


/**
 *  大图预览view
 */
@interface PicPreView : XibView

@property (assign,nonatomic) id<PicPreViewDelegate> delegate;

- (void)showWithImageUrl:(NSString *) url;
- (void)showWithGoodsModel:(GoodsModel *) goodsModel;
- (void)showWithImagesModel:(ImageModel *)imageModel showPrice:(BOOL)showPrice;
- (void)dismiss;

@end


@protocol PicPreViewDelegate <NSObject>

- (void)didSelectedGoodsModels:(GoodsModel *) goodsModel;
- (void)didDeleteGoodsModels:(GoodsModel *) goodsModel;
- (void)didCancelSelectOrders; //取消当前选菜

@end