//
//  PromotionsListVC.m
//  HDHLProject
//
//  Created by Mac on 15/7/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PromotionsListVC.h"
#import "PreferentialListRequest.h"
#import "GroupBuyCell.h"
#import "WebVC.h"
#import "GroupBuyDetailsVC.h"

@interface PromotionsListVC () {
    CLLocation *_userLocation; //定位到的用户位置
    NSString   *_storeID;//如果有值 则为该分店下的团购列表
    ITTMaskActivityView *activityView;
}
@end

@implementation PromotionsListVC

- (void)dealloc {
    RELEASE_SAFELY(_userLocation);
    RELEASE_SAFELY(_storeID);
    RELEASE_SAFELY(activityView);
}

- (id)initWithStoreID:(NSString *)storeID {
    if (self = [super init]) {
        _storeID = storeID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"超级促销"];
    [self startLocateMyPosition];
}

- (void)configViewController {
    [super configViewController];
    [self.tableView setRowHeight:97];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [activityView hide];
    [[BMKLocationManager defaultInstance] bMapStopUserLocationService];
    [PreferentialListRequest cancelUseDefaultSubjectRequest];
}

- (void)actionClickNavigationBarLeftButton {
    [PreferentialListRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

- (NSString *)defaultNoDataPromptText {
    return @"暂无超级促销,敬请期待!";
}

#pragma mark TableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView {
    [self sendRequestOfPreferentialListWithPageNumber:1 indicatorView:self.indicatorViewSuper];
}

- (void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView {
    [self sendRequestOfPreferentialListWithPageNumber:self.pageModel.pagenow.intValue+1 indicatorView:self.indicatorViewSuper];
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
    return [GroupBuyCell class];
}

- (void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath {
    GrouponModel *model = (GrouponModel *)self.dataArray[indexPath.row];
    GroupBuyCell *gpCell = (GroupBuyCell *)cell;
    gpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [gpCell setCellData:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    GrouponModel *groupModel =self.dataArray[indexPath.row];
    if (groupModel.sale_type.intValue == GroupISShow) { //团购
        GroupBuyDetailsVC *detailsVC  = [[GroupBuyDetailsVC alloc] initWithGrouponID:groupModel.groupon_id];
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else { //活动
        WebVC *webVC = [[WebVC alloc] initWithContentID:groupModel.activity_id];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark -
#pragma mark - 启动定位

- (void)startLocateMyPosition {
    if (!activityView) {
        activityView = [ITTMaskActivityView viewFromXIB];
    }
    [activityView showInView:self.view];
    [[BMKLocationManager defaultInstance] startUpdatingLocationWithUpdateBMKUserLocationBlock:^(BMKUserLocation *userLocation) {
        [activityView hide];
        RELEASE_SAFELY(_userLocation);
        _userLocation = userLocation.location;
        [self sendRequestOfPreferentialListWithPageNumber:1 indicatorView:self.view];
    } errorBlock:^(NSError *error) {
        [activityView hide];
        [self sendRequestOfPreferentialListWithPageNumber:1 indicatorView:self.view];
    }];
}

#pragma mark -
#pragma mark - Requests

- (void)sendRequestOfPreferentialListWithPageNumber:(NSInteger)pageNumber indicatorView:(UIView *)inView {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_userLocation) {
        [params setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.latitude] forKey:@"lat"];
        [params setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.longitude] forKey:@"lng"];
    }
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_storeID forKey:@"store_id"];
    [params setObject:@"1" forKey:@"only_groupon"];
    [params setObject:[NSString stringWithFormat:@"%d",(int)pageNumber] forKey:@"p"];
    
    [PreferentialListRequest requestWithParameters:params withIndicatorView:inView onRequestFinished:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        if (request.isSuccess) {
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
        } else {
            if (request.isNoLogin) {
                return ;
            }
            if (request.resultDic) {
                [self showServerErrorPromptView];
            } else {
                [self showNetErrorPromptView];
            }
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        [self showNetErrorPromptView];
    }];
}

@end
