//
//  RoundActionView.h
//  Carte
//
//  Created by zln on 14/12/19.
//
//

#import "XibView.h"

@interface RoundActionView : XibView

//功能按钮的图片
@property (retain, nonatomic) IBOutlet UIImageView *actionImageView;


//功能描述
@property (retain, nonatomic) IBOutlet UILabel *actionLabel;


//功能按钮
@property (retain, nonatomic) IBOutlet UIButton *roundActionButton;


@end
