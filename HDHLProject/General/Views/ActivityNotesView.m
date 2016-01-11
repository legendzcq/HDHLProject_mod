//
//  ActivityNotesView.m
//  Carte
//
//  Created by ligh on 14-9-17.
//
//

#import "ActivityNotesView.h"

@interface ActivityNotesView()
{
    
    
    
    IBOutlet UILabel            *_titleLabel;
    IBOutlet UILabel            *_noteLabel;

    IBOutlet UIScrollView       *_contentView;
    
    IBOutlet UIControl          *_alphaControl;
    
    
    
}
@end

@implementation ActivityNotesView


- (void)dealloc
{
    RELEASE_SAFELY(_noteLabel);
    RELEASE_SAFELY(_contentView);
    RELEASE_SAFELY(_alphaControl);
    RELEASE_SAFELY(_titleLabel);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    _contentView.layer.masksToBounds = YES;
    _contentView.layer.cornerRadius = 5;
}

- (IBAction)touchAlphaView:(id)sender
{
    [self dismiss];
}

-(void)showInWindowWithActivityModel:(ActivityModel *)activityModel
{
    _titleLabel.text = activityModel.activity_title;
    [self showInWindowWithText:activityModel.activity_desc];
}

-(void)showInWindowWithText:(NSString *)text
{

    UIView *window =  KAPP_WINDOW;
    self.size = window.size;
    [window addSubview:self];
    
    _noteLabel.text = text;
    
    float  contentMaxHeight = window.height - 100 ;
    float contentHeight = [_noteLabel sizeThatFits:CGSizeMake(_noteLabel.width, contentMaxHeight)].height;
    _contentView.height = MAX(100,MIN(contentHeight + 70  , contentMaxHeight));
    [_contentView setContentSize:CGSizeMake(0, contentHeight + 60 )];
    _contentView.center = self.center;
    _noteLabel.height = contentHeight;
    
    _alphaControl.alpha = 0;
    [UIView beginAnimations:@"ShowAnimation" context:nil];
    _alphaControl.alpha = 0.5;
    [UIView commitAnimations];
    [_contentView.layer addAnimation:[self scaleAnimation:YES] forKey:nil];

}

-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Animation
- (CAKeyframeAnimation*)scaleAnimation:(BOOL)show{
    CAKeyframeAnimation *scaleAnimation = nil;
    scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.delegate = show ? nil : self;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    if (show){
        scaleAnimation.duration = 0.5;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else{
        scaleAnimation.duration = 0.3;
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 0.5)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0.2)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 0)]];
    }
    scaleAnimation.values = values;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = TRUE;
    return scaleAnimation;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self removeFromSuperview];
    
}

@end
