//
//  BetterTableViewVC.m
//  KunshanTalent
//
//  Created by ligh on 13-11-7.
//
//

#import "BetterTableViewVC.h"

@interface BetterTableViewVC ()
{
    NSMutableArray *_dataArray;
}
@end

@implementation BetterTableViewVC


- (void)dealloc
{
    RELEASE_SAFELY(_pageModel);
    RELEASE_SAFELY(_dataArray);
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    if(indexPath)
    {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


- (void)configViewController
{
    [super configViewController];
    _dataArray = [NSMutableArray array];
    
    //config tableView
    if (!_tableView)
    {
        self.indicatorViewSuper = nil;
        UIView *parentView = self.contentView ? self.contentView : self.view;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, parentView.width,parentView.height) style:UITableViewStylePlain];

        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [parentView addSubview:_tableView];
    }
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addHeader];
    [self addFooter];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if ([_tableView respondsToSelector:@selector(separatorInset)])
    {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = UIColorFromRGB(220, 220, 220);
    }
    
    [self setExtraCellLineHidden:_tableView];

    [_tableView setFooterHidden:YES];
    
    if ([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)])
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


//
- (void)addHeader
{
    // 添加下拉刷新头部控件
    __weak __typeof(self)weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf pullTableViewDidTriggerRefresh:weakSelf.tableView];
    }];
}

- (void)addFooter
{
    // 添加上拉刷新尾部控件
    __weak __typeof(self)weakSelf = self;
    [_tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf pullTableViewDidTriggerLoadMore:weakSelf.tableView];
    }];
    [_tableView setFooterHidden:YES];
}

/**
 * 隐藏talbeView多余的分割线
 *
 *  @param tableView 要隐藏分割线的tableView
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)showNoDataPromptView
{
    if (_dataArray.count > 0) {
        [self hidePromptView];
        return;
    }
    [super showNoDataPromptView];
}

- (void)showNetErrorPromptView
{
    if (_dataArray.count > 0) {
        [self hidePromptView];
        return;
    }
    [super showNetErrorPromptView];
}

- (void)showServerErrorPromptView
{
    if (_dataArray.count > 0) {
        [self hidePromptView];
        return;
    }
    [super showServerErrorPromptView];
}

- (void)clickPromptViewAction
{
   [self pullTableViewDidTriggerRefresh:_tableView];
}

- (PromptView *)promptView
{
    PromptView *promptView = [super promptView];
    promptView.size =self.tableView.size;
    return promptView;
}

- (void)showPromptViewWithText:(NSString *)text
{
    [self.tableView addSubview:[self promptView]];
    [[self promptView] setPromptText:text];
}

- (void)clearPromView
{
    for (UIView * obj in self.contentView.subviews)
    {
        if([obj isKindOfClass:[PromptView class]])
        {
            obj.hidden = YES ;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  config data
///////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//设置Cell数据默认实现

- (Class)cellClassForIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell class];
}

- (void)tableViewCell:(UITableViewCell *)cell configCellForData:(id)data
{

}

- (NSMutableArray *)dataArray
{
    return _dataArray;
}

- (void)setDataArray:(NSArray *)dataArray
{
    [_dataArray removeAllObjects];
    if (dataArray != nil && dataArray.count > 0) {
        [_dataArray addObjectsFromArray:dataArray];
        [_tableView reloadData];
    } else {
        [self showNoDataPromptView];
    }
}


- (void)setPageModel:(PageModel *)pageModel
{
    [_tableView setFooterHidden:!pageModel.isMoreData];
    
    if (pageModel == nil) {
        [self showNetErrorPromptView];
        return;
    }
    
    if (pageModel!= _pageModel) {
        RELEASE_SAFELY(_pageModel);
        _pageModel = [[PageModel alloc] init];
        _pageModel = pageModel;
    }
    
    if (pageModel.pagenow.intValue == 1) {
        [self setDataArray:pageModel.listArray];
    } else {
        [self appendDataArray:pageModel.listArray];
    }

    if (self.dataArray.count > 0 ) {
        [self hidePromptView];
    }
}

- (void)appendDataArray:(NSArray *)dataArray
{
    [_dataArray addObjectsFromArray:dataArray];
    if (_dataArray != nil && _dataArray.count > 0) {
        [_tableView reloadData];
    } else {
        [self showNoDataPromptView];
    }
}

- (void)clearDataArray
{
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    
    [self showNoDataPromptView];
}


- (void)removeDataAtIndex:(NSInteger)index
{
    [_dataArray removeObjectAtIndex:index];
}

- (void)removeDataAtIndexAndReload:(NSInteger)index
{
    [self removeDataAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]  withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)removeForData:(id)data
{
    [self removeDataAtIndex:[_dataArray indexOfObject:data]];
}

- (void) removeForDataAndReload:(id)data
{
    [self removeDataAtIndexAndReload:[_dataArray indexOfObject:data]];
}

- (void)disablePullRefresh
{
    [_tableView setFooterHidden:YES];
    [_tableView setHeaderHidden:YES];
}

- (void)endPullRefresh
{
    if (_tableView.isHeaderRefreshing)
    {
        [_tableView headerEndRefreshing];
    }
    
    if (_tableView.isFooterRefreshing)
    {
        [_tableView footerEndRefreshing];
    }
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  views action
///////////////////////////////////////////////////////////////////////////////
- (void)actionClickNavigationBarRightButton
{
    
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  UITableViewDelegate/UITableViewDataSource
///////////////////////////////////////////////////////////////////////////////
- (void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
    
}

- (void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return defult
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前Cell的class
    Class cellClass = [self cellClassForIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    
    if( !cell ) {
        if([cellClass isSubclassOfClass:[BetterTableCell class]]) {
           BetterTableCell *btCell = [cellClass cellFromXIB];
            btCell.viewController = self;
            cell = btCell;
            
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass(cellClass)];
        }
    }

    if ([self respondsToSelector:@selector(tableViewCell:configCellForIndexPath:)]) {
        [self tableViewCell:cell configCellForIndexPath:indexPath];
        
    } else {
        if(_dataArray.count) {
            if ([cell isKindOfClass:[BetterTableCell class]]) {
                BetterTableCell *baseCell = (BetterTableCell *)cell;
                [baseCell setCellData:_dataArray[indexPath.row]];
                [baseCell setCellIndex:indexPath.row];
            }
            
            [self tableViewCell:cell configCellForData:_dataArray[indexPath.row]];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
