
#import "UIView+Color.h"

@implementation UIView (Color)

/*随机设置自身及子视图的背景色*/
- (void)colorBackgrounds
{
    int max = 256;
    int r = arc4random() % max;
    int g = arc4random() % max;
    int b = arc4random() % max;
    self.backgroundColor = [UIColor colorWithRed:(float)r/max green:(float)g/max blue:(float)b/max alpha:1.0];
    
    if ([self isKindOfClass:[UILabel class]] || [self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UIButton class]] || [self isKindOfClass:[UIBarItem class]] || [self isKindOfClass:[UIImageView class]]) {
        return;
    } else {
        for (UIView *subview in self.subviews) {
            [subview colorBackgrounds];
        }
    }
}

@end
