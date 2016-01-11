//
//  SubStoreCell.m
//  Carte
//
//  Created by ligh on 14-4-11.
//
//

#import "SubStoreCell.h"

@interface SubStoreCell()
{
    
    IBOutlet UILabel *_storeNameLabel;//分店名称
    IBOutlet UIImageView *_locationImageView;//定位图标
    IBOutlet UILabel *_distanceLabel;//距离
    IBOutlet UILabel *_addressLabel;//地址

    IBOutlet UIView  *_distanceBgView;
    
}
@end

@implementation SubStoreCell

- (void)dealloc
{
//    RELEASE_SAFELY(_photoButton);
    RELEASE_SAFELY(_storeNameLabel);
    RELEASE_SAFELY(_distanceLabel);
    RELEASE_SAFELY(_addressLabel);
    
    RELEASE_SAFELY(_locationImageView);
    RELEASE_SAFELY(_distanceBgView);
    
    
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    [self loadColorConfig];
}

-(void) loadColorConfig
{
  
//    [_detailsButton setTitleColor:ColorForHexKey(AppColor_Label_Text) forState:UIControlStateNormal];
    _distanceLabel.textColor = ColorForHexKey(AppColor_Content_Text1);
    _addressLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
    
    //默认底部活动视图为隐藏
    
}

-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    
    StoreModel *storeModel = cellData;
    _storeNameLabel.text = storeModel.store_name;
    _distanceLabel.text  = storeModel.distance;
    _addressLabel.text   = storeModel.address;
    
    
    //调整店名和优惠图标的显示
    float storeNameWidth = [_storeNameLabel.text widthWithFont:_storeNameLabel.font boundingRectWithSize:CGSizeMake(MAXFLOAT, _storeNameLabel.height)];
    _storeNameLabel.width = storeNameWidth;
    
    
    //距离
    float distanceWidth = [_distanceLabel.text widthWithFont:_distanceLabel.font boundingRectWithSize:CGSizeMake(MAXFLOAT, _distanceLabel.height)];
    _distanceLabel.width = distanceWidth;
    _distanceBgView.width = _locationImageView.width + _distanceLabel.width;
    _distanceBgView.left = self.width - _distanceBgView.width - MARGIN_M;
    
    
}

+ (float)setRowHeightWithCellModel:(StoreModel *)model
{
//    if (model.activity_id.length) {
//        return 129;
//    }
    return 64;
}

@end
