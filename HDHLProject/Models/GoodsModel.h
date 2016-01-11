//
//  GoodsModel.h
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import <UIKit/UIKit.h>

//默认是菜品
typedef enum
{
    GoodsProductType,//菜品
    BoxProductType,//餐盒
    SendGoodsServiceProductType,//送餐服务
    ServiceMoneyProductType//服务费
    
}ProductType;//产品类型

/**
 *  菜品model
 */
@interface GoodsModel : BaseModelObject

@property (retain,nonatomic) NSString *cate_id;//	分类id
@property (retain,nonatomic) NSString *issend;//	是否支持外卖1是/0否
@property (retain,nonatomic) NSString *goods_id;// 菜品id
@property (retain,nonatomic) NSString *goods_name;//	菜品名称（不显示）
@property (retain,nonatomic) NSString *goods_title;//	菜品标题（显示）
@property (retain,nonatomic) NSString *goods_py;//	菜品名称PY（不显示）
@property (retain,nonatomic) NSString *goods_szm; //菜品首字母

@property (retain,nonatomic) NSString *image_big;//	菜品大图

@property (retain,nonatomic) NSString *image_small;//	菜品小图
@property (retain,nonatomic) NSString *market_price;//	菜品市场价
@property (retain,nonatomic) NSString *goods_price;//	菜品购买价
@property (retain,nonatomic) NSString *goods_number;//	购买的数量
@property (assign,nonatomic) NSInteger count;//	购买的数量
@property (retain,nonatomic) NSString *goodsidarr;//分类下的菜品列表
@property (retain,nonatomic) NSString *goods_units;//菜品单位
@property (retain,nonatomic) NSString *is_gift;//是否为赠品
@property (retain,nonatomic) NSString *is_sale; //是否为促销菜
@property (retain,nonatomic) NSString *max_num; //促销菜品限购数量，0表示不限
@property (retain,nonatomic) NSString *change_number;//
@property (retain,nonatomic) NSString *goods_desc;

@property (retain,nonatomic) NSString *goods_activity; //赠品活动

@property (assign,nonatomic) ProductType productType;


//业务逻辑需要
@property  (assign,nonatomic) NSUInteger selectedNumber;//选择此菜品的数量

@end
