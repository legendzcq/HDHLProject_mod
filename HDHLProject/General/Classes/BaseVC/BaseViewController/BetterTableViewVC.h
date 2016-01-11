//
//  BetterTableViewVC.h
//  KunshanTalent
//
//  Created by ligh on 13-11-7.
//
//

#import "BetterVC.h"
#import "BetterTableCell.h"
#import "PageModel.h"

@interface BetterTableViewVC : BetterVC  <UITableViewDataSource,UITableViewDelegate>

///////////////////////////////////////////////////////////////////////////////
#pragma mark  Views
///////////////////////////////////////////////////////////////////////////////

//展示的TableView
@property (strong,nonatomic) IBOutlet UITableView   *tableView;
@property (strong,nonatomic) UIView *indicatorViewSuper; //上拉下拉刷新loading图（默认 nil）

///////////////////////////////////////////////////////////////////////////////
#pragma mark  data
///////////////////////////////////////////////////////////////////////////////

@property (strong,nonatomic) PageModel *pageModel;

//获取目前的数据
- (NSMutableArray *)dataArray;
//设置数据 清空原有数据
- (void) setDataArray:(NSArray *)dataArray;
//追加数据
- (void) appendDataArray:(NSArray *)dataArray;

//清空数据
- (void)clearDataArray;
- (void)removeDataAtIndex:(NSInteger)index;
- (void)removeDataAtIndexAndReload:(NSInteger)index;

- (void)removeForData:(id)data;
- (void)removeForDataAndReload:(id)data;

//禁用下拉刷新和上提加载更多
- (void)disablePullRefresh;
- (void)endPullRefresh;
//去掉暂无数据的提示
- (void)clearPromView;

///////////////////////////////////////////////////////////////////////////////
#pragma mark  data
///////////////////////////////////////////////////////////////////////////////
//返回TableView要显示的Cell class
- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewCell:(UITableViewCell *)cell configCellForData:(id)data;
- (void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath;

@end
