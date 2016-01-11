#import <UIKit/UIKit.h>
#import "BDKNotifyHUDBGView.h"

#define kBDKNotifyHUDDefaultMaxWidth 260.0f

#define kBDKNotifyHUDDefaultWidth  260.0f

#define kBDKNotifyHUDDefaultHeight 120.0f


@interface BDKNotifyHUD : UIView

@property (nonatomic) CGFloat destinationOpacity;
@property (nonatomic) CGFloat currentOpacity;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) CGFloat roundness;
@property (nonatomic) BOOL bordered;
@property (nonatomic) BOOL isAnimating;

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) NSString *text;

+ (id)notifyHUDWithImage:(UIImage *)image text:(NSString *)text;
+ (void)showHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text;
+ (void)showHUDInView:(UIView *)inView image:(UIImage *)image text:(NSString *)text completion:(void (^)(void))completion;

+ (void)showSmileyHUDInView:(UIView *)inView text:(NSString *)text;
+ (void)showSmileyHUDInView:(UIView *)inView text:(NSString *)text completion:(void (^)(void))completion;

+ (void)showCryingHUDInView:(UIView *)inView text:(NSString *)text;
+ (void)showCryingHUDInView:(UIView *)inView text:(NSString *)text completion:(void (^)(void))completion;

+ (void)showCryingHUDWithText:(NSString *)text;
+ (void)showCryingHUDWithText:(NSString *)text completion:(void (^)(void))completion;
+ (void) showCryingHUDWithText:(NSString *)text duration:(CGFloat)duration completion:(void (^)(void))completion;

+ (void)showSmileyHUDWithText:(NSString *)text;
+ (void)showSmileyHUDWithText:(NSString *)text completion:(void (^)(void))completion;

+ (void)showVexedlyHUDWithText:(NSString *)text;

- (id)initWithImage:(UIImage *)image text:(NSString *)text;

- (void)presentWithDuration:(CGFloat)duration speed:(CGFloat)speed inView:(UIView *)view completion:(void (^)(void))completion;

@end
