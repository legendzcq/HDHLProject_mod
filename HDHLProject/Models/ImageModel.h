//
//  ImageModel.h
//  Carte
//
//  Created by ligh on 14-5-15.
//
//

#import <UIKit/UIKit.h>

@interface ImageModel : BaseModelObject

@property (retain,nonatomic) NSString *image_title; //	菜品标题（显示）
@property (retain,nonatomic) NSString *image_desc;  //	菜品描述
@property (retain,nonatomic) NSString *image_small; //	菜品小图
@property (retain,nonatomic) NSString *image_big;   //	菜品大图

@property (retain,nonatomic) NSString *image_id;     //菜品图id
@property (retain,nonatomic) NSString *market_price; //菜品价格
@property (retain,nonatomic) NSString *image_click;  //点赞

@end


