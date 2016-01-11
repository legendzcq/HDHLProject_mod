//
//  TakeorderNoticeView.h
//  Carte
//
//  Created by ligh on 14-5-5.
//
//

#import <UIKit/UIKit.h>

#import "SendRulesModel.h"

/**
 * 外卖须知view
 */
@interface TakeorderNoticeView : XibView

-(void) setSendRulesModel:(SendRulesModel *) ruluesModel;

@end
