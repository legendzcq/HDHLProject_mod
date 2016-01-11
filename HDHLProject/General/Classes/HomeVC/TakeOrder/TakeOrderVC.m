//
//  OrderDishesVC.m
//  Carte
//
//  Created by ligh on 14-3-27.
//
//

#import "TakeOrderVC.h"
#import "LoginVC.h"
#import "TakeOrderConfirmVC.h"
#import "HDCNotifyHUD.h"
#import "PickFoodCell.h"
#import "FoodCategoryView.h"
#import "TakeorderNoticeView.h"
#import "OrdersMenuView.h"
#import "FavourtStoreRequest.h"
//Models
#import "FoodModel.h"

#import "TakeOrderInitRequest.h"
#import "ShoopCartPayInfo.h"

#import "SearchViewOrder.h"

#import "TakeOrderSectionView.h"

#import "CallPhoneView.h"
#import "StoreBMapVC.h"
#import "PromptView.h"

#import "ActivityTipView.h"
#import "ActivityModel.h"

#import "SegmentTitleView.h"
#import "ActivityShowView.h"
#import "StoreDetailsRequest.h"
#import "StoreModel.h"
#import "QPCodeVC.h"
#import "OrderSeatVC.h"
#import "RechargeVC.h"
#import "StoreBMapVC.h"

#define kActiviytTipHeight 30 //顶部活动视图高度
#define kOrderCategoryWidth 90 //菜品分类宽度

#define kCartViewBottomSpace 56 //购物车顶部距离下父视图距离
#define kCartViewHighSpace 54   //购物车弹起 高出距离
#define kCartViewNormalLeftSpace 65 //结算金额 左距离
#define kCartViewHeightLeftSpace 10 //结算金额 左距离（弹起）
#define kZWLayerTag 300

@interface ZWCALayer : CALayer
@property (nonatomic, assign) NSInteger layerTag;
@end
@implementation ZWCALayer
@end


@interface TakeOrderVC () <PickFoodCellDelegate, OrdersMenuViewDelegate, SearchViewOrderDelegate, ActivityTipViewDelegate, TakeOrderConfirmDelegate, UIScrollViewDelegate, SegmentTitleViewDelegate>
{
    NSString *_storeID;
    NSString *_isFavourite; //收藏 0 未 1 已
    BOOL _categoryClicked;
    NSInteger _categoryIndex;
    
    //菜系分类scrollView
    IBOutlet UIView         *_footCategoryView; //右边菜单
    IBOutlet UIScrollView   *_foodCategoryScrollView; //左边菜单类栏目
    IBOutlet UIView         *_footCategorySearchView; //左上部搜索小视图
    
    //统计信息
    IBOutlet RTLabel        *_countLabel; //引入RTLabel的原因是 ios6以下不支持富文本
    TakeorderNoticeView     *_noticeView;//外卖规则
    //确认支付
    IBOutlet UIButton       *_confirmButton;
    
    //点过的菜单view
    OrdersMenuView          *_ordersMenuView;
    
    NSArray                 *_goodsCategoryArray;//菜品分类及菜品信息
    NSArray                 *_goodsCategoryArrayMemory;//(备份)菜品分类及菜品信息
    GoodsCategoryModel      *_selectedGoodsCategoryModel;//选中的菜品分类model
    NSMutableArray          *_totalDataArray; //所有类型dataArray源数据备份
    
    //外卖
    TakeOrderType           _takeOrderType;
    SendType                _sendType; //如果是外卖则属性是有用的  送餐/自提
    SendRulesModel          *_rulesModel;//外卖规则 只有在外卖时才有此值
    StoreModel              *_payInfoStoreMdoel;
    
    //搜索
    SearchViewOrder *_searchViewOrder;
    BOOL _searchBOOL;     //是否搜索判定
    
    //底部视图
    IBOutlet UIView *_bottomView;
    PromptView *_currentPromptView;
    
    //contentView
    CGFloat _contentViewTop;
    CGFloat _contentViewHeight;
    
    ActivityTipView *_activityTipView; //活动视图
    BOOL _activityTipBOOL;
    ActivityModel     *_activityModel;
    
    IBOutlet UIScrollView *_takeOrderScrollView; //点菜商家主视图
    IBOutlet UIView *_takeOrderView; //点菜视图
    IBOutlet UIView *_storeInfoView; //商家视图
    BOOL _takeOrderReqSuc; //点菜请求完毕
    BOOL _storeInfoReqSuc; //商家请求完毕
    UIView *_topBgView;
    SegmentTitleView *_segementView; //可点导航栏按钮
    IBOutlet UIView   *_cartView;
    IBOutlet UIButton *_cartNum;
    IBOutlet UIView   *_cartNoneView;
    IBOutlet UIView   *_cartHaveView;
    IBOutlet UILabel  *_cartNoneLabel;
    BOOL _closeActivityFirst;
    NSInteger _layerOriginTag1;
    NSInteger _layerOriginTag2;
#pragma mark - StoreInfoView Setting
    //顶部大图
    IBOutlet WebImageView *_storeHeadImageView;
    //二维码按钮
    IBOutlet UIButton *_qrCodeButton;
    //二维码文字
    IBOutlet UILabel *_qrCodeLabel;
    //订座按钮
    IBOutlet UIButton *_bookSeatButton;
    //订座文字
    IBOutlet UILabel *_bookSeatLabel;
    //开放时间
    IBOutlet UILabel *_openTimeLabel;
    //店铺名称
    IBOutlet UIButton *_storeNameButton;
    //会员级别
    IBOutlet UILabel *_VIPLabel;
    //余额标题
    IBOutlet UILabel *_balanceTitleLabel;
    //余额金额
    IBOutlet UILabel *_balanceMoneyLabel;
    //充值按钮
    IBOutlet UIButton *_rechargeButton;
    //活动背景
    IBOutlet FrameViewWB *_activityBGView;
    //折扣背景
    IBOutlet UIView *_discountBGVIew;
    //优惠背景
    IBOutlet UIView *_couponBGView;
    //打折label
    IBOutlet UILabel *_discountLabel;
    //优惠label
    IBOutlet UILabel *_couponLabel;
    IBOutlet FrameViewWB *_rechargeBGView;
    
    IBOutlet FrameViewWB *_storeInfoBGView;
    StoreModel *_storeModel;
}

//活动与 contentView.frame 变化
- (void)setContentViewFrameWithActivity;

@end

@implementation TakeOrderVC

- (void)dealloc
{
    RELEASE_SAFELY(_payInfoStoreMdoel);
    RELEASE_SAFELY(_storeID);
    RELEASE_SAFELY(_rulesModel);
    RELEASE_SAFELY(_goodsCategoryArray);

    RELEASE_SAFELY(_foodCategoryScrollView);
    RELEASE_SAFELY(_countLabel)
    RELEASE_SAFELY(_confirmButton);
    RELEASE_SAFELY(_footCategorySearchView);
    RELEASE_SAFELY(_footCategoryView);
    RELEASE_SAFELY(_bottomView);
    RELEASE_SAFELY(_activityModel);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_foodCategoryScrollView);
    RELEASE_SAFELY(_countLabel);
    RELEASE_SAFELY(_confirmButton);
    RELEASE_SAFELY(_footCategorySearchView);
    RELEASE_SAFELY(_footCategoryView);
    RELEASE_SAFELY(_bottomView);
    RELEASE_SAFELY(_activityModel);
    
    [super viewDidUnload];
}

-(id)initWithTakeOrderType:(TakeOrderType)type storeModel:(StoreModel *)storeModel
{
    if(self = [super init])
    {
        _takeOrderType = type;
        _storeModel = storeModel;
        _storeID = [_storeModel store_id];
    }
    
    return self;
}

- (id)initWithStoreID:(NSString *)storeID
{
    if (self = [super init]) {
        _storeID = storeID;
        _takeOrderType = TakeOrderDefaultType; //默认点菜
        _takeOrderReqSuc = NO;
        _layerOriginTag1 = kZWLayerTag;
        _layerOriginTag2 = kZWLayerTag;
        _share_user_id = nil;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationBarView setNavigationStyleWithTakeOrderController];;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:kApp_StatusBarStyle];
    [TakeOrderInitRequest cancelUseDefaultSubjectRequest];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadColorConfig];
    [self setNavigationBarTitle:nil];
    [self setLeftNavigationBarButtonStyle:UIButtonStyleBackSecond];
    [self setRightNavigationBarButtonStyle:UIButtonStyleUnCollect];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendRequestOfFavourtStoreRequest) name:kLoginOnceMoreNotification object:nil];

    //初始化 点菜、商家 模块视图
    [self setTakeOrderAndStoreInfoView];
    
    //数据初始化
    _totalDataArray = [[NSMutableArray alloc] init];
    _searchBOOL = NO;
    _takeOrderView.hidden = YES;

    //可点导航栏标题
    if (!_segementView) {
        _segementView = [[SegmentTitleView alloc] initWithTitleArray:@[@"点菜", @"商家"]];
    }
    _segementView.delegate = self;
    _segementView.left = (self.navigationBarView.width-_segementView.width)/2;
    _segementView.bottom = self.navigationBarView.bottom;
    [self.navigationBarView addSubview:_segementView];
    //隐藏商家详情视图
    _storeInfoView.hidden = YES;
    //活动视图
    _activityTipView = [ActivityTipView viewFromXIB];
    _activityTipView.width = _takeOrderView.width;
    _activityTipView.hidden = YES;
    _activityTipView.delegate = self;
    _activityTipView.top = _contentViewTop;
    [_takeOrderScrollView addSubview:_activityTipView];
    
    _countLabel.textAlignment = RTTextAlignmentLeft;
    _ordersMenuView = [OrdersMenuView viewFromXIB];
    _ordersMenuView.actionDelegate =  self;
    _ordersMenuView.height = 0;
    _ordersMenuView.width = self.contentView.width;
    [_takeOrderView addSubview:_ordersMenuView];
    
    _sendType = SendOrder;//默认是送餐
    [self.tableView setHeaderHidden:YES];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //搜索不到菜品提示
    _currentPromptView = [PromptView viewFromXIB];
    [_currentPromptView setPromptText:@"Sorry，没搜到！"];
    [_takeOrderView addSubview:_currentPromptView];
    _currentPromptView.height = _takeOrderView.height;
    _currentPromptView.width = _takeOrderView.width;
    [_takeOrderView bringSubviewToFront:_currentPromptView];
    _currentPromptView.hidden = YES;
    
    [self sendRequestOfGetGoodsWithPayInfo:nil];

    //初始化contentView相对位置数值
    _contentViewTop = 0;
    _contentViewHeight = _takeOrderScrollView.height;
}

//初始化 点菜 商家 模块视图
- (void)setTakeOrderAndStoreInfoView {
    _takeOrderView.top = _takeOrderView.left = 0;
    _storeInfoView.top = 0;
    _storeInfoView.left = _takeOrderScrollView.width;
    _takeOrderView.backgroundColor = UIColorFromRGB_BGColor;
    _storeInfoView.backgroundColor = UIColorFromRGB_BGColor;
    _takeOrderScrollView.delegate = self;
    _takeOrderScrollView.contentSize = CGSizeMake(_takeOrderScrollView.width * 2, _takeOrderScrollView.height);
    _takeOrderScrollView.pagingEnabled = YES;
    _takeOrderScrollView.showsHorizontalScrollIndicator = NO;
    
    _cartView.hidden = YES;
    _cartHaveView.hidden = YES;
    _cartNoneView.hidden = NO;
}

//活动与 contentView.frame 变化
- (void)setContentViewFrameWithActivity
{
    if (_activityTipBOOL) {
        _takeOrderView.top = _contentViewTop+30;
        _takeOrderView.height = _contentViewHeight-30;
    } else {
        _takeOrderView.top = _contentViewTop;
        _takeOrderView.height = _contentViewHeight;
    }
}

- (void)loadColorConfig
{
    _confirmButton.titleLabel.font = FONT_BOTTOM_RIGHT_BUTTON;
    
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setTitleColor:ColorForHexKey(AppColor_OrderBottom_Disabled_Title) forState:UIControlStateDisabled];
    [_confirmButton setBackgroundColor:ColorForHexKey(AppColor_OrderBottom_Disabled)];
    _countLabel.textColor = [UIColor whiteColor];
    _bottomView.backgroundColor = ColorForHexKey(AppColor_OrderBottom_BgColor);
    _cartNoneLabel.textColor = ColorForHexKey(AppColor_OrderBottom_Disabled_Title);
    
#pragma mark - StoreInfoView Setting
    
    _qrCodeLabel.textColor = ColorForHexKey(AppColor_Usable_Coupon_Left_Text);
    _bookSeatLabel.textColor = ColorForHexKey(AppColor_Usable_Coupon_Left_Text);
    [_storeNameButton setTitleColor:ColorForHexKey(AppColor_Brand_Activity_TextColor) forState:UIControlStateNormal];
    _VIPLabel.textColor = ColorForHexKey(AppColor_Brand_Activity_TextColor);
    _balanceTitleLabel.textColor = ColorForHexKey(AppColor_Brand_Activity_TextColor);
    _discountLabel.textColor = ColorForHexKey(AppColor_Brand_Activity_TextColor);
    _couponLabel.textColor = ColorForHexKey(AppColor_Brand_Activity_TextColor);
    _balanceMoneyLabel.textColor = ColorForHexKey(AppColor_Money_Color_Text1);
    [_rechargeButton setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateNormal];
    [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

//调整统计信息label 当用户选中菜品时 计算用户应付金额 和折扣金额
- (void)refreshPayInfoUI
{
    ShoopCartPayInfo *payInfo = [ShoopCartPayInfo shoopCartPayInfoWithGoodsCategoryArray:_goodsCategoryArray];
    _countLabel.text = [NSString stringWithFormat:@"<font size=16 >共￥</font><font size=17>%@</font>",payInfo.payInfoString];
    
    //刷新购物车相关视图
    if (payInfo.product_count) {
        if (payInfo.product_count > 99) {
            _cartNum.width = 14+8;
        }
        [_cartNum setTitle:[NSString stringWithFormat:@"%d",payInfo.product_count] forState:UIControlStateNormal];
        if (_searchBOOL) {
            _cartView.hidden = YES;
            _cartHaveView.hidden = YES;
        } else {
            _cartView.hidden = NO;
            _cartHaveView.hidden = NO;
        }
        _cartNoneView.hidden = YES;
        [_confirmButton setBackgroundColor:ColorForHexKey(AppColor_OrderBottom_Selected)];
    } else {
        _cartView.hidden = YES;
        _cartHaveView.hidden = YES;
        _cartNoneView.hidden = NO;
        _confirmButton.enabled = NO;
        [_confirmButton setBackgroundColor:ColorForHexKey(AppColor_OrderBottom_Disabled)];
        [_confirmButton setTitle:@"选好了" forState:UIControlStateDisabled];
        return;
    }

    [_confirmButton setTitle:@"选好了" forState:UIControlStateNormal];
    _confirmButton.enabled = YES;
}

//显示分类信息
- (void)reloadCategory
{
    _footCategorySearchView.tag    = -1;
    
    float startY = _footCategorySearchView.bottom;
    
    for (int i=0 ; i<_goodsCategoryArray.count; i++)
    {
        GoodsCategoryModel *goodsCategoryModel = _goodsCategoryArray[i];
        
        FoodCategoryView *foodCategoryView = [FoodCategoryView viewFromXIB];
        [foodCategoryView setGoodsCategoryModel:goodsCategoryModel];
        foodCategoryView.tag = i;
        foodCategoryView.categoryNameButton.tag = i;
        foodCategoryView.categoryNameButton.selected =  i==0;
        [foodCategoryView.categoryNameButton addTarget:self action:@selector(didSelectedCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [_foodCategoryScrollView addSubview:foodCategoryView];
        foodCategoryView.top = startY;
        startY += foodCategoryView.height;
    }

    [_foodCategoryScrollView setContentSize:CGSizeMake(0, startY)];
}

//计算当前选中的分类  菜品选中的总数量
- (void)refreshCategoryUI
{
    for (GoodsCategoryModel *categoryModel in _goodsCategoryArray) {
        NSInteger totalCount = 0;
        NSArray *goodsArray =   categoryModel.goods;
        for (GoodsModel *goodsModel in goodsArray) {
            totalCount+= goodsModel.selectedNumber;
        }
        categoryModel.selectedNumber = totalCount;
    }
    NSArray *cagegoryViewArray = [_foodCategoryScrollView subviews];
    for (FoodCategoryView *categoryView in cagegoryViewArray) {
        if (categoryView.tag >= 0) {
             [categoryView refreshUI];
        }
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int pageIndex = scrollView.contentOffset.x / _takeOrderScrollView.width;
    if (pageIndex == 0) {
        [_segementView setSelectSegmentTitleWithIndex:SegmentTitleIndexFirst];
    } else if (pageIndex == 1) {
        [_segementView setSelectSegmentTitleWithIndex:SegmentTitleIndexSecond];
    }
    //点菜请求
    if (pageIndex == 0 && !_takeOrderReqSuc) {
        [self sendRequestOfGetGoodsWithPayInfo:nil];
    }
    //店铺请求
    if (pageIndex == 1 && !_storeInfoReqSuc) {
        [self sendRequestOfStoreDetails];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int pageIndex = scrollView.contentOffset.x / _takeOrderScrollView.width;
    //点菜请求
    if (pageIndex == 0 && !_takeOrderReqSuc) {
        [self sendRequestOfGetGoodsWithPayInfo:nil];
    }
    //店铺请求
    if (pageIndex == 1 && !_storeInfoReqSuc) {
        [self sendRequestOfStoreDetails];
    }
}

#pragma mark -
#pragma mark - SegmentTitleViewDelegate

- (void)segmentTitleViewDidSelectedButtonWithSegmentTitleIndex:(SegmentTitleIndex)segmentTitleIndex {
    int pageIndex;
    if (segmentTitleIndex == SegmentTitleIndexFirst) {
        pageIndex = 0;
    } else if (segmentTitleIndex == SegmentTitleIndexSecond) {
        pageIndex = 1;
    }
    [_takeOrderScrollView setContentOffset:CGPointMake(pageIndex*_takeOrderScrollView.width, 0) animated:YES];
}

#pragma mark -
#pragma mark - ActivityTipViewDelegate

- (void)cancenActivityTipView
{
    _closeActivityFirst = YES;
    _activityTipBOOL = NO;
    [_ordersMenuView hiddenSomeQuestion];
    [self setContentViewFrameWithActivity];
}

- (void)gotoActivityAction
{
    ActivityShowView *activityView = [ActivityShowView viewFromXIB];
    [activityView showWithActivity:_activityModel];
}

#pragma mark -
#pragma mark - OrdersMenuViewDelegate

- (void)orderNumberChanged:(OrderMenuCartCell *)cell
{
    [self refreshCategoryUI];
    [self refreshPayInfoUI];
    [self.tableView reloadData];
}

- (void)orderNumberChangedZero {
    //刷新当前菜品选择
    _goodsCategoryArray = (NSArray *)[ShoopCartPayInfo clearFilterSelectedWithGoodsCategoryArray:_goodsCategoryArray];
    self.dataArray = _goodsCategoryArray;
    [self refreshCategoryUI];
    [self refreshPayInfoUI];
    
    [self showOrHiddenOrderMenuView:nil];
}

- (void)orderNumberChangedOne {
    [self setCartViewHeightFrame];
}

-(void)ordersMenuViewDidDismiss
{
    if (_activityTipBOOL) {
        _topBgView.hidden = YES;
    }
    [self setCartViewFrame];
}

- (void)ordersMenuViewHiddenFinish {
    [_cartView removeFromSuperview];
    [_takeOrderView addSubview:_cartView];
}

#pragma mark -
#pragma mark - 购物车位置设定

- (CGFloat)cartViewBigHeight {
    return (_takeOrderView.height - (kCartViewHighSpace+_bottomView.height+ [_ordersMenuView ordersMenuViewHeight]));
}

- (CGFloat)cartViewSmallHeight {
    return (_takeOrderView.height - kCartViewBottomSpace);
}

- (void)setCartViewFrame {
    [UIView animateWithDuration:0.3 animations:^{
        _cartView.top = [self cartViewSmallHeight];
    } completion:^(BOOL finished) {
    }];
    _countLabel.left = kCartViewNormalLeftSpace;
}

- (void)setCartViewHeightFrame {
    [self.contentView addSubview:_cartView];
    [UIView animateWithDuration:0.3 animations:^{
        _cartView.top = [self cartViewBigHeight];
    } completion:^(BOOL finished) {
    }];
    [_takeOrderView addSubview:_cartView];
    _countLabel.left = kCartViewHeightLeftSpace;
}

- (IBAction)cartViewShowOrdersMenuAction:(id)sender {
    [self showOrHiddenOrderMenuView:nil];
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDelegate
/////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_searchBOOL) {
        return 1;
    }
    return _goodsCategoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_searchBOOL) {
        return self.dataArray.count;
    }
    GoodsCategoryModel *goodsCategoryModel = (GoodsCategoryModel *)_goodsCategoryArray[section];
    return goodsCategoryModel.goods.count;
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [PickFoodCell class];
}

- (void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    PickFoodCell *foodCell = (PickFoodCell *)cell;
    foodCell.delegate = self;
    foodCell.cellSection = indexPath.section >= 1 ? indexPath.section : 0;

    NSInteger _totalRow = 0;
    for (int k = 0; k < indexPath.section; k ++) {
        GoodsCategoryModel *goodsCategoryModel = (GoodsCategoryModel *)_goodsCategoryArray[k];
         _totalRow += goodsCategoryModel.goods.count;
    }
    if (indexPath.section == 0) {
        foodCell.cellRow = indexPath.row;
    } else {
        foodCell.cellRow = indexPath.row + _totalRow;
    }
    
    if (_searchBOOL) {
        GoodsModel *goodsModel = (GoodsModel *)self.dataArray[indexPath.row];
        [foodCell setCellData:goodsModel withShow:NO];
        [foodCell hiddenSeparatorLine:NO];
        [foodCell showSeparatorLineLeftZero:YES];
        if (indexPath.row%2) {
            foodCell.contentView.backgroundColor = ColorForHexKey(AppColor_Order_Take_CellBg);
        } else {
            foodCell.contentView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        GoodsCategoryModel *goodsCategoryModel = (GoodsCategoryModel *)_goodsCategoryArray[indexPath.section];
        GoodsModel *goodsModel = (GoodsModel *)goodsCategoryModel.goods[indexPath.row];
        [foodCell setCellData:goodsModel withShow:YES];
        if (goodsCategoryModel.goods.count-1 == indexPath.row) {
            [foodCell hiddenSeparatorLine:YES];
        } else {
            [foodCell hiddenSeparatorLine:NO];
            [foodCell showSeparatorLineLeftZero:NO];
        }
        foodCell.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 77;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_searchBOOL) {
        return 0;
    }
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TakeOrderSectionView *takeOrderSectionView =  [TakeOrderSectionView viewFromXIB];
    GoodsCategoryModel *goodsCategoryModel = (GoodsCategoryModel *)_goodsCategoryArray[section];
    [takeOrderSectionView setGoodsCategroyTitle:goodsCategoryModel.cate_name];
    
    return takeOrderSectionView;
}

//开始拖拽动作
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing];
    _categoryClicked = NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_categoryClicked) {
        return;
    }

    if (tableView.contentOffset.y < 120) {
        [self setSelectedButtonWithIndex:0];
        [self setGategoryScrollViewShowIndex:0];
        return;
    }
    if (tableView.contentOffset.y > (tableView.contentSize.height-tableView.height) && tableView.contentOffset.y < (tableView.contentSize.height-tableView.height)+120) {
        [self setSelectedButtonWithIndex:_goodsCategoryArray.count-1];
        [self setGategoryScrollViewShowIndex:_goodsCategoryArray.count-1];
        return;
    }
    
    NSInteger selectedIndex = indexPath.section;
    [self setSelectedButtonWithIndex:selectedIndex];
    [self setGategoryScrollViewShowIndex:selectedIndex];
}

- (void)setSelectedButtonWithIndex:(NSInteger)index
{
    NSArray *categoryViewArray = _foodCategoryScrollView.subviews;
    for (FoodCategoryView *eachCategroyView in categoryViewArray)
    {
        if (eachCategroyView.tag >= 0) {
            eachCategroyView.categoryNameButton.selected = (eachCategroyView.tag == index) ? YES : NO;
        }
    }
}

//设置分类菜单的显示
- (void)setGategoryScrollViewShowIndex:(NSInteger)index
{
    FoodCategoryView *categoryView = [FoodCategoryView viewFromXIB];
    NSInteger countCategory =  _foodCategoryScrollView.height/categoryView.height;
    
    if (index <= countCategory-1) {
        [_foodCategoryScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    else if (index > countCategory-1 && index < _goodsCategoryArray.count-countCategory) {
        [_foodCategoryScrollView setContentOffset:CGPointMake(0, categoryView.height*index-((countCategory/2)*categoryView.height)) animated:NO];
    } else {
        [_foodCategoryScrollView setContentOffset:CGPointMake(0, _foodCategoryScrollView.contentSize.height-categoryView.height*(countCategory+1)) animated:NO];
    }
}

#pragma mark - PickFoodCellDeleagte

- (void)pickFoodCellAscending:(PickFoodCell *)cell//添加了一个菜
{
    [self refreshCategoryUI];
    [self refreshPayInfoUI];
}

- (void)pickFoodCellDecreasing:(PickFoodCell *)cell//减少了一个菜
{
    [self refreshCategoryUI];
    [self refreshPayInfoUI];
}

- (void)pickFoodCellOrigin:(PickFoodCell *)cell {
    [self refreshCategoryUI];
    [self refreshPayInfoUI];
}

- (void)pickFoodCellBuyCarWithView:(UIView *)view {

    if (_searchBOOL) return;
    
    CGPoint point0 = view.center;
    CGPoint point1 = CGPointMake(35, self.view.height-kCartViewBottomSpace);

    //该部分动画 以self.view为参考系进行
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_cart_red"]];
    imageView.frame = CGRectMake(0, 0, 20, 20);
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.hidden = YES;
    imageView.center = point0;
    ZWCALayer *layer = [[ZWCALayer alloc] init];
    layer.layerTag = _layerOriginTag1;
    _layerOriginTag1 ++;
    layer.contents = imageView.layer.contents;
    layer.frame = imageView.frame;
    layer.opacity = 1;
    [self.view.layer addSublayer:layer];
    
    //动画 终点 都以self.view为参考系
    CGPoint endpoint = [self.view convertPoint:point1 toView:self.view];
    //动画 起点
    CGPoint startPoint = [self.view convertPoint:point0 fromView:self.tableView];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    //贝塞尔曲线中间点
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endpoint.x;
    float ey = endpoint.y;
    float x = sx+(ex-sx)/3;
    float y = sy+(ey-sy)*0.5-300;
    CGPoint centerPoint = CGPointMake(x,y);
    [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = path.CGPath;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 0.6;
    animation.delegate = self;
    animation.autoreverses =  NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:@"buy"];
}

- (void)move:(ZWCALayer *)layer{
    [layer removeFromSuperlayer];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSArray *layerArray = [NSArray arrayWithArray:self.view.layer.sublayers];
    for (CALayer *layer in layerArray) {
        if ([layer isKindOfClass:[ZWCALayer class]]) {
            ZWCALayer *currentLayer = (ZWCALayer *)layer;
            if (currentLayer.layerTag == _layerOriginTag2) {
                [layer removeFromSuperlayer];
            }
        }
    }
    _layerOriginTag2 ++;
    [_cartView.layer addAnimation:[self scaleAnimationStart] forKey:nil];
}

#pragma mark -
#pragma mark - Animation

- (CAKeyframeAnimation*)scaleAnimationStart {
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    
    scaleAnimation.duration = 0.5;
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    scaleAnimation.values = values;
    
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}

#pragma mark -
#pragma mark - TakeOrderConfirmDelegate

- (void)showTakeOrderSelectedListWithPayInfo:(ShoopCartPayInfo *)payInfo {

    //强制展开点菜列表
    if (_closeActivityFirst) {
        _ordersMenuView.height = 0;
        _closeActivityFirst = NO;
    }
    if (_ordersMenuView.height == 0 && payInfo.productArray.count)
    {
        NSMutableArray *selectedArray = [ShoopCartPayInfo filterSelectedWithGoodsCategoryArray:_goodsCategoryArray];
        [_ordersMenuView showWithHeight:_takeOrderView.height - _bottomView.height goodsArray:selectedArray];
        if (_activityTipBOOL) {
            if (!_topBgView) {
                _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _takeOrderView.width, kActiviytTipHeight)];
            }
            _topBgView.hidden = NO;
            _topBgView.backgroundColor = [UIColor blackColor];
            _topBgView.alpha = 0.4;
            [_takeOrderScrollView addSubview:_topBgView];
        }
        
        [self setCartViewHeightFrame];
    }
    if (payInfo && !payInfo.isHaveLogin) {
        [self sendRequestOfGetGoodsWithPayInfo:payInfo];
        return ;
    }
    //刷新当前菜品选择
    self.dataArray = _goodsCategoryArray;
    [self refreshCategoryUI];
    [self refreshPayInfoUI];
}

- (void)refreshTakeOrderGoodsWithPayInfo:(ShoopCartPayInfo *)payInfo {
    
}

#pragma mark -
#pragma mark - ViewActions

- (IBAction)showOrHiddenOrderMenuView:(id)sender
{
    if (_closeActivityFirst) {
        _ordersMenuView.height = 0;
        _closeActivityFirst = NO;
    }
    if (_ordersMenuView.height == 0) {
        NSMutableArray *selectedArray = [ShoopCartPayInfo filterSelectedWithGoodsCategoryArray:_goodsCategoryArray];
        if (!selectedArray.count) {
            return;
        }
        [_ordersMenuView showWithHeight:_takeOrderView.height - _bottomView.height goodsArray:selectedArray];
        if (_activityTipBOOL) {
            if (!_topBgView) {
                _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _takeOrderView.width, kActiviytTipHeight)];
            }
            _topBgView.hidden = NO;
            _topBgView.backgroundColor = [UIColor blackColor];
            _topBgView.alpha = 0.4;
            [_takeOrderScrollView addSubview:_topBgView];
        }
        [self setCartViewHeightFrame];
    } else {
        if (_activityTipBOOL) {
            _topBgView.hidden = YES;
        }
        [_ordersMenuView hidden];
        [self setCartViewFrame];
    }
}

- (void)didSelectedCategoryAction:(UIButton  *) categroyNameButton
{
    NSArray *categoryViewArray = _foodCategoryScrollView.subviews;
    for (FoodCategoryView *eachCategroyView in categoryViewArray)
    {
        if (eachCategroyView.tag >= 0) {
            eachCategroyView.categoryNameButton.selected = (eachCategroyView.categoryNameButton == categroyNameButton);
        }
    }
    [self hidePromptView];
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:categroyNameButton.tag];
    [self.tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    _categoryClicked = YES;
    
}

#pragma mark -
#pragma mark - 提交订单 “选好了”

- (IBAction)sumbitOrderAction:(id)sender {
    if (_goodsCategoryArray.count == 0) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"还没选菜呢"];
        return;
    }
    
    ShoopCartPayInfo *payInfo =[ShoopCartPayInfo shoopCartPayInfoWithGoodsCategoryArray:_goodsCategoryArray];
    payInfo.takeOrderType = _takeOrderType;
    payInfo.storeModel    = _payInfoStoreMdoel;
    if ([AccountHelper isLogin]) {
        payInfo.isHaveLogin = YES;
    } else {
        payInfo.isHaveLogin = NO;
    }
    TakeOrderConfirmVC *submitOrderVC = [[TakeOrderConfirmVC alloc] initWithShoopCartPayInfo:payInfo];
    submitOrderVC.delegate = self;
    
    if ([AccountHelper isLogin]) {
        [self pushViewController:submitOrderVC];
    } else {
        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType) {
            [self pushViewController:submitOrderVC];
        }];
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma mark -
#pragma mark - NavigationBarButtonAction

-(void)actionClickNavigationBarRightButton
{
    if ([AccountHelper isLogin]) {
        [self sendRequestOfFavourtStoreRequest];
    }else{
        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType) {
            if (_segementView.segmentTitleIndex == SegmentTitleIndexFirst){
                ShoopCartPayInfo *payInfo =[ShoopCartPayInfo shoopCartPayInfoWithGoodsCategoryArray:_goodsCategoryArray];
                [self sendRequestOfGetGoodsWithPayInfo:payInfo];
            }else if (_segementView.segmentTitleIndex == SegmentTitleIndexSecond){
                [self sendRequestOfStoreDetails];
            }
        }];
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

-(void)actionClickNavigationBarLeftButton
{
    [self endEditing];
    ShoopCartPayInfo *payInfo = [ShoopCartPayInfo shoopCartPayInfoWithGoodsCategoryArray:_goodsCategoryArray];
    if (payInfo.productArray.count > 0) {
        [[MessageAlertView viewFromXIB] showAlertViewInView:self.view msg:@"您是否要放弃这次点菜操作？" onCanleBlock:nil onConfirmBlock:^{
             [TakeOrderInitRequest cancelUseDefaultSubjectRequest];
            [self navigationPopBack];
         }];
        return ;
    }
    [TakeOrderInitRequest cancelUseDefaultSubjectRequest];
    [self navigationPopBack];
}

- (void)navigationPopBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SearchAction

- (IBAction)searchAction:(id)sender
{
    _searchViewOrder = [SearchViewOrder viewFromXIB];
    _searchViewOrder.top = 0;
    _searchViewOrder.delegate = self;
    [_searchViewOrder showInView:_takeOrderScrollView];
    
    //拿到数据
    [_totalDataArray removeAllObjects];
    for (int i = 0; i < _goodsCategoryArray.count; i ++) {
        GoodsCategoryModel *categoryModel = (GoodsCategoryModel *)_goodsCategoryArray[i];
        NSArray *array = [NSArray arrayWithArray:categoryModel.goods];
        for (int j = 0; j < array.count; j ++) {
            GoodsModel *model = (GoodsModel *)array[j];
            [_totalDataArray addObject:model];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self setContentViewFrameWithActivity];
}

#pragma mark - SearchViewOrderDelegate

- (void)finishButtonClicked
{
    //
    _foodCategoryScrollView.hidden = NO;
    //
    _footCategorySearchView.width = kOrderCategoryWidth;
    _footCategoryView.left = _footCategorySearchView.width;
    _footCategoryView.width = _takeOrderView.width - _footCategorySearchView.width;
    //
    _footCategoryView.top = 0;
    _footCategoryView.height = _takeOrderView.height - _bottomView.height;
    //
    _bottomView.hidden = NO;
    
    //
    _currentPromptView.hidden = YES;
    _searchBOOL = NO;
    [self.tableView reloadData];
    
//    [self setContentViewFrameWithActivity];
    NSMutableArray *selectedArray = [ShoopCartPayInfo filterSelectedWithGoodsCategoryArray:_goodsCategoryArray];
    if (selectedArray.count) {
        _cartView.hidden = NO;
        _cartHaveView.hidden = NO;
    } else {
        _cartView.hidden = YES;
        _cartHaveView.hidden = YES;
    }
}

- (void)textFieldChangedWithText:(NSString *)text
{
    if (text.length) {
        CGFloat tipHeight = 0;
        if (_activityTipBOOL) {
            tipHeight = kActiviytTipHeight;
        }
        //
        _foodCategoryScrollView.hidden = YES;
        //
        _footCategoryView.left = 0;
        _footCategoryView.width = _takeOrderView.width;
        //
        _footCategoryView.top = _searchViewOrder.height-tipHeight;
        _footCategoryView.height = _takeOrderView.height - _searchViewOrder.height+tipHeight;
        //
        _bottomView.hidden = YES;
        
        //检索结果
        [self searchTextChangedResult:text];
        
    } else {
        //
        _foodCategoryScrollView.hidden = NO;
        //
        _footCategorySearchView.width = kOrderCategoryWidth;
        _footCategoryView.left = _footCategorySearchView.width;
        _footCategoryView.width = _takeOrderView.width - _footCategorySearchView.width;
        //
        _footCategoryView.top = 0;
        _footCategoryView.height = _takeOrderView.height - _bottomView.height;
        //
        _bottomView.hidden = NO;
        
        //
        _currentPromptView.hidden = YES;
        _searchBOOL = NO;
        [self.tableView reloadData];
        
    }
    
//    [self setContentViewFrameWithActivity];
}

//检索事件
- (void)searchTextChangedResult:(NSString *)text
{
    NSMutableArray *resultArray = [NSMutableArray array];

    for (int i = 0; i < _totalDataArray.count; i++) {
        GoodsModel *model = (GoodsModel *)_totalDataArray[i];
        NSRange range    = [model.goods_name rangeOfString:text];//查找子串，找不到返回NSNotFound 找到返回location和length
        NSRange rangePY  = [model.goods_py rangeOfString:[text uppercaseString]];
        NSRange rangeSZM = [model.goods_szm rangeOfString:[text uppercaseString]];
        
        if ((range.location != NSNotFound) || (rangePY.location != NSNotFound) || (rangeSZM.location != NSNotFound)) {
            [resultArray addObject:model];
        }
    }
    
    if (resultArray.count) {
        _searchBOOL = YES;
        [self setDataArray:resultArray];
        [self.tableView reloadData];
        _currentPromptView.hidden = YES;
        _cartView.hidden = YES;
        _cartHaveView.hidden = YES;
    } else {

        //隐藏搜索透明背景
        [_searchViewOrder searchBGViewHidden];
        _currentPromptView.hidden = NO;
        _cartView.hidden = NO;
        _cartHaveView.hidden = NO;
    }
}

#pragma mark - 
#pragma mark - Requests

//菜单初始化接口
- (void)sendRequestOfGetGoodsWithPayInfo:(ShoopCartPayInfo *)payInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    if (payInfo && !payInfo.isHaveLogin) {
        [params setObject:payInfo.goodsJSONString forKey:@"goods"];
    }
    [params setObject:_storeID forKey:@"store_id"];
    [params setObject:[NSString stringWithFormat:@"%d",_takeOrderType] forKey:@"order_type"];
    
    [TakeOrderInitRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
    {
        if(request.isSuccess) {
            _takeOrderReqSuc = YES;
            
            //是否收藏
            _isFavourite = [(NSDictionary *)request.resultDic[@"data"] stringForKey:@"is_favourt"];
            [self setRightNavigationBarButtonStyleWithIsFavourite:_isFavourite];
            
            //店铺信息
            if (!_payInfoStoreMdoel) {
                _payInfoStoreMdoel = [[StoreModel alloc] init];
            }
             _payInfoStoreMdoel = (StoreModel *)[StoreModel reflectObjectsWithJsonObject:request.resultDic[@"data"]];

            //是否有活动
            _activityModel = (ActivityModel *)[ActivityModel reflectObjectsWithJsonObject:request.resultDic[@"data"]];
            if (_activityModel.activity_id.intValue && _activityTipView.hidden) {
                _activityTipView.hidden = NO;
                _activityTipView.activityTitleLabel.text = _activityModel.activity_title;
                _activityTipBOOL = YES;
                [self setContentViewFrameWithActivity]; 
            }
            
            //菜品
            RELEASE_SAFELY(_goodsCategoryArray);
            _goodsCategoryArray = [ShoopCartPayInfo filterGoodsCategoryArray:[NSArray arrayWithArray:request.resultDic[KRequestResultDataKey]]];
            
            if (_goodsCategoryArray.count) {
                //默认选中的类（首类）
                _selectedGoodsCategoryModel = _goodsCategoryArray[0];
                [self setDataArray:_selectedGoodsCategoryModel.goods];
                [self reloadCategory];
                
                if (payInfo && !payInfo.isHaveLogin) {
                    [_ordersMenuView refreshOrderMenuDishes:(NSArray *)[ShoopCartPayInfo filterSelectedArrayFromGoodsCategoryArray2:_goodsCategoryArray]];
                    [self.tableView reloadData];
                }
                [self refreshCategoryUI];
                [self refreshPayInfoUI];
                _takeOrderView.hidden = NO;
                [self hidePromptView];
            }
        } else {
            _takeOrderReqSuc = NO;
            if (request.isNoLogin) {
                return ;
            }
            if (request.resultDic) {
                [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
            } else {
                [BDKNotifyHUD showCryingHUDInView:self.view text:@"服务器加载失败"];
            }
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        _takeOrderReqSuc = NO;
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
    }];
}

//提交菜单接口


#pragma mark - /////////////////////////////////////////////////////////////
#pragma mark - StoreInfoView Setting

//二维码点击
- (IBAction)qrCodeButtonAction:(id)sender {
    QPCodeVC *qpCodeVC = [[QPCodeVC alloc]initWithStoreID:_storeModel.store_id withStoreName:_storeModel.store_name];
    [self.navigationController pushViewController:qpCodeVC animated:YES];
}
//订座点击
- (IBAction)bookSeatAction:(id)sender {
    OrderSeatVC *orderSeatVC = [[OrderSeatVC alloc] initWithStoreIdOfOrderSeat:_storeModel.store_id];
    if ([AccountHelper isLogin]) {
        [self pushViewController:orderSeatVC];
    } else {
        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType) {
            [self pushViewController:orderSeatVC];
        }];
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
//店名点击事件
- (IBAction)brandNameAction:(id)sender {
    StoreBMapVC *bMapVC = [[StoreBMapVC alloc]initWithStoreModel:_storeModel];
    [self.navigationController pushViewController:bMapVC animated:YES];
}
//店铺电话点击事件
- (IBAction)brandPhoneClickAction:(id)sender {
    NSArray *mobileArray = [PhoneNumberHelper parseText:_storeModel.phone];
    if (mobileArray && mobileArray.count) {
        CallPhoneView *callView = [CallPhoneView viewFromXIB];
        [callView showInView:self.view phoneNumArray:mobileArray];
    }
}
//充值点击
- (IBAction)rechargeButtonAction:(id)sender {
    RechargeVC *rechargeVC = [[RechargeVC alloc]initWithBrandID:_storeModel.brand_id withStoreID:_storeModel.store_id];
    if ([AccountHelper isLogin]) {
        [self pushViewController:rechargeVC];
    } else {
        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType) {
            [self pushViewController:rechargeVC];
        }];
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//刷新店铺UI

-(void)refreshStoreInfoUI
{
    if (![NSString isBlankString:_storeModel.image_big]) {
        [_storeHeadImageView setImageWithUrlString:[NSString stringWithFormat:@"%@",_storeModel.image_big] placeholderImage:KMiddPlaceHolderImage];
    }
    _openTimeLabel.text = _storeModel.open_time;
    [_storeNameButton setTitle:_storeModel.address forState:UIControlStateNormal];
    if ([NSString isBlankString:_storeModel.user_level_name]) {
        _VIPLabel.text = @"普通会员";
    }else{
        _VIPLabel.text = _storeModel.user_level_name;
    }
    if (![NSString isBlankString:_storeModel.user_money]) {
        _balanceMoneyLabel.text = [NSString stringWithFormat:@"￥%@",_storeModel.user_money];
    }else{
        _balanceMoneyLabel.text = @"￥0.00";
    }
    
    if ([AccountHelper isLogin]) {
        _rechargeBGView.hidden = NO;
        _activityBGView.top = _rechargeBGView.bottom +10;
    }else{
        _rechargeBGView.hidden = YES;
        _activityBGView.top = _storeInfoBGView.bottom +10;
    }

    if ([NSString isBlankString:_storeModel.discount_id] && [NSString isBlankString:_storeModel.sales_id]) {
        _activityBGView.hidden = YES;
    }else if(![NSString isBlankString:_storeModel.discount_id] && [NSString isBlankString:_storeModel.sales_id]){
        _activityBGView.hidden = NO;
        _discountBGVIew.hidden = NO;
        _couponBGView.hidden = YES;
        _discountLabel.text = _storeModel.discount_title;
        if (_storeInfoBGView.hidden == YES) {
            _activityBGView.top = _storeInfoBGView.bottom +10;
        }else{
            _activityBGView.top = _rechargeBGView.bottom +10;
        }
        _activityBGView.height = _discountBGVIew.height;
    }else if ([NSString isBlankString:_storeModel.discount_id] && ![NSString isBlankString:_storeModel.sales_id]){
        _activityBGView.hidden = NO;
        _discountBGVIew.hidden = YES;
        _couponBGView.hidden = NO;
        _couponLabel.text = _storeModel.sales_title;
        if (_storeInfoBGView.hidden == YES) {
            _activityBGView.top = _storeInfoBGView.bottom +10;
        }else{
            _activityBGView.top = _rechargeBGView.bottom +10;
        }
        _couponBGView.top = _activityBGView.top;
        _activityBGView.height = _discountBGVIew.height;
    }else{
        _activityBGView.hidden = NO;
        _discountBGVIew.hidden = NO;
        _couponBGView.hidden = NO;
        _discountLabel.text = _storeModel.discount_title;
        _couponLabel.text = _storeModel.sales_title;
    }
}

/**
 获取店铺详情信息
 **/
-(void) sendRequestOfStoreDetails
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [params setObject:_storeID forKey:@"store_id"];
    [StoreDetailsRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             _storeInfoReqSuc = YES;
             //是否收藏
             _isFavourite = [(NSDictionary *)request.resultDic[@"data"] stringForKey:@"is_favourt"];
             _storeInfoView.hidden = NO;
             [self hidePromptView];
             _storeModel = request.resultDic[KRequestResultDataKey];
             [self refreshStoreInfoUI];
         }else
         {
             _storeInfoReqSuc = NO;
             if (request.resultDic)
             {
                 [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
             }else {
                 [BDKNotifyHUD showCryingHUDInView:self.view text:@"服务器加载失败"];
             }
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request) {
         _storeInfoReqSuc = NO;
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
     }];
}

//收藏接口

-(void)sendRequestOfFavourtStoreRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    if (![NSString isBlankString:_share_user_id]) {
        [params setObject:_share_user_id forKey:@"share_user_id"];
    }else{
        [params setObject:@"0" forKey:@"share_user_id"];
    }
    if (_isFavourite.intValue) {
        [params setObject:@"2" forKey:@"method"];
    }else{
        [params setObject:@"1" forKey:@"method"];
    }
    [params setObject:_storeID forKey:@"store_id"];
    [FavourtStoreRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             if (_isFavourite.intValue) {
                 [HDCNotifyHUD showHDCHUDInView:self.view image:[UIImage imageNamed:@"order_collection_bigwrite"] text:request.resultDic[@"msg"]];
                 _isFavourite = @"0";
                 [self setRightNavigationBarButtonStyleWithIsFavourite:_isFavourite];
             }else{
                 [HDCNotifyHUD showHDCHUDInView:self.view image:[UIImage imageNamed:@"order_collection_bigwfen"] text:request.resultDic[@"msg"]];
                 _isFavourite = @"1";
                 [self setRightNavigationBarButtonStyleWithIsFavourite:_isFavourite];
             }
         }else
         {
             if (request.resultDic)
             {
                 [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
             }else {
                 [BDKNotifyHUD showCryingHUDInView:self.view text:@"服务器加载失败"];
             }
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request) {
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
     }];
}

- (void)setRightNavigationBarButtonStyleWithIsFavourite:(NSString*)isFavourite
{
    if (isFavourite.intValue) {
        [self setRightNavigationBarButtonStyle:UIButtonStyleCollected];
    }else{
        [self setRightNavigationBarButtonStyle:UIButtonStyleUnCollect];
    }
}
@end
