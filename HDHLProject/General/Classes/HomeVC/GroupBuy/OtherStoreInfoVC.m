//
//  OtherStoreInfoVC.m
//  Carte
//
//  Created by user on 14-4-14.
//
//

#import "OtherStoreInfoVC.h"
#import "OtherStoreInfoCell.h"

#import "GrouponMoreStoreRequest.h"
#import "BMKLocationManager.h"

@interface OtherStoreInfoVC ()
{

    NSString        *_grouponID;
    NSString        *_brandName;
    CLLocation      *_userLocation;//定位到的用户位置
}
@end

@implementation OtherStoreInfoVC

-(void)configViewController
{
    [super configViewController];
    
    [self setNavigationBarTitle:@"其他分店信息"];
    [self.tableView setRowHeight:80];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self sendRequestOfOtherStore];

}

-(id)initWithGrouponID:(NSString *)grouponID withBrandName:(NSString *) brandName
{
    if (self = [super init])
    {
        _grouponID = grouponID ;
        _brandName = brandName ;
    }
    
    return self;
}


#pragma mark VCDelegate
-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{
    [self sendRequestOfOtherStore];
}

-(Class)cellClassForIndexPath:(NSIndexPath *)indexPath
{
    return [OtherStoreInfoCell class];
}

- (void)tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath
{
    OtherStoreInfoCell *otherStoreInfoCell = (OtherStoreInfoCell *)cell;
    otherStoreInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    id model = self.dataArray[indexPath.row];
    if (![model isKindOfClass:[StoreModel class]]) {
        return;
    }
    StoreModel *storeModel = (StoreModel *)model;
    storeModel.brand_name = _brandName ;
    [otherStoreInfoCell setCellData:storeModel];
}

#pragma mark RequestDelegate

-(void) sendRequestOfOtherStore
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_grouponID forKey:@"groupon_id"];
    [params setObject:User_Id forKey:@"user_id"];
    [GrouponMoreStoreRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             [self setDataArray:request.resultDic[KRequestResultDataKey]];
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
         
        [self.tableView endRefreshing];

     } onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [self.tableView endRefreshing];
        [self showNetErrorPromptView];
    }];

}

@end
