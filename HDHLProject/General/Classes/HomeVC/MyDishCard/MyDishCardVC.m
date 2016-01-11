//
//  MyDishCardVC.m
//  Carte
//
//  Created by liu on 15-4-14.
//
//

#import "MyDishCardVC.h"
#import "MyDishCardCell.h"
#import "MessageCenterVC.h"
#import "SearchStoreVC.h"
#import "SetAddressVC.h"

//请求类
#import "MyDishCardsRequest.h"
#import "OptionalBrandRequest.h"
#import "UnPayOrdersRequest.h"
#import "QRCodeAddCardRequest.h"
//model类
#import "BrandModel.h"
#import "OrderModel.h"
//定位类
#import "BMKLocationManager.h"
//去结账VC
#import "TakeOrderPayVC.h"
#import "CityListVC.h"
#import "TakeOrderVC.h"

#define MyDishCardTableViewHead_Frame CGRectMake(0, 0,SCREEN_WIDTH,10)
#define MyDishCardTableViewFoot_Frame CGRectMake(0, 0,SCREEN_WIDTH,49)
#define MyDishCardTableView_RowHeight SCREEN_WIDTH==320?141:182.5

#define MyDishCardView_Frame CGRectMake(0, 0, self.contentView.size.width, self.contentView.size.height)

#define MyDishCard_MaxTextCount  9  //允许出现的最多文字数
#define MyDishCard_TitleFont     [UIFont boldSystemFontOfSize:19.0f]//标题的字体大小
#define MyDishCard_TitleLabel_Frame CGRectMake(16 ,0, detailSize.width, 44) //标题的frame
#define MyDishCard_AddressImageView_Frame CGRectMake(0, 15, 11, 14);//位置图标
#define MyDishCard_DropDownView_Frame CGRectMake(9 +detailSize.width, 7, 30, 30)//三角图标
#define MyDishCard_TitleBtn_Frame CGRectMake(0, 0, self.titleView.width, 44)//标题按钮
#define MyDishCard_Title_Height 44.0f

static CLLocation *userLocation = nil;
static BOOL requestUnPayOrders = NO ;
static NSString *startLocaitonAginString =@"startLocaitonAgin" ;

@interface MyDishCardVC ()<ChooseStoreDelegate>

@property  (nonatomic,strong) UIView *titleView;
@property  (nonatomic,strong) NSString *titleString;
@property  (nonatomic,assign) BOOL locationSucess; //定位失败不显示距离
@end

@implementation MyDishCardVC
{
    CLLocation *_userLocation;//定位到的用户位置
}

- (void)configViewController
{
    [super configViewController];
    self.titleString = @"正在定位中...";
    self.navigationBarView.leftBarButton.hidden = YES;
    self.navigationBarView.rightBarButton.hidden = NO;
    self.locationSucess = NO ;
    //再次登录通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMeVCData) name:kLoginOnceMoreNotification object:nil];
    [self setRightNavigationBarButtonStyle:UIButtonStyleSearch];
    [self clearPromView];
    [self adjustTableView];
    [self addSearchTitleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
      [self startLocaiton]; // 写在configViewController里面，程序卡死。
    });
}
- (void)refreshMeVCData
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kRechargeConfirmNotification object:nil];
    [self startLocaiton];
}


#pragma mark - 构造顶部视图 -

- (void)addSearchTitleView
{
    if(self.titleView){
        [self.titleView removeAllSubviews];
        [self.titleView removeFromSuperview];
        self.titleView = nil ;
    }
    [self.navigationBarView setNavBarTitleViewHide];
    NSString *string = self.titleString;
    NSString * lengthString = [string length]>=MyDishCard_MaxTextCount?[string substringToIndex:MyDishCard_MaxTextCount-1]:string;
    CGSize detailSize = [lengthString sizeWithFont:MyDishCard_TitleFont constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat titleViewWidth =detailSize.width+30+9;
    self.titleView= [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- titleViewWidth)/2,IOS_VERSION_CODE > 6? 20:0,  titleViewWidth, MyDishCard_Title_Height)];
    
    // 算出第一个view的左起点
    
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = MyDishCard_TitleLabel_Frame;
    label.text = string;
    label.font = MyDishCard_TitleFont;
    label.textColor= [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:label];
   
    UIImageView *addressImageView =[[UIImageView alloc]init];
    addressImageView.image = [UIImage imageNamed:@"home_map.png"];
    addressImageView.frame = MyDishCard_AddressImageView_Frame;
    [self.titleView addSubview:addressImageView];
    
    UIImageView *dropDownView = [[UIImageView alloc]init];
    dropDownView.image= [UIImage imageNamed:@"home_triangle.png"];
    dropDownView.frame = MyDishCard_DropDownView_Frame;
    [self.titleView addSubview:dropDownView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = MyDishCard_TitleBtn_Frame;
    [button addTarget:self action:@selector(navigationBarCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:button];
    
    [self.navigationBarView addSubview:self.titleView];
    self.titleView.centerX = self.navigationBarView.centerX;
    [self.navigationBarView bringSubviewToFront:self.titleView];
}
- (void)navigationBarCenterBtnClick
{
    SetAddressVC *seatAdressVC = [[SetAddressVC alloc]init];
    seatAdressVC.adressBlock = ^(NSString * adressString,NSString *cityString)
    {
        if(adressString == startLocaitonAginString)
        {
            [self startLocaiton];
        }else
        {
            //判断是否有效
            if([NSString isBlankString:adressString]){
                [BDKNotifyHUD showCryingHUDInView:self.contentView text:@"地址信息不能为空"];
                return ;
            }
          // 定位地址位置
            self.titleString =adressString;
            [[BMKLocationManager defaultInstance] startGeoCodeSearchWithCity:cityString adressText:adressString reverseGeoCodeBlock:^(BMKGeoCodeResult*result){
                CLLocation *location = [[CLLocation alloc]initWithLatitude:result.location.latitude longitude:result.location.longitude];
                userLocation = location;
                [self addSearchTitleView];
                [self sendRequestOfMyDishOrdersWithPageNumber:1 WithLocation:location];
            } reverseGeoCodeFailBlock:^(NSString * error){
                [BDKNotifyHUD showCryingHUDInView:self.contentView text:error];
            } ];
        }
    };
    [self pushFromRootViewControllerToViewController:seatAdressVC animation:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  //  [KAPP_DELEGATE showTabBar];
}
- (void)viewWillDisappear:(BOOL)animated
{
    requestUnPayOrders = YES ;
    [self cancelAllRequest];
    self.tableView.frame = MyDishCardView_Frame;
    [super viewWillDisappear:YES];
}

- (void)cancelAllRequest
{
    [MyDishCardsRequest cancelUseDefaultSubjectRequest];//取消请求进入下一级页面
    [OptionalBrandRequest cancelUseDefaultSubjectRequest];
    [UnPayOrdersRequest cancelUseDefaultSubjectRequest];
    [QRCodeAddCardRequest cancelUseDefaultSubjectRequest];
    [[BMKLocationManager defaultInstance] stopUpdatingLocation];
}

#pragma mark - 请求类 -

-(void) sendRequestOfMyDishOrdersWithPageNumber:(NSInteger) pageNumber WithLocation:(CLLocation *)searchLocation
{
    [MyDishCardsRequest cancelUseDefaultSubjectRequest];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if (searchLocation)
    {
        [parameters setObject:[NSString stringWithFormat:@"%f",searchLocation.coordinate.latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%f",searchLocation.coordinate.longitude] forKey:@"lng"];
    }else{
        [parameters setObject:@"" forKey:@"lat"];
        [parameters setObject:@"" forKey:@"lng"];
    }
   [parameters setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"p"];
    [MyDishCardsRequest requestWithParameters:parameters withIndicatorView:self.contentView onRequestFinished:^(ITTBaseDataRequest *request){
       [self.tableView endRefreshing];
            if (request.isSuccess)
        {
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
            [self clearPromView];
            self.contentView.hidden = NO ;
            if(!pageModel.listArray.count){
                [self clearDataArray];
                [self showPromptViewWithText:@"没找到符合条件的店铺"];
            }
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
    } onRequestFailed:^(ITTBaseDataRequest *request){
        [self.tableView endRefreshing];
        [self showNetErrorPromptView];
    }];
}

# pragma mark - 调整TABLEVIE 的FRAME -
- (void)adjustTableView
{
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView setRowHeight: MyDishCardTableView_RowHeight];
    self.tableView.frame = MyDishCardView_Frame;
    UIView *adjustTableView = [[UIView alloc]initWithFrame:MyDishCardTableViewHead_Frame];
    self.tableView.tableHeaderView =adjustTableView;
    UIView *adjustFootView = [[UIView alloc]initWithFrame:MyDishCardTableViewFoot_Frame];
    self.tableView.tableFooterView = adjustFootView;
}

#pragma mark - TableViewDelegate -

-(Class)cellClassForIndexPath:(NSIndexPath *) indexPath
{
    return [MyDishCardCell class] ;
}
-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    MyDishCardCell *dishCardCell = (MyDishCardCell *)cell;
    dishCardCell.brandModel = self.dataArray[indexPath.row];
    dishCardCell.delegate = self ;
    [dishCardCell configerWithDataSource:self.dataArray [indexPath.row]];
    [dishCardCell showDistanceOrNotWithBool:self.locationSucess];
}

#pragma mark - 上拉下拉 -

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self cancelAllRequest];
    [self sendRequestOfMyDishOrdersWithPageNumber:1 WithLocation:userLocation];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self cancelAllRequest];
    [self sendRequestOfMyDishOrdersWithPageNumber:self.pageModel.pagenow.intValue + 1 WithLocation:userLocation];
}

#pragma mark  - 代理方法 -

- (void)startToChooseStoreWithModel:(BrandModel *)model
{
    if(!model.store_id){
        [BDKNotifyHUD showCryingHUDInView:self.contentView text:@"跳转店铺失败"];
        return ;
    }
    TakeOrderVC  *takeOrderVC = [[TakeOrderVC alloc]initWithStoreID:model.store_id];
    [self pushFromRootViewControllerToViewController:takeOrderVC animation:YES];
}
#pragma mark - 定位当前用来获取可添加的店铺 -

- (void)startLocaiton
{
    // 定位当前位置经纬度，并将经纬度解析为地址
    [[BMKLocationManager defaultInstance] startUpdatingLocationWithUpdateBMKUserLocationBlock:^(BMKUserLocation *bmkLocation) {
        userLocation = bmkLocation.location;
        self.locationSucess = YES ;
        [self sendRequestOfMyDishOrdersWithPageNumber:1 WithLocation:userLocation];
        [[BMKLocationManager defaultInstance] startGeoCodeSearchWithUserLocation:bmkLocation reverseGeoCodeBlock:^(NSDictionary *address) {
            NSString *addressString = [NSString stringWithFormat:@"%@%@%@",address[@"district"],address[@"streetName"],address[@"streetNumber"]];
            self.titleString = addressString;
            [self addSearchTitleView];
        }reverseGeoCodeFailBlock:^(NSString *error) {
            self.titleString = @"定位失败";
            [self addSearchTitleView];
             [BDKNotifyHUD showCryingHUDInView:self.contentView text:@"获取当前地址失败"];
        }];
    } errorBlock:^(NSError *error){
        self.titleString = @"定位失败";
        [self addSearchTitleView];
        self.locationSucess = NO ;
        [self sendRequestOfMyDishOrdersWithPageNumber:1 WithLocation:nil];
    }];
}

-(void)actionClickNavigationBarRightButton
{
    SearchStoreVC *searStoreVC = [[SearchStoreVC alloc]init] ;
    searStoreVC.location = userLocation;
    [self pushFromRootViewControllerToViewController:searStoreVC animation:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
