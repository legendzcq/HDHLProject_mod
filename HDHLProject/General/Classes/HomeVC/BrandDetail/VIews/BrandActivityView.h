//
//  BrandActivityView.h
//  Carte
//
//  Created by hdcai on 15/4/20.
//
//

#import "XibView.h"

//改变父frame
@protocol BrandActivityDelegate <NSObject>

- (void)changeBrandActivitySuperViewFrameWithFloat:(CGFloat ) floatHight;
@end
@interface BrandActivityView : XibView<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic,assign) id <BrandActivityDelegate>delegate;

@property (nonatomic,retain)UITableView *mTableView;

+ (void)showInView:(UIView *)fatherView WithModelArray:(NSArray *)array WithDelegate:(UIViewController *)viewController;


@end
