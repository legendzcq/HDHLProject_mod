//
//  CityCell.m
//  Carte
//
//  Created by ligh on 14-3-26.
//
//

#import "CityCell.h"
#import "CityModel.h"
#import "DataCacheManager.h"

static NSString * updatingLocationString =@"updatingLocationFaild";

@interface CityCell()
{

    //城市名称label
    IBOutlet UILabel                    *_cityLabel;
    
    //一般用作定位当前城市信息时 提示用户等待
    IBOutlet UIActivityIndicatorView    *_loadingIndicator;
}
@end

@implementation CityCell

- (void)dealloc
{
    RELEASE_SAFELY(_cityLabel);
    RELEASE_SAFELY(_loadingIndicator);
    
}



-(void)awakeFromNib
{
    [super awakeFromNib];
    _cityLabel.textColor = ColorForHexKey(AppColor_Spinner_Text1);
}




-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    NSString *cityString = cellData;
    if (![cityString length])
    {
        _cityLabel.text = @"正在定位城市";
        _cityLabel.textColor=ColorForHexKey(AppColor_OrderList_NameText);
        _loadingIndicator.hidden = NO;
        [_loadingIndicator startAnimating];
    }else
    {
        _cityLabel.text = cityString==updatingLocationString?@"定位失败":cityString;
        if(self.indexPath.section ==0 && cityString!=updatingLocationString)
        {
        _cityLabel.textColor = HomeColorForHexKey(AppColor_Home_NavBg1);
        }else{
        _cityLabel.textColor=ColorForHexKey(AppColor_OrderList_NameText);
        }
        _loadingIndicator.hidden = YES;
        [_loadingIndicator stopAnimating];
    }
}

@end
