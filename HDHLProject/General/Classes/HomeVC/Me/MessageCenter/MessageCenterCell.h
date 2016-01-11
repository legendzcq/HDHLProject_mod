//
//  MessageCenterCell.h
//  Carte
//
//  Created by zln on 14-9-9.
//
//

#import "BetterTableCell.h"
#import "MessageCenterModel.h"


@protocol MessageCheckDelegate <NSObject>

- (void)checkMessageCellWithModel:(MessageCenterModel *)messageModel WithIndexPath:(NSIndexPath *)indexPath;

@end

@interface MessageCenterCell : BetterTableCell
{
    IBOutlet UIImageView *_messBack;
}

@property (assign,nonatomic)id<MessageCheckDelegate>delegate;

@property (nonatomic,retain)MessageCenterModel *messageModel;
//发布消息时间
@property (retain, nonatomic) IBOutlet UILabel *mesTimeLabel;
//消息内容
@property (retain, nonatomic) IBOutlet UILabel *mesInfoLabel;
//消息状态图标
@property (retain, nonatomic) IBOutlet UIButton *msgStatusIconButton;
//店铺名称
@property (retain, nonatomic) IBOutlet UILabel *storeNameLabel;
//查看活动详情
- (IBAction)checkBtnClick:(UIButton *)sender;
//背景View
@property (nonatomic,retain)NSIndexPath *indexPath;
@property (nonatomic,assign)float *cellWidth;
@property (strong, nonatomic) IBOutlet UIView *messageBGView;

//计算cell显示model的高度
+(float) cellHeightForModel:(MessageCenterModel *) model cellWidth:(float) cellWidth;
- (void)setCellData:(id)cellData withCellWidth:(float)cellWidth;
@end
