//
//  GroupBuyListVC.m
//  Carte
//
//  Created by ligh on 15-4-15.
//
//

#import "GroupBuyListVC.h"
#import "GroupBuyCell.h"
#import "GroupBuyDetailsVC.h"

#import "GrouponListRequest.h"
//#import "LocationManager.h"
#import "GrouponModel.h"
#import "WebVC.h"

@interface GroupBuyListVC ()
{
    CLLocation *_userLocation;//定位到的用户位置
}
@end

@implementation GroupBuyListVC

- (void)dealloc
{
    RELEASE_SAFELY(_userLocation);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [KAPP_Delegate showTabBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tableView.contentInset.top > 0) {
        [UIView beginAnimations:@"" context:nil];
        self.tableView.contentInset = UIEdgeInsetsZero;
        [self.tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
        [UIView commitAnimations];
    }
}

-(void)configViewController
{
    [super configViewController];
    //再次登录通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshGroupBuyList) name:kLoginOnceMoreNotification object:nil];
    
    self.navigationBarView.leftBarButton.hidden = YES;
    [self setNavigationBarTitle:@"优惠消息"];
    [self.tableView setRowHeight:97];
  //  [self.tableView setLoadMoreViewHidden:NO];
//    [self starLocationAfterSendGroupListRequest];
    [self sendRequestOfGroupbonListWithPageNumber:1];
}

- (void)refreshGroupBuyList
{
//    [self starLocationAfterSendGroupListRequest];
    [self sendRequestOfGroupbonListWithPageNumber:1];
}

-(void)actionClickNavigationBarLeftButton
{
    [GrouponListRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

-(NSString *)defaultNoDataPromptText
{
    return @"暂无优惠消息,敬请期待!";
}

#pragma mark TableViewDelegate

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendRequestOfGroupbonListWithPageNumber:1];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendRequestOfGroupbonListWithPageNumber:self.pageModel.pagenow.intValue+1];
}

-(Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [GroupBuyCell class];
}

-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    GrouponModel *model = (GrouponModel *)self.dataArray[indexPath.row];
    GroupBuyCell *gpCell = (GroupBuyCell *)cell;
    gpCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [gpCell setCellData:model];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
   // [KAPP_Delegate dismissTabBar];
    
    GrouponModel *groupModel =self.dataArray[indexPath.row];
    if (groupModel.sale_type.intValue == GroupISShow) { //团购
        GroupBuyDetailsVC *detailsVC  = [[GroupBuyDetailsVC alloc] initWithGrouponID:groupModel.groupon_id];
        [self.navigationController pushViewController:detailsVC animated:YES];
    } else { //活动
        WebVC *webVC = [[WebVC alloc] initWithContentID:groupModel.activity_id];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

//启动定位
-(void) starLocationAfterSendGroupListRequest
{
    ITTMaskActivityView *activityView = [ITTMaskActivityView viewFromXIB];
    [activityView showInView:self.view];
    
//    [[LocationManager defaultInstance] startUpdatingLocationWithUpdateToLocationBlock:^(BMKUserLocation *userLocation)
//     {
//         RELEASE_SAFELY(_userLocation);
//         _userLocation = [userLocation.location;
//         
//         [self sendRequestOfGroupbonListWithPageNumber:1];
//         
//         [activityView performSelector:@selector(hide) withObject:nil afterDelay:0.5];
//         
//     } errorBlock:^(NSError *error)
//     {
//         [activityView hide];
//         [self sendRequestOfGroupbonListWithPageNumber:1];
//     }];
}

#pragma mark Requests
- (void)sendRequestOfGroupbonListWithPageNumber:(NSInteger)pageNumber
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_userLocation) {
        [params setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.latitude] forKey:@"lat"];
        [params setObject:[NSString stringWithFormat:@"%f",_userLocation.coordinate.longitude] forKey:@"lng"];
    }
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%d",(int)pageNumber] forKey:@"p"];
    
    [GrouponListRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         [self.tableView endRefreshing];
         
         if (request.isSuccess)
         {
             PageModel *pageModel = request.resultDic[KRequestResultDataKey];
             [self setPageModel:pageModel];
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
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [self.tableView endRefreshing];
         [self showNetErrorPromptView];
     }];
    
}

@end

