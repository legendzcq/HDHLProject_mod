//
//  OrdersMenuView.m
//  Carte
//
//  Created by ligh on 14-7-23.
//
//

#import "OrdersMenuView.h"

@interface OrdersMenuView()<UITableViewDataSource,UITableViewDelegate,OrderMenuCartCellDelegate>
{
    IBOutlet UIView         *_alphaView;
    IBOutlet UIView         *_contentView;
    IBOutlet UITableView    *_tableView;
    NSMutableArray          *_goodsArray;
    IBOutlet UIView         *_topView;
    IBOutlet UIImageView    *_topImageView; 
    IBOutlet UILabel        *_clearLabel;
    IBOutlet UILabel        *_cartTextLabel;
}
@end

@implementation OrdersMenuView

- (void)dealloc
{
    RELEASE_SAFELY(_goodsArray);
    RELEASE_SAFELY(_alphaView);
    RELEASE_SAFELY(_contentView);
    RELEASE_SAFELY(_tableView);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setExtraCellLineHidden:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _topImageView.image = [UIImage resizableWithImage:_topImageView.image edgeInsets:UIEdgeInsetsMake(15, 50, 10, 10)];
    _cartTextLabel.textColor = ColorForHexKey(AppColor_OrderCart_ClearText);
    _clearLabel.textColor = ColorForHexKey(AppColor_OrderCart_ClearText);
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (IBAction)clearCartDataAction:(id)sender {
    [_goodsArray removeAllObjects];
    [_actionDelegate orderNumberChangedZero];
}

#pragma mark - OrderMenuCartCellDelegate

- (void)cartDelAction:(OrderMenuCartCell *)cell
{
    [_goodsArray removeObject:cell.cellData];
    _contentView.height = [self ordersMenuViewHeight];

    _tableView.height = _contentView.height-kOrdersMenuTopHeight;
    _tableView.top = kOrdersMenuTopHeight;
    _contentView.bottom = self.bottom;
    [_tableView reloadData];
    
    if (_actionDelegate) {
        GoodsModel *goodsModel = cell.cellData;
        if (goodsModel.selectedNumber == 0) {
            [_actionDelegate orderNumberChangedOne];
        }
        if (!_goodsArray.count) {
            [_actionDelegate orderNumberChangedZero];
        }
        [_actionDelegate orderNumberChanged:cell.cellData];
    }
}

- (void)cartOrderNumberChanged:(OrderMenuCartCell *)cell
{
    if (_actionDelegate) {
        [_actionDelegate orderNumberChanged:cell.cellData];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kOrdersMenuCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderMenuCartCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderMenuCell"];
    if (!cell) {
        cell = [OrderMenuCartCell cellFromXIB];
        cell.actionDelegate = self;
    }
    cell.seperateLineView.top = kOrdersMenuCellHeight-0.5;
    
    [cell setCellData:_goodsArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showWithHeight:(float)height goodsArray:(NSMutableArray *)goodsArray
{
    RELEASE_SAFELY(_goodsArray);
    _goodsArray = [NSMutableArray arrayWithArray:goodsArray];
    [_tableView reloadData];
    
    self.top = 0;
    self.height =  height;
    
    _contentView.height = [self ordersMenuViewHeight];
    _tableView.height = _contentView.height-kOrdersMenuTopHeight;
    _tableView.top = kOrdersMenuTopHeight;
    
    _contentView.top = self.height;
    _alphaView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        _alphaView.alpha = 0.4;
        _contentView.bottom = self.bottom;
        
    } completion:^(BOOL finished) {

    }];
}

- (void)refreshOrderMenuDishes:(NSArray *)array {
    if (_goodsArray.count) {
        [_goodsArray removeAllObjects];
    }
    _goodsArray = [NSMutableArray arrayWithArray:array];
    [_tableView reloadData];
}

- (CGFloat)ordersMenuViewHeight {
    CGFloat menuHeight = _goodsArray.count*kOrdersMenuCellHeight+kOrdersMenuTopHeight;
    if (menuHeight > kOrdersMenuHeight) {
        int maxCount = kOrdersMenuHeight/kOrdersMenuCellHeight;
        return maxCount * kOrdersMenuCellHeight+kOrdersMenuTopHeight;
    } else {
        return menuHeight;
    }
}

- (IBAction)handViewAction:(id)sender
{
    [self hidden];
}


- (void)hidden
{
    [_actionDelegate ordersMenuViewDidDismiss];
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.top = self.height;
        _alphaView.alpha = 0;
    } completion:^(BOOL finished) {
        self.height = 0;
        if (_actionDelegate) {
            [_actionDelegate ordersMenuViewHiddenFinish];
        }
    }];
}

- (CGFloat)contentHeight {
    return _tableView.height;
}

- (void)hiddenSomeQuestion {
    _contentView.height = 0;
    _alphaView.alpha = 0;
    self.height = 0;
}

@end
