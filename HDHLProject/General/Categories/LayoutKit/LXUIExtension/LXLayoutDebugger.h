
#import <UIKit/UIKit.h>

@interface LXLayoutDebugger : UIViewController

///测试布局
+ (void)debugLayout:(UIView *)debugView;

///延迟测试
+ (void)debugLayout:(UIView *)debugView afterDelay:(NSTimeInterval)delay;

///双击测试
+ (void)debugLayoutWhenDoubleTapped:(UIView *)debugView;

@end
