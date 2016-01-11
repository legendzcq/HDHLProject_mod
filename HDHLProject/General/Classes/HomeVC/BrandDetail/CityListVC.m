//
//  CityListVC.m
//  Carte
//
//  Created by ligh on 15-1-31.
//
//

#import "CityListVC.h"
#import "CityListVC.h"
#import "CitySelectionView.h"
#import "CityCell.h"
#import "CityModel.h"
#import "CityListRequest.h"
#import "FrameLineView.h"

#define CityListCell_Height 45.0f
#define CityListSection_Height 25.0f


static NSString * updatingLocationString =@"updatingLocationFaild";
@interface CityListVC ()
{
    NSString *_userCity;
    NSMutableArray *_cityArray;
    NSString *_brandID;
    NSMutableDictionary *_cities;
}
@end
@implementation CityListVC

- (void)dealloc
{
    [[BMKLocationManager defaultInstance]stopUpdatingLocation];
    RELEASE_SAFELY(_cityArray);
    RELEASE_SAFELY(_userCity);
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(id)initWithBrandID:(NSString *)brandID
{
    if (self = [super init]) {
        if (brandID) {
            _brandID = brandID;
        }
    }
    return self;
}

- (void)configViewController
{
    [super configViewController];
    [self disablePullRefresh];
    self.tableView.sectionIndexBackgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0];
    self.tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];
    }
    [self setCityDatas];
    [self.tableView reloadData];
    [self startLocaiton];
}

- (void)setCityDatas
{
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    _cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    [_cityArray addObjectsFromArray:[[_cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
}

/**
 *  定位用户位置 解析出当前位置的城市名称
 */
-(void) startLocaiton
{
    [[BMKLocationManager defaultInstance]startUpdatingLocationWithUpdateBMKUserLocationBlock:^(BMKUserLocation *userLocation) {
        //将经纬度解析出城市信息
        [[BMKLocationManager defaultInstance] startGeoCodeSearchWithUserLocation:userLocation reverseGeoCodeBlock:^(NSDictionary *address) {
            
            _userCity = address[@"city"];
            [self.tableView reloadData];
        } reverseGeoCodeFailBlock:^(NSString *error) {
            _userCity = updatingLocationString;
        }];
    } errorBlock:^(NSError *error) {
        _userCity = updatingLocationString;
    }];
}



/////////////////////////////////////////////////////////////////////////
#pragma mark UITableViewDelegate
/////////////////////////////////////////////////////////////////////////


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cityArray.count +1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CitySelectionView *citySelectionView =  [CitySelectionView viewFromXIB];
    NSString *titleString ;
    if(section != 0){
     titleString = [_cityArray objectAtIndex:section-1];
    }
    [citySelectionView setCityTitle:section == 0 ?  @"当前定位城市" : titleString];
    return citySelectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CityListSection_Height;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titleArray = [NSMutableArray arrayWithArray:_cityArray];
    [titleArray insertObject:@"" atIndex:0];
    return titleArray;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CityListCell_Height;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    NSString *key = [_cityArray objectAtIndex:section-1];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *formatCityName = @"";
    
    if (indexPath.section == 0)
    {
        NSString *cityName = _userCity;
        
        if (cityName == nil)
        {
            [BDKNotifyHUD showCryingHUDInView:self.contentView text:@"定位中..."];
            return;
        }
        
    }else
    {
        NSString *key = [_cityArray objectAtIndex:indexPath.section-1];
        formatCityName  = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    }
    
    if ([self.cityDelegate respondsToSelector:@selector(citySelectedAction:)]) {
        [self.cityDelegate citySelectedAction:formatCityName];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CityCell";
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell =  [CityCell cellFromXIB];
        FrameLineView *lineView = [[FrameLineView alloc]initWithFrame:CGRectMake(0, cell.height-0.5, SCREEN_WIDTH, 0.5)];
        [cell addSubview:lineView];
    }
    cell.indexPath = indexPath ;
    if (indexPath.section == 0)
    {
        [cell setCellData:_userCity];
        
    }else
    {
        NSString *key = [_cityArray objectAtIndex:indexPath.section-1];
        NSString *cityString = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
        [cell setCellData:cityString];
    }
    return cell;
}

#pragma mark - ViewActions

- (void)actionClickNavigationBarLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
