

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
#import "NotLoginView.h"
#import "RechargeVC.h"
#import "TakeOrderVC.h"
@interface MyCollectionVC ()<MyCollectionCellCheckDelegate>


@end

@implementation MyCollectionVC

- (void)configViewController
{
    [super configViewController];
    [self.navigationBarView setNavigationBarTitle:@"我的收藏"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:kLoginOnceMoreNotification object:nil];
    [self refreshUI];
}

-(void)refreshUI
{
    if ([AccountHelper isLogin]){
        [NotLoginView dismissFromSuperView:self.contentView];
        [self sendWithMyCollectionRequestWithPageNumber:1 indicatorView:self.view];
    }else{
        [NotLoginView showInView:self.contentView WithText:@"您还没有登录" WithBoolTableBarView:NO WithBlock:^{
            LoginVC *loginVC= [[LoginVC alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
}

#pragma mark - TriggerRefresh

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendWithMyCollectionRequestWithPageNumber:1 indicatorView:self.indicatorViewSuper];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendWithMyCollectionRequestWithPageNumber:self.pageModel.pagenow.intValue+1 indicatorView:self.indicatorViewSuper];
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [MyCollectionCell class];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    MyCollectionModel *myCollectionModel = (MyCollectionModel*)self.dataArray[indexPath.row];
    TakeOrderVC *takeorderVC = [[TakeOrderVC alloc]initWithStoreID:myCollectionModel.store_id];
    [self pushFromRootViewControllerToViewController:takeorderVC animation:YES];
}

-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionModel *model = (MyCollectionModel *)self.dataArray[indexPath.row];
    MyCollectionCell *ssCell = (MyCollectionCell *)cell;
    ssCell.delegate = self;
    ssCell.indexPath = indexPath;
    ssCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [ssCell setCellData:model];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark MyCollectionDelegate
-(void)checkMyCollectionCellWithModel:(MyCollectionModel *)myCollectionModel WithIndexPath:(NSIndexPath *)indexPath
{
    RechargeVC *rechargeVC = [[RechargeVC alloc]initWithBrandID:myCollectionModel.brand_id withStoreID:myCollectionModel.store_id];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

//发送收藏请求
- (void)sendWithMyCollectionRequestWithPageNumber:(NSInteger)pageNumber indicatorView:(UIView *)inView
{
    [MyCollectionRequest requestWithParameters:@{@"user_id":User_Id, @"p":[NSString stringWithFormat:@"%ld",(long)pageNumber]} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        if (request.isSuccess) {
            [self hidePromptView];
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
            self.contentView.hidden = NO;
        }else{
            if (request.resultDic)
            {
                [self showServerErrorPromptView];
            }else
            {
                [self showNetErrorPromptView];
            }
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        [self showNetErrorPromptView];
    }];
}

@end
