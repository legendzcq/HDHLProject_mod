//
//  UserModel.h
//  PMS
//
//  Created by ligh on 14/10/22.
//
//

#import "BaseModelObject.h"

//用户信息
@interface UserModel : BaseModelObject

@property (strong,nonatomic) NSString *user_id; //用户id
@property (strong,nonatomic) NSString *gender;  //性别
@property (strong,nonatomic) NSString *mobile;  //手机号
@property (strong,nonatomic) NSString *phone;   //固话


@property (strong,nonatomic) NSString *brandId;//品牌id
@property (strong,nonatomic) NSString *username;//用户昵称
@property (strong,nonatomic) NSString *password;//用户密码
@property (strong,nonatomic) NSString *realName;//姓名
@property (strong,nonatomic) NSString *birthday;//生日
@property (strong,nonatomic) NSString *email;//
@property (strong,nonatomic) NSString *province;//省份编号
@property (strong,nonatomic) NSString *city;//城市编号
@property (strong,nonatomic) NSString *district;//区编号
@property (strong,nonatomic) NSString *address;//地址
@property (strong,nonatomic) NSString *location;//定位
@property (strong,nonatomic) NSString *userPic;

@property (strong,nonatomic) NSArray  *paysArray;//支付方式
@property (strong,nonatomic) NSString *userSmallPic;//用户小图
@property (strong,nonatomic) NSString *userBigPic;//用户大图
@property (strong,nonatomic) NSString *user_money;//用户余额
@property (strong,nonatomic) NSString *brand_name;


@property (retain,nonatomic) NSString *image_small;//小图
@property (retain,nonatomic) NSString *image_big;//大图预览
//消息个数
@property (retain,nonatomic) NSString *message_number;

@end
