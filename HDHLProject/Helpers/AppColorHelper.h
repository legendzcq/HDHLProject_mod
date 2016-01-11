//
//  AppColorHelper.h
//  Carte
//
//  Created by ligh on 14-7-15.
//
//

#import <Foundation/Foundation.h>


//创建颜色
#define UIColorFromRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)       UIColorFromRGBA(r,g,b,1)
//程序背景色默认
#define UIColorFromRGB_BGColor UIColorFromRGB(245,245,245)


/*
 *首页颜色keys----------------------------------------------------
 */
#define AppColor_Home_StatusBarStyle     @"StatusBarStyle"
#define AppColor_Home_NavigationBarTitle @"navigation_bar_title"
#define AppColor_Home_TabBatItemNormal   @"home_tabbarNormal"
#define AppColor_Home_TabBatItemSelect   @"home_tabbarSelect"
//
#define AppColor_Home_City              @"home_city"
#define AppColor_Home_Store             @"home_store"
#define AppColor_Home_Order             @"home_order"
#define AppColor_Home_Groupon           @"home_groupon"
#define AppColor_Home_Me                @"home_me"
#define AppColor_Home_Out               @"home_takeout"
#define AppColor_Home_OrderSeat         @"home_orderseat"
#define AppColor_Home_OrderTitle        @"home_ordertitle"

#define AppColor_Home_NavBg1 @"home_navigation_bar_bg1" //粉红
#define AppColor_Home_NavBg2 @"home_navigation_bar_bg2" //白色

/*
 *内页颜色keys----------------------------------------------------
 */
// 订单详情
#define   AppColor_Code_Label  @"order_code_label"



//2.1.2  导航栏中跳转功能
#define AppColor_Navigation_Bar_Function  @"navigation_bar_function"

//2.2  标签文字
#define AppColor_Label_Text  @"label_text"

//2.3.1按钮文字的默认状态
#define AppColor_Default_Button_Text @"default_button_text"

//2.3.2默认状态空心形式1
#define AppColor_Defaule_Hollow_Button_Text1  @"defaule_hollow_button_text1"

//2.3.3默认状态空心形式2
#define AppColor_Defaule_Hollow_Button_Text2 @"defaule_hollow_button_text2"

//2.3.4默认状态空心形式3
#define AppColor_Defaule_Hollow_Button_Text3 @"defaule_hollow_button_text3"

//2.3.5按钮不可点击1
#define AppColor_Disable_Click_Button_Text1 @"disable_click_button_text1"

//2.3.6默认状态空心形式4
#define AppColor_Defaule_Hollow_Button_Text4 @"defaule_hollow_button_text4"

//2.3.7	不可点击按钮2
#define AppColor_Disable_click_button_text2 @"disable_click_button_text2"

//2.4.1	弹出框文字颜色1
#define AppColor_Popup_Box_Text1 @"popup_box_text1"

//2.4.2	弹出框文字颜色2
#define AppColor_Popup_Box_Text2 @"popup_box_text2"

//2.4.3	弹出框文字颜色3
#define AppColor_Popup_Box_Text3 @"popup_box_text3"

//2.5.1	分享页标题文字
#define AppColor_Share_Title @"share_title"

//2.5.2	分享页叙述性文字----------------我的button颜色
#define AppColor_Share_Button_Text @"share_button_text"

//2.5.3	列表页中关于分享的叙述性文字
#define AppColor_About_Share_Text @"about_share_text"
// 我的订单里面按钮TITLE
#define AppColor_Btn_TitleSelected  @"myordes_btn_title_text1"

//选择框文字
//2.6.1  选择框文字1
#define AppColor_Select_Box_Text1  @"select_box_text1"

//2.6.2  选择框文字2
#define AppColor_Select_Box_Text2  @"select_box_text2"

//2.6.3 选择框文字3
#define AppColor_Select_Box_Text3  @"select_box_text3"

//2.6.4 选择框文字4
#define AppColor_Select_Box_Text4  @"select_box_text4"

//2.6.5 选择框文字5
#define AppColor_Select_Box_Text5  @"select_box_text5"

//15.6.1 详情页充值无效颜色
#define AppColor_Select_Box_Text6  @"select_box_text6"


//2.7优惠券和优惠活动文字
//2.7.1  优惠券左边叙述性文字(可用的情况)
#define AppColor_Usable_Coupon_Left_Text      @"usable_coupon_left_text"

//2.7.2  优惠券左边叙述性文字(已过期的情况)
#define AppColor_Overdue_Coupon_Left_Text     @"overdue_coupon_left_text"

//2.7.3  优惠券右边叙述性文字(可用的情况)1
#define AppColor_Usable_Coupon_Right_Text1    @"usable_coupon_right_text1"

//2.7.4  优惠券右边叙述性文字(可用的情况)2和优惠活动  内容文字
#define AppColor_Usable_Coupon_right_Text2    @"usable_coupon_right_text2"

//2.7.5  优惠券右边叙述性文字(已过期的情况)
#define AppColor_Overdue_Coupon_Right_text    @"overdue_coupon_right_text"

//2.7.6  优惠券和优惠活动标题文字
#define AppColor_Coupon_and_Promotions_Title  @"coupon_and_promotions_title"

//2.7.7  优惠提示文字
#define AppColor_Preferential_Prompt_Text     @"preferential_prompt_text"

//2.7.8  优惠码默认颜色
#define AppColor_Default_Promotion_Code       @"default_promotion_code"

//2.7.9  优惠码置灰颜色
#define AppColor_Gray_Promotion_Code          @"gray_promotion_code"


//2.8 输入框提示语
//2.8.1  默认状态
#define AppColor_Input_Box_Prompt_Default  @"input_box_prompt_default"

//选中状态
#define AppColor_Input_Box_Prompt_Checked  @"input_box_prompt_checked"

//2.8.2	跳转文字1
#define AppColor_Jump_Function_Text1 @"jump_function_text1"

//2.8.3	跳转文字2
#define AppColor_Jump_Function_Text2 @"jump_function_text2"

//2.8.4	跳转文字3
#define AppColor_Jump_Function_Text3 @"jump_function_text3"

//2.8.5	跳转文字4
#define AppColor_Jump_Function_Text4 @"jump_function_text4"

//2.8.6	跳转文字5
#define AppColor_Jump_Function_Text5 @"jump_function_text5"

//2.8.7	跳转文字6
#define AppColor_Jump_Function_Text6 @"jump_function_text6"

//2.8.8	跳转文字7
#define AppColor_Jump_Function_Text7 @"jump_function_text7"

//2.8.9	跳转文字8
#define AppColor_Jump_Function_Text8 @"jump_function_text8"

//2.8.9	跳转文字9
#define AppColor_Jump_Function_Text9 @"jump_function_text9"


//2.9.1	订单状态类文字
#define AppColor_Order_Status_Text @"order_status_text"

//2.9.2	使用状态类文字
#define AppColor_Usage_State_Text @"usage_state_text"

//2.10.1	提示类文字1
#define AppColor_Prompt_Text1 @"prompt_text1"

//2.10.2	提示类文字2
#define AppColor_Prompt_Text2 @"prompt_text2"

//2.10.3	提示类文字3
#define AppColor_Prompt_Text3 @"prompt_text3"

//2.10.4	提示类文字4
#define AppColor_Prompt_Text4 @"prompt_text4"

//2.10.5	提示类文字5
#define AppColor_Prompt_Text5 @"prompt_text5"

//2.11.1	金额1
#define AppColor_Amount1 @"amount1"

//2.11.2	金额2
#define AppColor_Amount2 @"amount2"

//2.11.3	金额3
#define AppColor_Amount3 @"amount3"

//2.11.4	原价1
#define AppColor_Original_Price1 @"original_price1"

//2.11.5	原价2
#define AppColor_Original_Price2 @"original_price2"

//2.11.6	优惠金额
#define AppColor_Coupon_Amount @"coupon_amount"

//2.12.1	一级标题1
#define AppColor_First_Level_Title1 @"first_level_title1"

//2.12.2	一级标题2
#define AppColor_First_Level_Title2 @"first_level_title2"

//2.12.3  二级标题1
#define AppColor_Second_Level_Title1   @"second_level_title1"

//2.12.4	二级标题2
#define AppColor_Second_Level_Title2 @"second_level_title2"

//14.5.20  二级标题3
#define AppColor_Second_Level_Title3 @"second_level_title3"

//2.12.5	三级标题1
#define AppColor_Third_Level_Title1 @"third_level_title1"

//2.12.6	三级标题2
#define AppColor_Third_Level_Title2 @"third_level_title2"

//2.12.7	四级标题
#define AppColor_Fourth_Level_Title @"fourth_level_title"

//2.12.8	内容文字1
#define AppColor_Content_Text1 @"content_text1"

//2.12.9	内容文字2
#define AppColor_Content_Text2 @"content_text2"

//2.12.10	内容文字3
#define AppColor_Content_Text3 @"content_text3"

//2.12.11	功能默认文字颜色
#define AppColor_Function_Default_Text @"function_default_text"

//2.12.12	功能置灰文字颜色
#define AppColor_Function_Gray_Text @"function_gray_text"


//2.13.1	下拉框文字1
#define AppColor_Spinner_Text1 @"spinner_text1"

//2.13.2	下拉框文字2
#define AppColor_Spinner_Text2 @"spinner_text2"

////2.14.1	输入框文字 (同 2.8.1)
//#define AppColor_Tnput_Box_Text @"input_box_text"

//15.3.31   转字符串格式
#define StringFormat(a) [NSString stringWithFormat:@"%@",(a)]

//15.4.15   增加饭卡的颜色
#define AppColor_AddDishCard_line @"addcard_line"
#define AppColor_AddDishCard_background @"addcard_backgroud"

//15.4.21  增加tabbar颜色
#define AppColor_tabbar_unselect @"tabbar_unselect"
#define AppColor_tabbar_select @"tabbar_select"

//15.4.27 我的订单背景色
#define AppColor_Opertion_Color @"MyOrders_BackGroudColor"
//15.4.28 充值确认页充值金额title颜色
#define AppColor_Amount4 @"amount4"
//15.4.28 充值确认页 确认按钮字体颜色
#define AppColor_Amount5 @"amount5"

#define   AppColor_CheckActivity_title @"check_activity_title"


/*
 *
 */

//点菜 底部视图颜色值
#define AppColor_OrderBottom_BgColor @"order_bottom_bgColor"
#define AppColor_OrderBottom_Selected @"order_bottom_selected"
#define AppColor_OrderBottom_Disabled @"order_bottom_disabled"
#define AppColor_OrderBottom_Disabled_Title  @"order_bottom_disabled_title"
#define AppColor_OrderCart_ClearText @"order_cart_clear_text"
#define AppColor_OrderList_NameText @"order_list_nameText"
#define AppColor_Order_NumberText @"order_orderNumber"
#define AppColor_Order_Take_CellBg @"order_take_cellbg"

//钱的颜色1
#define AppColor_Money_Color_Text1   @"money_color_text1"
#define AppColor_Brand_Activity_TextColor   @"brand_activity_textColor"

/**
 *  应用程序颜色值
 */

//十六进制颜色值表示
#define ColorForHexKey(key)     [AppColorHelper colorWithHexForKey:key]
#define HomeColorForHexKey(key) [AppColorHelper homeColorWithHexForKey:key]
//状态栏颜色设定
#define kApp_StatusBarStyle [AppColorHelper preferredStatusBarStyle]

@interface AppColorHelper : NSObject

+ (id)shareInstance;

//IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexForKey:(NSString *)key;
- (UIColor *)colorWithHexForKey:(NSString *)key;

+ (UIColor *)homeColorWithHexForKey:(NSString *)key;
- (UIColor *)homeColorWithHexForKey:(NSString *)key;

+ (UIStatusBarStyle)preferredStatusBarStyle;

@end
