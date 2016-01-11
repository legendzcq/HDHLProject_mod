//
//  GroupBuyOrderDetailsVC.m
//  Carte
//
//  Created by zln on 14/12/25.
//
//

#import "GroupBuyDetailsVC.h"
#import "StrikethroughLabel.h"
#import "PayModeView.h"
#import "GrouponOrderModel.h"
#import "GrouponDetailsRequest.h"
#import "CouponCodeView.h"
#import "CancelOrderRequest.h"
#import "OtherStoreInfoVC.h"
#import "GroupBuyDetailsVC.h"
#import "CommonHelper.h"
#import "BMKLocationManager.h"
#import "FrameViewWB.h"
#import "LoginVC.h"
#import "GroupBuyPayVC.h"
#import "ShareView.h"
#import "FrameLineView.h"
#import "BMKLocationManager.h"

@interface GroupBuyDetailsVC ()<ExpandFrameViewDeleagte,UIScrollViewDelegate,UIActionSheetDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    
    IBOutlet ExpandFrameView *_layOutFrameView;
    
    //滑动试图
    IBOutlet UIScrollView *_scrollView;
    //头部显示立即抢购

    IBOutlet UIView *_topMustBuyFrameView;
    
    IBOutlet UIButton *_topMustBuyButton;
    
    //价钱显示
    IBOutlet FrameView *_priceShowFrameView;
    //现价显示
    IBOutlet UILabel *_nowPriceLabel;
    
    IBOutlet UILabel *_nowPriceLabel2;
    
    //市场价显示
    IBOutlet StrikethroughLabel *_agoPriceLabel;
    
    IBOutlet StrikethroughLabel *_agoPriceLabel2;
    
    //图片展示
    IBOutlet ExpandFrameView *_imageFrameView;
    
    IBOutlet UIButton *_MustBuyButton;
    
    //图片展示
    
    IBOutlet WebImageView *_grouponImageView;

    //店铺信息显示
    IBOutlet FrameView *_storeInfoShowFrameView;
    //商家名称
    IBOutlet UILabel *_storeNameLabel;
    
    //已经销售的团购
    IBOutlet UILabel *_yiShouLabel;
    
   //剩余时间
    IBOutlet UILabel *_shengYuTimeLabel;
    
    //显示更多商家信息
    IBOutlet ExpandFrameView *_moreStoreFrameView;
    //更多商家表头信息
    IBOutlet UIView *_moreStoreTitleView;
    
    //商家信息
    IBOutlet UIView *_storeInfoView;
    
    //更多分点里面的商家详情
    
    IBOutlet UILabel *_shiYongFanWeiLabel;
    
    IBOutlet UILabel *_moreStoreNameLabel;
    
    
    IBOutlet UILabel *_moreStoreAddressLabel;
    
    
    IBOutlet UIView *_moreStoreListView;
    
    
    IBOutlet ExpandFrameView *_grouponDetailFrameView;
    //团购详情
    IBOutlet UIWebView *_grouponDetailsWebView;
    IBOutlet FrameViewWB *_groupFeameView;
    
    IBOutlet ExpandFrameView *_howBuyFrameView;
    
    IBOutlet FrameViewWB *_howFrameView;
    //购买须知
    IBOutlet UIWebView *_howBuyWebView;
    
    
    //团购订单详情
    GrouponModel       *_grouponModel;
//    NSString                *_orderID;
    StoreModel                  *_storeModel;//商家信息

    CLLocation              *_userLocation;//定位到的用户位置

    
}

@end

@implementation GroupBuyDetailsVC

- (void)dealloc {
    
    RELEASE_SAFELY(_grouponModel);
    RELEASE_SAFELY(_storeModel);
    RELEASE_SAFELY(_userLocation);

  
    RELEASE_SAFELY(_grouponImageView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_grouponDetailsWebView);
    RELEASE_SAFELY(_moreStoreListView);
    RELEASE_SAFELY(_moreStoreAddressLabel);
    RELEASE_SAFELY(_moreStoreNameLabel);
    RELEASE_SAFELY(_storeInfoView);
    RELEASE_SAFELY(_moreStoreTitleView);
    RELEASE_SAFELY(_moreStoreFrameView);
    RELEASE_SAFELY(_shengYuTimeLabel);
    RELEASE_SAFELY(_yiShouLabel);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_storeInfoShowFrameView);
    RELEASE_SAFELY(_agoPriceLabel);
    RELEASE_SAFELY(_nowPriceLabel);
    RELEASE_SAFELY(_priceShowFrameView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_imageFrameView);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_grouponDetailFrameView);
    RELEASE_SAFELY(_howBuyFrameView);
    RELEASE_SAFELY(_shiYongFanWeiLabel);
    RELEASE_SAFELY(_nowPriceLabel2);
    RELEASE_SAFELY(_agoPriceLabel2);
    RELEASE_SAFELY(_topMustBuyFrameView);
    RELEASE_SAFELY(_topMustBuyButton);
    RELEASE_SAFELY(_MustBuyButton);

}


- (void)viewDidUnload {
    
    RELEASE_SAFELY(_grouponImageView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_grouponDetailsWebView);
    RELEASE_SAFELY(_moreStoreListView);
    RELEASE_SAFELY(_moreStoreAddressLabel);
    RELEASE_SAFELY(_moreStoreNameLabel);
    RELEASE_SAFELY(_storeInfoView);
    RELEASE_SAFELY(_moreStoreTitleView);
    RELEASE_SAFELY(_moreStoreFrameView);
    RELEASE_SAFELY(_shengYuTimeLabel);
    RELEASE_SAFELY(_yiShouLabel);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_storeInfoShowFrameView);
    RELEASE_SAFELY(_agoPriceLabel);
    RELEASE_SAFELY(_nowPriceLabel);
    RELEASE_SAFELY(_priceShowFrameView);
    RELEASE_SAFELY(_howBuyWebView);
    RELEASE_SAFELY(_imageFrameView);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_grouponDetailFrameView);
    RELEASE_SAFELY(_howBuyFrameView);
    RELEASE_SAFELY(_shiYongFanWeiLabel);
    RELEASE_SAFELY(_nowPriceLabel2);
    RELEASE_SAFELY(_agoPriceLabel2);
    RELEASE_SAFELY(_topMustBuyFrameView);
    RELEASE_SAFELY(_topMustBuyButton);
    RELEASE_SAFELY(_MustBuyButton);
    
   
    _layOutFrameView = nil;
    _groupFeameView = nil;
    _howFrameView = nil;
    [super viewDidUnload];
}


-(id)initWithGrouponID:(NSString *)grouponID
{
    if (self = [super init])
    {
        _grouponModel = [[GrouponModel alloc] init];
        _grouponModel.groupon_id = grouponID;
    }
    
    return self;
}


-(void)configViewController
{
    [super configViewController];
    _topMustBuyFrameView.hidden = YES;

    [self loadColorConfig];
    _scrollView.delegate = self;
    self.navigationBarView.rightBarButton.hidden = NO;
    [self setRightNavigationBarButtonStyle:UIButtonStyleShare];
    [self setNavigationBarTitle:@"团购详情"];
    [_scrollView setContentSize:CGSizeMake(0, 500)];
    
    self.contentView.hidden = YES;
    [self refreshUI];
    [self sendReqeustOfGrouponDetails];
}

- (void)loadColorConfig
{
    [_topMustBuyButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
    [_MustBuyButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
    _yiShouLabel.textColor = ColorForHexKey(AppColor_Prompt_Text1);
    _shengYuTimeLabel.textColor = ColorForHexKey(AppColor_Prompt_Text1);
    _nowPriceLabel.textColor = ColorForHexKey(AppColor_Amount1);
    _nowPriceLabel2.textColor = ColorForHexKey(AppColor_Amount1);
    _agoPriceLabel.textColor = ColorForHexKey(AppColor_Original_Price1);
    _agoPriceLabel2.textColor = ColorForHexKey(AppColor_Original_Price1);
    _storeNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
    _moreStoreNameLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
    _moreStoreAddressLabel.textColor = ColorForHexKey(AppColor_Content_Text1);
}
-(void)actionClickNavigationBarRightButton
{
    ShareView *shareView = [ShareView viewFromXIB];
    [shareView showInView:self.view currentContainer:self shareContent:_grouponModel.share_content title:@"分享到"];
}
#pragma mark============更新数据========
- (void)refreshUI
{
    
    _layOutFrameView.layoutDelegate = self;
    if (!_grouponModel) {
        return;
    }
    
    //加载团购图片
    [_grouponImageView setImageWithUrlString:_grouponModel.image_big placeholderImage:KBigPlaceHodlerImage];
    
    //价格显示 暂无数据 假数据显示

    if ((int)_grouponModel.shop_price.floatValue == _grouponModel.shop_price.floatValue)
    {
        
        _nowPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",_grouponModel.shop_price.floatValue];
        _nowPriceLabel2.text = [NSString stringWithFormat:@"￥%.0f",_grouponModel.shop_price.floatValue];

        
    }else
    {
        _nowPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.shop_price.floatValue];
        _nowPriceLabel2.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.shop_price.floatValue];

    }
    
    if ((int)_grouponModel.shop_price.floatValue == _grouponModel.shop_price.floatValue)
    {
        _agoPriceLabel.text = [NSString stringWithFormat:@"￥%.0f",_grouponModel.market_price.floatValue];
        _agoPriceLabel2.text = [NSString stringWithFormat:@"￥%.0f",_grouponModel.market_price.floatValue];

        
    }else
    {
        _agoPriceLabel.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.market_price.floatValue];
        _agoPriceLabel2.text = [NSString stringWithFormat:@"￥%.2f",_grouponModel.market_price.floatValue];
    }
    
    float width = [_nowPriceLabel.text widthWithFont:_nowPriceLabel.font boundingRectWithSize:CGSizeMake(100, _nowPriceLabel.height)];
    _nowPriceLabel.width = width;
    _agoPriceLabel.left = _nowPriceLabel.right + MARGIN_S;
    
    float width2 = [_nowPriceLabel2.text widthWithFont:_nowPriceLabel2.font boundingRectWithSize:CGSizeMake(100, _nowPriceLabel2.height)];
    _nowPriceLabel2.width = width2;
    _agoPriceLabel2.left = _nowPriceLabel2.right + MARGIN_S;

  
    
//    //商家信息
    _storeNameLabel.text = _grouponModel.groupon_name;
    _shengYuTimeLabel.text = [NSString stringWithFormat:@"剩余%d天",_grouponModel.surplus_day.intValue];
    _yiShouLabel.text = [NSString stringWithFormat:@"已售%d件",_grouponModel.sales.intValue];
   _shiYongFanWeiLabel.text = [NSString stringWithFormat:@"使用范围（%d家）",_storeModel.store_number.intValue];

    //显示更多分点信息
    if (_storeModel)
    {
        _moreStoreFrameView.hidden = NO;
        
        _moreStoreNameLabel.text  = _storeModel.store_name;
        _moreStoreAddressLabel.text = _storeModel.address;
        _moreStoreListView.hidden = YES;
        _moreStoreFrameView.height = 136;
        if (_storeModel.store_number.intValue > 1)//是否有更多分店
        {
            _moreStoreFrameView.height = 136;
            _moreStoreListView.hidden = NO;
        }
    }else
    {
        _moreStoreFrameView.height = 96;
        _moreStoreFrameView.hidden = YES;
    }
    
    //团购详情
    _grouponDetailsWebView.delegate = self;
    [_grouponDetailsWebView loadHTMLString: [NSString isBlankString:_grouponModel.content] ? @"暂无团购详情"  : _grouponModel.content baseURL:nil];
    //团购须知
    _howBuyWebView.delegate = self;
    [_howBuyWebView loadHTMLString:[NSString isBlankString:_grouponModel.notice] ? @"暂无购买须知"  : _grouponModel.notice baseURL:nil];
    
    //加线
    FrameLineView *lineViewOne = [[FrameLineView alloc]initWithFrame:CGRectMake(0, 45.5, SCREEN_WIDTH, 0.5)];
    [_groupFeameView addSubview:lineViewOne];

    [_layOutFrameView layoutSuperView];
    
}

#pragma mark UIWebViewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.height = webView.scrollView.contentSize.height;
    
    if (webView == _grouponDetailsWebView)
    {
        
        _grouponDetailsWebView.height = webView.height;
        _groupFeameView.height = _grouponDetailsWebView.height;
        
        _grouponDetailFrameView.top = _moreStoreFrameView.bottom - MARGIN_M*3;
        _grouponDetailFrameView.height = _grouponDetailsWebView.height+25;
        
    } else if (webView == _howBuyWebView)
    {
        _howBuyWebView.height = webView.height;
        _howFrameView.height = _howBuyWebView.height;
        
        _howBuyFrameView.height = _howBuyWebView.height+25;
    }
    
    
    [_layOutFrameView layoutSuperView];
    [_scrollView setContentSize:CGSizeMake(self.view.width, _scrollView.contentSize.height+MARGIN_L*3)];
    
}
#pragma mark  =============UIScrollView=========
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= _priceShowFrameView.top)
    {
        _priceShowFrameView.hidden = YES;
        _topMustBuyFrameView.hidden = NO;
    } else {
        _priceShowFrameView.hidden = NO;
        _topMustBuyFrameView.hidden = YES;
    }
}

#pragma mark==================数据处理==============

/**
 *  定位当前位置
 */


#pragma mark Request
-(void) sendReqeustOfGrouponDetails
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_grouponModel.groupon_id forKey:@"groupon_id"];
    
    [GrouponDetailsRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
             
         {
             RELEASE_SAFELY(_grouponModel);
             _grouponModel = request.resultDic[KRequestResultDataKey] ;
             
             if (!_storeModel)
             {

                 _storeModel = _grouponModel.store ;
                 
             }else
             {
                 _grouponModel.store = _storeModel;
             }
             
             [self refreshUI];
             self.contentView.hidden = NO;
             [self hidePromptView];
             
         }else
         {
             if (request.resultDic)
             {
                 [self showServerErrorPromptView];
             }else
             {
                 [self showNetErrorPromptView];
             }
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request) {
         [self showNetErrorPromptView];
     }];
}


#pragma mark UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *mobile = [actionSheet buttonTitleAtIndex:buttonIndex];
    [PhoneNumberHelper callPhoneWithText:mobile];
}

-(void) confirmSubmitOrder
{
    GroupBuyPayVC *groupBuyPayVC = [[GroupBuyPayVC alloc] initWithGrouponModel:_grouponModel];
    [self pushViewController:groupBuyPayVC];
}

//提交订单
- (IBAction)sumbitOrderAction:(id)sender
{
    if ([AccountHelper isLogin])
    {
        [self confirmSubmitOrder];
        
    }else
    {
        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType)
         {
             [self confirmSubmitOrder];
         }];
        
        LoginVC *loginVC = [[LoginVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

//更多分店信息
- (IBAction)moreStoreAction:(id)sender
{
//    OtherStoreInfoVC *otherStoreInfoVC = [[OtherStoreInfoVC alloc] initWithGrouponID:_grouponModel.groupon_id];
//    [self.navigationController pushViewController:otherStoreInfoVC animated:YES];
//    [otherStoreInfoVC release];
}

//呼叫分店
- (IBAction)callStore:(id)sender
{
    if (!_storeModel)
    {
        return;
    }
    
    NSArray *mobileArray = [PhoneNumberHelper parseText:_storeModel.phone];
    
    if (mobileArray && mobileArray.count>1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (NSString *mobile in mobileArray)
        {
            [actionSheet addButtonWithTitle:mobile];
        }
        
        [actionSheet addButtonWithTitle:@"取消"];
        
        [actionSheet showInView:self.view];
        
    }else
    {
        [PhoneNumberHelper callPhoneWithText:mobileArray[0]];
    }
}

#pragma mark ExpandFrameViewDeleagte
-(float)expandFrameView:(ExpandFrameView *)expandFrameView topMarginOfView:(UIView *)view
{
     if (view == _imageFrameView)
    {
        return 0;
    }else if ( view == _grouponDetailFrameView)
    {
        return -MARGIN_S*2;
    }
    else if (view == _howBuyFrameView)
    {
        return MARGIN_L;
    }else if (view == _moreStoreFrameView)
    {
        return MARGIN_L;
    }
//
       //默认为10 也可以重写此方法来返回想要的距离
    return MARGIN_M;
    
}

@end