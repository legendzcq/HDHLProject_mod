//
//  VouchersListVC.m
//  Carte
//
//  Created by ligh on 14-12-24.
//
//

#import "VouchersListVC.h"
#import "VoucherCell.h"
#import "MyVoucherRequest.h"
#import "NotLoginView.h"

@interface VouchersListVC ()
{
    IBOutlet UIButton *_unselectButton;
    IBOutlet UIView *_unselectBGView;
    NSString *_orderId;
}
@end

@implementation VouchersListVC

-(id)initWithOrderID:(NSString *)orderId
{
    if (self = [super init]) {
        _orderId = orderId;
    }
    return self;
}


-(void)configViewController
{
    [super configViewController];
    [self setNavigationBarTitle:@"我的优惠劵"];
    if ([NSString isBlankString:_orderId]) {
        _unselectBGView.hidden = YES;
        self.tableView.top = 0;
        self.tableView.height = self.contentView.height;
    }else{
        _unselectBGView.hidden = NO;
        [_unselectButton setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateNormal];
        self.tableView.height = self.contentView.height - _unselectBGView.height;
    }

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:kLoginOnceMoreNotification object:nil];
    [self refreshUI];
    
}
-(void)refreshUI
{
    if ([AccountHelper isLogin]){
        [NotLoginView dismissFromSuperView:self.contentView];
        [self sendRequestOfMyVouchersWithPageNumber:1 indicatorView:self.view];
    }else{
        [NotLoginView showInView:self.contentView WithText:@"您还没有登录"WithBoolTableBarView:NO  WithBlock:^{
            LoginVC *loginVC= [[LoginVC alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
}

-(void)clickPromptViewAction
{
    [self sendRequestOfMyVouchersWithPageNumber:1 indicatorView:self.view];
}

- (void)actionClickNavigationBarLeftButton
{
    [MyVoucherRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

//不选择优惠券按钮事件
- (IBAction)unSelectButtonClickAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(VouchersListDidSelectedVoucherWithVoucherModel:withUseVoucherBool:)]) {
        [self.delegate VouchersListDidSelectedVoucherWithVoucherModel:nil withUseVoucherBool:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

//- (NSString *)defaultNoDataPromptText
//{
//
//}

#pragma - mark UITableViewDelegate

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendRequestOfMyVouchersWithPageNumber:1 indicatorView:self.indicatorViewSuper];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    [self sendRequestOfMyVouchersWithPageNumber:self.pageModel.pagenow.intValue + 1 indicatorView:self.indicatorViewSuper];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [VoucherCell class];
}

- (void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    VoucherCell *voucherCell = (VoucherCell *)cell;
    VoucherModel *voucherModel = self.dataArray[indexPath.row];
    [voucherCell setCellData:voucherModel];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoucherModel *voucherModel = self.dataArray[indexPath.row];
    if (![NSString isBlankString:_orderId]) {
        if ([self.delegate respondsToSelector:@selector(VouchersListDidSelectedVoucherWithVoucherModel:withUseVoucherBool:)]) {
            [self.delegate VouchersListDidSelectedVoucherWithVoucherModel:voucherModel withUseVoucherBool:YES];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        return;
    }
}

#pragma - mark Request

- (void)sendRequestOfMyVouchersWithPageNumber:(NSInteger) pageNumber indicatorView:(UIView *)inView
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (![NSString isBlankString:User_Id]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    if (![NSString isBlankString:_orderId]) {
        [params setObject:_orderId forKey:@"order_id"];
    }
    [params setObject:[NSString stringWithFormat:@"%ld",(long)pageNumber] forKey:@"p"];
    [MyVoucherRequest requestWithParameters:params withIndicatorView:self.contentView onRequestFinished:^(ITTBaseDataRequest *request)
     {
        [self endPullRefresh];
         if (request.isSuccess)
         {
             [self hidePromptView];
             PageModel *pageModel = request.resultDic[KRequestResultDataKey];
             [self setPageModel:pageModel];
             self.contentView.hidden = NO;
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
         [self endPullRefresh];
         [self showNetErrorPromptView];
     }];
}


@end
