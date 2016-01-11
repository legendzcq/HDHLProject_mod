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
#import "NotLoginPromptView.h"
#import "LoginVC.h"
@interface MyRefundVC ()
{
    NotLoginPromptView *_notLoginPromptView;
}
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
    
    _notLoginPromptView = [NotLoginPromptView viewFromXIB];
    _notLoginPromptView.viewController = self;
    [self.contentView addSubview:_notLoginPromptView];
    [self.contentView bringSubviewToFront:_notLoginPromptView];
    
    //充值记录
    [self sendWithMyRefundRequestWithPageNumber:1];
    
}
-(void)didClickGotoLoginVCButton
{
    LoginVC *loginVC = [[LoginVC alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - TriggerRefresh

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendWithMyRefundRequestWithPageNumber:1];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendWithMyRefundRequestWithPageNumber:self.pageModel.pagenow.intValue+1];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [MyRefundCell class];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
        MyRefundModel *myRefundModel = (MyRefundModel*)self.dataArray[indexPath.row];
//        if (myRefundModel.order_id) {
//            RechargeConfirmVC *rechargeConfirmVC = [[RechargeConfirmVC alloc]initWithOrderID:myRefundModel.order_id withRechargeConfirmWithType:RechargeConfirmWithRechargeRecoderType];
//            [self.navigationController pushViewController:rechargeConfirmVC animated:YES];
//        }
}

//发送充值初始化请求
- (void)sendWithMyRefundRequestWithPageNumber:(NSInteger)pageNumber
{
        [MyRefundRequest requestWithParameters:@{@"user_id":User_Id, @"p":[NSString stringWithFormat:@"%ld",(long)pageNumber],@"s_id":@"13"} withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
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
