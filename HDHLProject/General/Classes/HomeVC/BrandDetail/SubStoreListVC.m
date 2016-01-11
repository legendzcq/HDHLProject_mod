//
//  SubStoreListVC.m
//  HDHLProject
//
//  Created by hdcai on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SubStoreListVC.h"
#import "OrderSeatVC.h"
#import "TakeOrderVC.h"
#import "SubStoreCell.h"
#import "ITTMaskActivityView.h"

#import "StoreListRequest.h"
#import "CityListVC.h"
#import "WebVC.h"



@interface SubStoreListVC () <CityDelegate>
{
    StoreListActionType      _actionType;
    NSString *_brandID;
    CLLocation              *_userLocation;//定位到的用户位置
    NSString *_currentCity;
}
@end

@implementation SubStoreListVC

-(void)dealloc
{
    RELEASE_SAFELY(_userLocation);
    
}


-(id)initWithActionType:(StoreListActionType)actionType withBrandID:(NSString*)brandID withCityName:(NSString *)cityName
{
    if (self = [super init])
    {
        _actionType = actionType;
        _brandID = brandID;
        _currentCity = cityName;
    }
    return self;
    
}

-(StoreListActionType)storeActionType
{
    return _actionType;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)configViewController
{
    [super configViewController];
    
    [self.tableView setRowHeight:64];
    
    [self setNavigationBarTitle:@"分店选择"];
    self.contentView.hidden = YES;
    
    //定位城市（关闭地图模式按钮（2.0用不到））
    self.navigationBarView.rightBarButton.hidden = NO;
    [self setRightNavigationBarButtonStyle:UIButtonStylePosition];
    
    if (IOS_VERSION_CODE < 7) {
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    //设置右上角城市
    [self.navigationBarView.rightBarButton setTitle:_currentCity forState:UIControlStateNormal];
    //定位+解析数据
    [self starLocationAfterSendStoreListRequest];
    
}

#pragma mark - 启动定位
//启动定位
-(void) starLocationAfterSendStoreListRequest
{
    ITTMaskActivityView *activityView = [ITTMaskActivityView viewFromXIB];
    [activityView showInView:self.view];
    
    [[BMKLocationManager defaultInstance]startUpdatingLocationWithUpdateBMKUserLocationBlock:^(BMKUserLocation *userLocation) {
        RELEASE_SAFELY(_userLocation);
        _userLocation = userLocation.location;
        //如果城市信息不存在，则定位用户所在城市
        if ([NSString isBlankString:_currentCity]) {
            [[BMKLocationManager defaultInstance]startGeoCodeSearchWithUserLocation:userLocation reverseGeoCodeBlock:^(NSDictionary *address) {
                [self citySelectedAction:[CityModel formatCityName:address[@"city"]]];
                [activityView hide];
                
            } reverseGeoCodeFailBlock:^(NSString *error) {
                    
            }];
        }else{
            //城市信息存在定位经纬度成功后直接请求数据
            [self sendRequestOfSubStoreListWithPageNumber:1 indicatorView:self.view];
            [activityView hide];
        }
    } errorBlock:^(NSError *error) {
        [activityView hide];
    }];
}


#pragma mark ViewActions
-(void)actionClickNavigationBarLeftButton
{
    [StoreListRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

-(void)actionClickNavigationBarRightButton
{
    CityListVC *cityListVC = [[CityListVC alloc] initWithBrandID:_brandID];
    cityListVC.cityDelegate = self;
    [self.navigationController pushViewController:cityListVC animated:YES];
}

#pragma mark - CityDelegate

- (void)citySelectedAction:(NSString *)cityName;
{
    [self.navigationBarView.rightBarButton setTitle:cityName forState:UIControlStateNormal];
    
    //新城市分店列表
    _currentCity = cityName;
    [self sendRequestOfSubStoreListWithPageNumber:1 indicatorView:self.view];
}


#pragma mark - BetterTableViewDelegate

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendRequestOfSubStoreListWithPageNumber:1 indicatorView:self.indicatorViewSuper];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendRequestOfSubStoreListWithPageNumber:self.pageModel.pagenow.intValue + 1 indicatorView:self.indicatorViewSuper];
}

-(Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [SubStoreCell class];
}

-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    StoreModel *model = (StoreModel *)self.dataArray[indexPath.row];
    SubStoreCell *ssCell = (SubStoreCell *)cell;
    ssCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [ssCell setCellData:model];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StoreModel *storeModel = self.dataArray[indexPath.row];
    storeModel.userLocation = _userLocation;
    
    
    if (_actionType == StoreListBookSeatActionType)
    {
        //订座
        if ([_delegate respondsToSelector:@selector(storeList:selectStoreModel:)]) {
            [_delegate storeList:self selectStoreModel:storeModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            OrderSeatVC *orderSeatVC = [[OrderSeatVC alloc] initWithStoreIdOfOrderSeat:storeModel.store_id];
            [self.navigationController pushViewController:orderSeatVC animated:YES];
        }
        
    }else if(_actionType == StoreListTakeOrderActionType)
    {
        //点餐
        if ([_delegate respondsToSelector:@selector(storeList:selectStoreModel:)]) {
            [_delegate storeList:self selectStoreModel:storeModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            TakeOrderVC *takeOrderVC = [[TakeOrderVC alloc] initWithTakeOrderType:TakeOrderDefaultType storeModel:storeModel];
            [self.navigationController pushViewController:takeOrderVC animated:YES];
        }
        
    }
    else if(_actionType == StoreListTakewayActionType)
    {
        //外卖点餐
        if ([_delegate respondsToSelector:@selector(storeList:selectStoreModel:)]) {
            [_delegate storeList:self selectStoreModel:storeModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            TakeOrderVC *takeOrderVC = [[TakeOrderVC alloc] initWithTakeOrderType:TakeOrderOutType storeModel:storeModel];
            [self.navigationController pushViewController:takeOrderVC animated:YES];
        }
        
    }else if (_actionType == StoreListFromVouchersDetailsTakeOrderType){
        //优惠券点餐
        if ([_delegate respondsToSelector:@selector(storeList:selectStoreModel:)]) {
            [_delegate storeList:self selectStoreModel:storeModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            TakeOrderVC *takeOrderVC = [[TakeOrderVC alloc] initWithTakeOrderType:TakeOrderDefaultType storeModel:storeModel];
            [self.navigationController pushViewController:takeOrderVC animated:YES];
        }
    }else if (_actionType == StoreListFromVouchersDetailsTakewayType){
        //优惠券外卖
        if ([_delegate respondsToSelector:@selector(storeList:selectStoreModel:)]) {
            [_delegate storeList:self selectStoreModel:storeModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            TakeOrderVC *takeOrderVC = [[TakeOrderVC alloc] initWithTakeOrderType:TakeOrderOutType storeModel:storeModel];
            [self.navigationController pushViewController:takeOrderVC animated:YES];
        }
    }
    else if(_actionType == StoreListFromStoreDetailActionType)//品牌详情
    {
        [self.delegate storeList:self selectStoreModel:storeModel];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Requests

- (void)sendRequestOfSubStoreListWithPageNumber:(NSInteger)pageNumber indicatorView:(UIView *)inView
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_userLocation)
    {
        [params setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.latitude] forKey:@"lat"];
        [params setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.longitude] forKey:@"lng"];
    }
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [params setObject:_brandID forKey:@"s_id"];
    
    if (![NSString isBlankString:_currentCity]) {
        [params setObject:_currentCity forKey:@"city_name"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"p"];
    
    [StoreListRequest requestWithParameters:params withIndicatorView:inView onRequestFinished:^(ITTBaseDataRequest *request)
     {
         
         if (request.isSuccess)
         {
             [self endPullRefresh];

             PageModel *pageModel = request.resultDic[KRequestResultDataKey];
             [self setPageModel:pageModel];
             self.contentView.hidden = NO;
             
         }else
         {
             [self endPullRefresh];

             if (request.resultDic)
             {
                 [self showServerErrorPromptView];
             }else
             {
                 [self showNetErrorPromptView];
             }
         }
         
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [self endPullRefresh];
         [self showNetErrorPromptView];
     }];
    
}

@end
