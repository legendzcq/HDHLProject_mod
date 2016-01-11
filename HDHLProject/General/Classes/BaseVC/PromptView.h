//
//  PromptView.h
//  EKS
//
//  Created by ligh on 14/12/19.
//
//

#import "XibView.h"

//提示view 无数据时的友好提示
@interface PromptView : XibView

- (void)setPromptText:(NSString *)promptText;

@property (strong, nonatomic) IBOutlet UIButton *actionButton;

@end
