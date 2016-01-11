//
//  BrandModel.h
//  Carte
//
//  Created by liu on 15-4-17.
//
//

#import "BaseModelObject.h"

@interface BrandModel : BaseModelObject

@property (nonatomic,retain) NSString * phone;
@property (nonatomic,retain) NSString * stime;
@property (nonatomic,retain) NSString * location;
@property (nonatomic,retain) NSString * status;

@property (nonatomic,retain) NSString * lng;
@property (nonatomic,retain) NSString * is_seat;
@property (nonatomic,retain) NSString * is_groupon;
@property (nonatomic,retain) NSString * is_send;
@property (nonatomic,retain) NSString * id;
@property (nonatomic,retain) NSString * is_dishes;
@property (nonatomic,retain) NSString * adress;
@property (nonatomic,retain) NSString * etime;
@property (nonatomic,retain) NSString * store_name;
@property (nonatomic,retain) NSString * lat;
@property (nonatomic,retain) NSString * _version;

//品牌ID
@property (nonatomic,retain) NSString * brand_id;
//品牌名称
@property (nonatomic,retain) NSString * brand_name;
//品牌展示图
@property (nonatomic,retain) NSString * show_img;
//饭卡图
@property (nonatomic,retain) NSString * image_big;
//店铺ID
@property (nonatomic,retain) NSString * store_id;
// 余额
@property (nonatomic,retain) NSString * user_money;
//默认外卖地址
@property (nonatomic,retain) NSString * default_address;
//外卖地址id
@property (nonatomic,retain) NSString * a_id;
//我的品牌图标
@property (nonatomic,retain) NSString * brand_icons ;
/** 成员属性名 */
@property (nonatomic, readonly) NSString *name;
//距离
@property (nonatomic,strong) NSString *distance;
@end
