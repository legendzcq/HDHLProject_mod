//
//  RechargeRecoderVC.m
//  Carte
//
//  Created by zln on 14/12/30.
//
//

#import "RechargeRecoderVC.h"
#import "RechargeRecoderCell.h"
#import "RechargeRecoderRequest.h"
#import "RechargeConfirmVC.h"

@interface RechargeRecoderVC ()
{
    NSString *_brandID;
}
@end

@implementation RechargeRecoderVC


-(id) initWithBrandID:(NSString *) brandID
{
    
    if (self = [super init])
    {
        _brandID = brandID;
    }
    return self;
}

- (void)configViewController
{
    [super configViewController];
    [self.navigationBarView setNavigationBarTitle:@"充值记录"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setRowHeight:105];
    //充值记录
    [self sendWithRechargeRecoderRequestWithPageNumber:1 indicatorView:self.view];
    
}

#pragma mark - TriggerRefresh

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendWithRechargeRecoderRequestWithPageNumber:1 indicatorView:self.indicatorViewSuper];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendWithRechargeRecoderRequestWithPageNumber:self.pageModel.pagenow.intValue+1 indicatorView:self.indicatorViewSuper];
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [RechargeRecoderCell class];
}

-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    RechargeRecoderModel *model = (RechargeRecoderModel *)self.dataArray[indexPath.row];
    RechargeRecoderCell *ssCell = (RechargeRecoderCell *)cell;
    ssCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [ssCell setCellData:model];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//发送充值初始化请求
- (void)sendWithRechargeRecoderRequestWithPageNumber:(NSInteger)pageNumber indicatorView:(UIView *)inView
{
    [RechargeRecoderRequest requestWithParameters:@{@"user_id":User_Id, @"p":[NSString stringWithFormat:@"%ld",(long)pageNumber],@"s_id":_brandID} withIndicatorView:inView onRequestFinished:^(ITTBaseDataRequest *request) {
        [self endPullRefresh];
        if (request.isSuccess) {
            
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
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
