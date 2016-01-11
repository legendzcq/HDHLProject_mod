//
//  MyRefundVC.m
//  HDHLProject
//
//  Created by hdcai on 15/8/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyRefundVC.h"
#import "MyRefundModel.h"
#import "MyRefundCell.h"
#import "MyRefundRequest.h"
#import "LoginVC.h"
#import "NotLoginView.h"
@interface MyRefundVC ()


@end

@implementation MyRefundVC

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)configViewController
{
    [super configViewController];
    [self.navigationBarView setNavigationBarTitle:@"我的退款"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:kLoginOnceMoreNotification object:nil];
    [self refreshUI];
}

-(void)refreshUI
{
    if ([AccountHelper isLogin]){
        [NotLoginView dismissFromSuperView:self.contentView];
        [self sendWithMyRefundRequestWithPageNumber:1 indicatorView:self.view];
    }else{
        [NotLoginView showInView:self.contentView WithText:@"您还没有登录"WithBoolTableBarView:NO  WithBlock:^{
            LoginVC *loginVC= [[LoginVC alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
}
#pragma mark - TriggerRefresh

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendWithMyRefundRequestWithPageNumber:1 indicatorView:self.indicatorViewSuper];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendWithMyRefundRequestWithPageNumber:self.pageModel.pagenow.intValue+1 indicatorView:self.indicatorViewSuper];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [MyRefundCell class];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    MyRefundModel *model = (MyRefundModel *)self.dataArray[indexPath.row];
    MyRefundCell *ssCell = (MyRefundCell *)cell;
    ssCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [ssCell setCellData:model];
}

//发送退款请求
- (void)sendWithMyRefundRequestWithPageNumber:(NSInteger)pageNumber indicatorView:(UIView *)inView
{
        [MyRefundRequest requestWithParameters:@{@"user_id":User_Id, @"p":[NSString stringWithFormat:@"%ld",(long)pageNumber]} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
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
