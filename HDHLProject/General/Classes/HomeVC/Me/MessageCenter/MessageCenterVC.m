//
//  MessageCenterVC.m
//  Carte
//x
//  Created by zln on 14-9-9.
//
//

#import "MessageCenterVC.h"
#import "MessageCenterCell.h"
#import "MessageCenterRequest.h"
#import "MessageCenterModel.h"
#import "MessageModel.h"
#import "MessageStatusChangeRequest.h"
#import "NotLoginView.h"
#import "WebVC.h"
@interface MessageCenterVC ()


@end

@implementation MessageCenterVC

- (void)configViewController
{
    [super configViewController];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self setRightNavigationBarButtonStyle:UIButtonStyleMessage];
    self.navigationBarView.rightBarButton.hidden = YES;
    
    [self setNavigationBarTitle:@"我的消息"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:kLoginOnceMoreNotification object:nil];
    [self refreshUI];
}

-(void)refreshUI
{
    if ([AccountHelper isLogin]){
        [NotLoginView dismissFromSuperView:self.contentView];
        [self sendRequestOfMessageCenterWithPageNumber:1 indicatorView:self.view withIndexPath:nil];
    }else{
        [NotLoginView showInView:self.contentView  WithText:@"您还没有登录" WithBoolTableBarView:NO WithBlock:^{
            LoginVC *loginVC= [[LoginVC alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
}

-(void)actionClickNavigationBarLeftButton
{
    [MessageCenterRequest cancelUseDefaultSubjectRequest];
    [MessageStatusChangeRequest cancelUseDefaultSubjectRequest];
//    [super actionClickNavigationBarLeftButton];
    [self popFromViewControllerToRootViewControllerWithTabBarIndex:kTabbarIndex2 animation:YES];
}

-(NSString *)defaultNoDataPromptText
{
    return @"您还没有消息记录哦!";
}

#pragma mark UITableViewDelegate
-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendRequestOfMessageCenterWithPageNumber:1 indicatorView:self.indicatorViewSuper withIndexPath:nil];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendRequestOfMessageCenterWithPageNumber:self.pageModel.pagenow.intValue+1 indicatorView:self.indicatorViewSuper withIndexPath:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCenterModel *messageModel = self.dataArray[indexPath.row];
    return [MessageCenterCell cellHeightForModel:messageModel cellWidth:tableView.width];
}

-(Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [MessageCenterCell class];
}
- (void)tableViewCell:(MessageCenterCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    cell.width = self.contentView.width;
    cell.indexPath = indexPath ;
    [cell setCellData:self.dataArray [indexPath.row] withCellWidth:self.contentView.width];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sendRequestOfMessageCenterWithPageNumber:1 indicatorView:self.indicatorViewSuper withIndexPath:indexPath];
}

- (void)sendRequestOfMessageCenterWithPageNumber:(NSInteger)pageNumber indicatorView:(UIView *)inView withIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![NSString isBlankString:User_Id]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"p"];
    if (indexPath != nil) {
        MessageCenterModel *messageModel =  self.dataArray[indexPath.row];
        [params setObject:messageModel.message_id forKey:@"message_id"];
    }

    [MessageCenterRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {

      [self.tableView endRefreshing];
        if (request.isSuccess)
        {
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
        } else
        {
            if (request.resultDic) {
                [self showServerErrorPromptView];
            } else
            {
                [self showNetErrorPromptView];
            }
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
       [self.tableView endRefreshing];
        [self showNetErrorPromptView];
    }];
}



@end
