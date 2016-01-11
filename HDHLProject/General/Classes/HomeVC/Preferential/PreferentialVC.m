//
//  PreferentialVC.m
//  HDHLProject
//
//  Created by Mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PreferentialVC.h"
#import "PreferentialListRequest.h"
#import "GroupBuyCell.h"
#import "WebVC.h"
#import "GroupBuyDetailsVC.h"

@interface PreferentialVC () {
    CLLocation *_userLocation; //定位到的用户位置
    ITTMaskActivityView *activityView;
    BOOL _isFirstAppear;
}
@end

@implementation PreferentialVC

- (void)dealloc {
    RELEASE_SAFELY(_userLocation);
    RELEASE_SAFELY(activityView);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [activityView hide];
    [[BMKLocationManager defaultInstance] bMapStopUserLocationService];
    [PreferentialListRequest cancelUseDefaultSubjectRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setContentViewWithTabBarViewShow];
    [self setNavigationBarTitle:@"优惠消息"];
    self.navigationBarView.leftBarButton.hidden = YES;
    _isFirstAppear = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_isFirstAppear) {
        [self startLocateMyPosition];
    }
}

- (void)configViewController {
    [super configViewController];
    //再次登录通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshGroupBuyList) name:kLoginOnceMoreNotification object:nil];
    [self.tableView setRowHeight:97];
}

- (void)refreshGroupBuyList {
    [self sendRequestOfPreferentialListWithPageNumber:1 indicatorView:self.view];
}

- (NSString *)defaultNoDataPromptText {
    return @"暂无优惠消息,敬请期待!";
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
    [gpCell setCellData:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    GrouponModel *groupModel =self.dataArray[indexPath.row];
    if (groupModel.sale_type.intValue == GroupISShow) { //团购
        GroupBuyDetailsVC *detailsVC  = [[GroupBuyDetailsVC alloc] initWithGrouponID:groupModel.groupon_id];
        [self pushFromRootViewControllerToViewController:detailsVC animation:YES];
    } else { //活动
        WebVC *webVC = [[WebVC alloc] initWithContentID:groupModel.activity_id];
        [self pushFromRootViewControllerToViewController:webVC animation:YES];
    }
}

#pragma mark -
#pragma mark - 启动定位

- (void)startLocateMyPosition {
    _isFirstAppear = NO;
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

