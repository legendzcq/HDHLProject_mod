//
//  PromptView.m
//  EKS
//
//  Created by ligh on 14/12/19.
//
//

#import "PromptView.h"

@interface PromptView()
{
    //提示view
    IBOutlet UILabel *_promptLabel;
    IBOutlet UIView  *_promptShowView;
}
@end

@implementation PromptView

- (void)dealloc
{
    RELEASE_SAFELY(_promptLabel);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _promptShowView.center = self.center;
}

- (void)setPromptText:(NSString *)promptText
{
    _promptLabel.text = promptText;
}

@end
