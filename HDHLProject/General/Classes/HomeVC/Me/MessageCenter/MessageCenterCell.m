//
//  MessageCenterCell.m
//  Carte
//
//  Created by zln on 14-9-9.
//
//

#import "MessageCenterCell.h"
#import "PushNotificaitonModel.h"


#define CellContentWidth

@implementation MessageCenterCell



- (void) awakeFromNib
{
    [super awakeFromNib];
    [self disableSelectedBackgroundView];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self loadColorConfig];
}

- (void)loadColorConfig
{
    _mesTimeLabel.textColor = ColorForHexKey(AppColor_Second_Level_Title3) ;
    _storeNameLabel.textColor =ColorForHexKey(AppColor_Money_Color_Text1) ;
    _mesInfoLabel.textColor = ColorForHexKey(AppColor_Jump_Function_Text9);
    self.messageBGView.layer.borderColor = UIColorFromRGB(220,220,220).CGColor;
}

+(float)cellHeightForModel:(MessageCenterModel *)model cellWidth:(float)cellWidth
{
    UIFont *contentFont = [UIFont systemFontOfSize:13];
    return [model.content heightWithFont:contentFont boundingRectWithSize:CGSizeMake(cellWidth - MARGIN_L * 2 -20, MAXFLOAT)] +52;
}



- (void)setCellData:(id)cellData withCellWidth:(float)cellWidth
{
    if (![cellData isKindOfClass:[MessageCenterModel class]]) {
        return;
    }
    
    MessageCenterModel *messCenterModel = cellData;
    _mesInfoLabel.text = messCenterModel.content;
    _storeNameLabel.text = messCenterModel.store_name;
    self.messageModel = messCenterModel;
    _mesInfoLabel.height = [messCenterModel.content heightWithFont:_mesInfoLabel.font boundingRectWithSize:CGSizeMake(cellWidth - MARGIN_L * 2 -20, MAXFLOAT)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:messCenterModel.addtime.floatValue];
    _mesTimeLabel.text = [date stringWithFormat:@"yyyy/MM/dd HH:mm"];
    if (messCenterModel.status.intValue == 1)
    {
        _msgStatusIconButton.hidden = YES;

    }else
    {
        _msgStatusIconButton.hidden = NO;
    }
}

- (IBAction)checkBtnClick:(UIButton *)sender {
    if(self.delegate){
        [self.delegate checkMessageCellWithModel:self.messageModel WithIndexPath:self.indexPath];
    }
}
@end;