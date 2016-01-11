//
//  ActivityNotesView.h
//  Carte
//
//  Created by ligh on 14-9-17.
//
//

#import "XibView.h"
#import "ActivityModel.h"

//活动说明view 从底部谈起
@interface ActivityNotesView : XibView

-(void) showInWindowWithText:(NSString *) text;
-(void) showInWindowWithActivityModel:(ActivityModel *) activityModel;

-(void) dismiss;

@end
