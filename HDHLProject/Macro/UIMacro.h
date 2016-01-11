//
//  UIMacro.h
//  MinFramework
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_UIMacro_h
#define MinFramework_UIMacro_h

//间隔
#define MARGIN_S            5
#define MARGIN_M            10
#define MARGIN_L            15
#define LEFT_SPACE          MARGIN_M //工程中通用的左边距设定

//屏幕相关
#define SCREEN_BOUNDS          [[UIScreen mainScreen] bounds]
#define SCREEN_HEIGHT          SCREEN_BOUNDS.size.height
#define SCREEN_WIDTH           SCREEN_BOUNDS.size.width

//默认图相关
#define KSmallPlaceHolderImage1 [UIImage imageNamed:@"public_placeholder1"]
#define KSmallPlaceHolderImage  [UIImage imageNamed:@"public_placeholder2"]
#define KMiddPlaceHolderImage   [UIImage imageNamed:@"public_placeholder5"]
#define KBigPlaceHodlerImage    [UIImage imageNamed:@"public_placeholder4"]
#define KSLPlaceHodlerImage     [UIImage imageNamed:@"public_placeholder3"]
#define KNotLoginUserIconImage   [UIImage imageNamed:@"public_notlogin_icon"]

#define STATUS_BAR_HEIGHT 20 //状态栏相关
#define TAB_BAR_HEIGHT    49 //TabBar相关
#define NAV_BAR_HEIGHT    44 //NavBar相关（不包含状态栏的高度的）

//字体相关
#define FONT_S             [UIFont systemFontOfSize:12]
#define FONT_M             [UIFont systemFontOfSize:14]
#define FONT_L             [UIFont systemFontOfSize:17]
#define FONT_L1            [UIFont systemFontOfSize:19]
#define FONT_HTMLTEXT      [UIFont systemFontOfSize:17]
//粗体
#define BOLD_FONT_S         [UIFont boldSystemFontOfSize:12]
#define BOLD_FONT_M         [UIFont boldSystemFontOfSize:14]
#define BOLD_FONT_L         [UIFont boldSystemFontOfSize:17]


#pragma mark -
#pragma mark - 工程内字体设置

#define FONT_STORE_NAME   [UIFont boldSystemFontOfSize:17] //店名
//点菜清单
#define FONT_DISH_NAME    [UIFont systemFontOfSize:14] //菜名
#define FONT_DISH_COUNT   FONT_M //数量
#define FONT_DISH_PRICE   FONT_M //会员价（其他价格）
#define FONT_DISH_MARKET  FONT_M //市场价

#define FONT_LIST_TITLE   [UIFont systemFontOfSize:15] //一般列表的标题
#define FONT_LIST_CONTENT [UIFont systemFontOfSize:15] //一般列表的内容

//页面底部视图 支付金额
#define FONT_BOTTOM_PRICE        [UIFont systemFontOfSize:17]
//页面底部视图 右按钮
#define FONT_BOTTOM_RIGHT_BUTTON [UIFont systemFontOfSize:17]
//页面底部按钮
#define FONT_BOTTOM_BUTTON       [UIFont systemFontOfSize:17]


#endif




















