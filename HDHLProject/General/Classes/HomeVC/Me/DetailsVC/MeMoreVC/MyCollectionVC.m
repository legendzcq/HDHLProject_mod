

//
//  MyCollectionVC.m
//  HDHLProject
//
//  Created by hdcai on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyCollectionVC.h"
#import "MyCollectionCell.h"
#import "MyCollectionModel.h"
#import "MyCollectionRequest.h"

@interface MyCollectionVC ()

@end

@implementation MyCollectionVC

- (void)configViewController
{
    [super configViewController];
    [self.navigationBarView setNavigationBarTitle:@"我的收藏"];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:81];
    
    //充值记录
    [self sendWithMyCollectionRequestWithPageNumber:1];
    
}

#pragma mark - TriggerRefresh

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendWithMyCollectionRequestWithPageNumber:1];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendWithMyCollectionRequestWithPageNumber:self.pageModel.pagenow.intValue+1];
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [MyCollectionCell class];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    MyCollectionModel *myCollectionModel = (MyCollectionModel*)self.dataArray[indexPath.row];
//    if (myCollectionModel.order_id) {
//        RechargeConfirmVC *rechargeConfirmVC = [[RechargeConfirmVC alloc]initWithOrderID:myCollectionModel.order_id withRechargeConfirmWithType:RechargeConfirmWithRechargeRecoderType];
//        [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//发送充值初始化请求
- (void)sendWithMyCollectionRequestWithPageNumber:(NSInteger)pageNumber
{
    [MyCollectionRequest requestWithParameters:@{@"user_id":[AccountHelper userInfo].user_id, @"p":[NSString stringWithFormat:@"%ld",(long)pageNumber],@"s_id":@"13"} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        if (request.isSuccess) {
            
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
            
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        [self showNetErrorPromptView];
    }];
}

@end
