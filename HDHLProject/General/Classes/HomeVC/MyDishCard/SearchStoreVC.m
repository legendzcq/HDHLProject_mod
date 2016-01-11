//
//  SearchStoreVC.m
//  HDHLProject
//
//  Created by liu on 15/8/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SearchStoreVC.h"
#import "SearchStoreView.h"
#import "MyDishCardCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchStoreRequest.h"
#import "TakeOrderVC.h"

#define SearchStoreTableView_RowHeight 140
#define SearchStore_SearchBtnFrame CGRectMake(SCREEN_WIDTH+20, 27, 50, 30)
#define SearchStore_TitleFone 15.0f
#define SearchStore_SearchViewFrame CGRectMake(45, 20, SCREEN_WIDTH-65, 44)
#define SearchStore_SearchTextFeildFrame CGRectMake(0, 7, SCREEN_WIDTH-80, 30)


@interface SearchStoreVC ()<ChooseStoreDelegate>
@property (nonatomic,strong)SearchStoreView *searchView;
@property (nonatomic,strong)UIButton *searchBtn;
@property (nonatomic,strong)NSString *lastAdressString;//输入新的内容上下拉失效
@end

@implementation SearchStoreVC

- (void)configViewController
{
    [super configViewController];
    self.contentView.hidden = YES ;
    [self.tableView setRowHeight:SearchStoreTableView_RowHeight];
    [self addTitleView];// 创建搜索顶部视图
}

- (void)addTitleView
{
    // 创建搜索按钮
    if(!self.searchBtn){
        self.searchBtn = [self creatSearchButton];
        [self.navigationBarView addSubview:self.searchBtn];
    }
    // 搜说视图
    self.searchView = [SearchStoreView  viewFromXIB];
    [self.searchView textFeildChangeStateWithStartBlock:^{
            self.searchBtn.hidden = NO ;
           [UIView animateWithDuration:0.5 animations:^{
            self.searchView.searchTextFeild.width =SCREEN_WIDTH-110;
            self.searchBtn.left = self.searchView.searchTextFeild.right+50;
           }completion:^(BOOL finished) {
          
            }];
       }EndBlock:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.searchView.searchTextFeild.width =SCREEN_WIDTH-80;
            self.searchBtn.left = SCREEN_WIDTH;
        }completion:^(BOOL finished){
            self.searchBtn.hidden = YES ;
        }];
           if([self.searchView.searchTextFeild.text length]){
               self.lastAdressString = self.searchView.searchTextFeild.text;
               [self startToSearchStoreMessageWithPageNumber:1];
           }
      }];
    self.searchView.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.0];
    self.searchView.frame = SearchStore_SearchViewFrame;
    self.searchView.searchTextFeild.frame =SearchStore_SearchTextFeildFrame;
    [self.navigationBarView addSubview:self.searchView];
    [self.navigationBarView bringSubviewToFront:self.searchBtn];
}



#pragma mark - TableViewDelegate -

-(Class)cellClassForIndexPath:(NSIndexPath *) indexPath
{
    return [MyDishCardCell class] ;
}
-(void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    MyDishCardCell *dishCardCell = (MyDishCardCell *)cell;
    dishCardCell.brandModel = self.dataArray[indexPath.row];
    dishCardCell.delegate = self ;
    [dishCardCell configerWithDataSource:self.dataArray [indexPath.row]];
}

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    if([self isEffective]){
        [self startToSearchStoreMessageWithPageNumber:1];
    }else{
        [self.tableView endRefreshing];
    }
}
- (BOOL)isEffective //判断是否有效上下拉
{
    return [self.lastAdressString isEqualToString:self.searchView.searchTextFeild.text];
}

-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    if([self isEffective]){
        [self startToSearchStoreMessageWithPageNumber:self.pageModel.pagenow.intValue+1];
    }else{
        [self.tableView endRefreshing];
    }
}

- (UIButton *)creatSearchButton
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBtn.frame = CGRectMake(SCREEN_WIDTH+20, 27, 50, 30);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [searchBtn setTitleColor:ColorForHexKey(AppColor_OrderBottom_Selected) forState:UIControlStateNormal];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 3;
    searchBtn.hidden = YES ;
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setBackgroundColor:[UIColor whiteColor]];
    [searchBtn addTarget:self action:@selector(searchBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    return  searchBtn ;
}
- (void)searchBtnDidClick
{
    self.searchView.endSearchBlock();
}
- (void)startToSearchStoreMessageWithPageNumber:(int)pageNumber
{
    [self.searchView.searchTextFeild  resignFirstResponder];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.location)
    {
        [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.latitude] forKey:@"lat"];
        [parameters setObject:[NSString stringWithFormat:@"%f",self.location.coordinate.longitude] forKey:@"lng"];
    }else{
        [parameters setObject:@"" forKey:@"lat"];
        [parameters setObject:@""forKey:@"lng"];
    }
     [parameters setObject:self.searchView.searchTextFeild.text forKey:@"search"];
     [parameters setObject:[NSString stringWithFormat:@"%d",pageNumber] forKey:@"p"];
     [SearchStoreRequest requestWithParameters:parameters withIndicatorView:self.contentView onRequestFinished:^(ITTBaseDataRequest *request) {
        [self.tableView endRefreshing];
        if (request.isSuccess)
        {
            self.contentView.hidden =NO ;
            PageModel *pageModel = request.resultDic[KRequestResultDataKey];
            [self setPageModel:pageModel];
            if(!pageModel.listArray.count){
                [self showPromptViewWithText:@"没有符合条件的店铺"];
            }
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
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [self.tableView endRefreshing];
        [self showNetErrorPromptView];
    }];
}
- (void)actionClickNavigationBarRightButton
{
    self.searchView.endSearchBlock();
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  - 代理方法 -

- (void)startToChooseStoreWithModel:(BrandModel *)model
{
    if(!model.store_id){
        [BDKNotifyHUD showCryingHUDInView:self.contentView text:@"跳转店铺失败"];
        return ;
    }
    TakeOrderVC  *takeOrderVC = [[TakeOrderVC alloc]initWithStoreID:model.store_id];
    [self pushFromRootViewControllerToViewController:takeOrderVC animation:YES];
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
