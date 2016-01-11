//
//  ActivitySingleView.h
//  Carte
//
//  Created by ligh on 15-1-13.
//
//

#import "XibView.h"
#import "ActivityModel.h"

@interface ActivitySingleView : XibView

@property (retain, nonatomic) IBOutlet UIButton *selButton;

- (void)setDataWithModel:(ActivityModel *)model;
- (void)hiddenSelImageView;

@end
