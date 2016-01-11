//
//  OrderVC.m
//  HDHLProject
//
//  Created by liu on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "OrderVC.h"
//cell
#import "OrderListCell.h"
//订座类的详情
#import "SeatDetailVC.h"
#import "TakeOrderPayVC.h"
#import "LoginVC.h"
//点菜类的详情
#import "OrderDetailVC.h"
#import "MyDishOrderRequest.h"
#import "NotLoginView.h"

#define OrderVCTableViewHead_Frame CGRectMake(0, 0,SCREEN_WIDTH, 12)
#define OrderVCTableViewFoot_Frame CGRectMake(0, 0,SCREEN_WIDTH, 49)
#define OrderCellHeight 103.0f

@interface OrderVC ()<PayBtnDelegate>

@end

@implementation OrderVC


- (void)configViewController
{
    [super configViewController];
    self.navigationBarView.navigationBarTitleLabel.text = @"订单";
    self.navigationBarView.leftBarButton.hidden = YES ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderListView:) name:kLoginOnceMoreNotification object:nil];
    //刷新订单列表（点菜下单完成后跳转到点菜列表）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderListView:) name:kRefreshOrdersListNotification object:nil];
    
    [self adjustTableView];
    [self refreshOrderListView:nil];
}
- (void)refreshOrderListView:(NSNotification *)userfo
{
    if ([AccountHelper isLogin]){
        [NotLoginView dismissFromSuperView:self.contentView];
        [self startToRequestWithPageNumber:1];
    }else{
      [NotLoginView showInView:self.contentView WithText:@"您还没有登录，请登录后查看订单"WithBoolTableBarView:YES  WithBlock:^{
          LoginVC *loginVC= [[LoginVC alloc]init];
         [self pushFromRootViewControllerToViewController:loginVC animation:YES];
      }];
    }
}
- (void)adjustTableView
{
    UIView *adjustView = [[UIView alloc]initWithFrame:OrderVCTableViewHead_Frame];
    self.tableView.tableHeaderView =adjustView;
    [self.tableView setRowHeight:OrderCellHeight];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footAdjustView = [[UIView alloc]initWithFrame:OrderVCTableViewFoot_Frame];
    self.tableView.tableFooterView = footAdjustView;
}

- (void)startToRequestWithPageNumber:(int)pageNumber
{
    [MyDishOrderRequest requestWithParameters:@{@"p":[NSString stringWithFormat:@"%d",(int)pageNumber], @"user_id":[AccountHelper uid]} withIndicatorView:self.contentView onRequestFinished:^(ITTBaseDataRequest *request){
        [self.tableView endRefreshing];
        if (request.isSuccess)
        {
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
            [self clearPromView];
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


- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [OrderListCell class];
}
-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *orderCell = (OrderListCell *)cell;
    id model = self.dataArray[indexPath.row];
    [orderCell configerWithDataSource:model];
    orderCell.payDelegate = self;
}
#pragma mark - 上拉下拉 -

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self startToRequestWithPageNumber:1];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
   [self startToRequestWithPageNumber:self.pageModel.pagenow.intValue + 1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *orderModel = [self.dataArray objectAtIndex:indexPath.row];
    if ([orderModel.order_type intValue] ==DishOrderType){
        OrderDetailVC *orderVC = [[OrderDetailVC alloc]initWithOrderModel:orderModel];
        [self pushFromRootViewControllerToViewController:orderVC animation:YES];
    }else{
        SeatDetailVC *seatVC =[[SeatDetailVC alloc]initWithOrderModel:orderModel];
        [self pushFromRootViewControllerToViewController:seatVC animation:YES];
    }
}

#pragma mark - 继续支付 -
- (void)startToPayWithModel:(OrderModel *)orderModel
{
    TakeOrderPayVC *payVC = [[TakeOrderPayVC alloc]initWithOrderNumber:orderModel.order_id];
    [self pushFromRootViewControllerToViewController:payVC animation:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
