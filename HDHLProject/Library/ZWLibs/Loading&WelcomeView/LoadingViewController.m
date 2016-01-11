//
//  LoadingViewController.m
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "LoadingViewController.h"

#define kDelayTime 2          //启动页显示时间

@interface LoadingViewController () {
    BOOL         _isShow;        //是否显示了指定时间的启动页面
    UIView      *_bgView;
    CGFloat      _statusBarHeight; //状态栏高度
}
@end

static LoadingViewController *_currentLoadingVC = nil;

@implementation LoadingViewController

- (void)dealloc {
    RELEASE_SAFELY(_bgView);
    RELEASE_SAFELY(_currentLoadingVC);
}

+ (void)showLoadingView {
    if (_currentLoadingVC != nil) {
        return;
    }
    LoadingViewController *controller = [[LoadingViewController alloc] init];
    controller.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window addSubview:controller.view];
    _currentLoadingVC = controller;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
        _isShow = NO;
        //        self.imageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    //下载网络图片位置
    /*
     __weak WelcomeViewController *weakSelf = self;
     
     [OtherDataManager getImageWithType:ImageTypeWithWelcome userInfo:nil finish:^(NSDictionary *userInfo, id JSONValue) {
     weakSelf.imageArray.array = (NSArray *)JSONValue;
     [weakSelf performSelectorOnMainThread:@selector(addStartView) withObject:nil waitUntilDone:NO];
     } failure:^(NSDictionary *userInfo, NSString *error) {
     NSLog(@"error=:%@",error);
     [weakSelf removeTheWelView];
     }];
     */
    
    [self addLoadingView];
}

//状态栏显示 iOS6样式 YES : NO iOS7样式
- (BOOL)retureIOS7Before {
    _statusBarHeight = 20;
    return NO;
}

- (void)addLoadingView {
    _isShow = YES;
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    if (IOS_SDK_7_LATER && [self retureIOS7Before]) {
        _bgView.top = self.view.top + _statusBarHeight;
        _bgView.height = self.view.height - _statusBarHeight;
    }
    _bgView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self.view addSubview:_bgView];
    
    
    //logo
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_bgView.width-160)/2, 133, 160, 160)];
    logoImageView.image = [UIImage imageNamed:@"loading_logo"];
    [_bgView addSubview:logoImageView];
    //loading....
    CGFloat other = 0;
    if (IOS_VERSION_CODE <= 7) {
        other = 1;
    }
    UIImageView *_imageView = [[UIImageView alloc]initWithFrame:CGRectMake((_bgView.width-114)/2+other, 316, 114, 19)];
    [_bgView addSubview:_imageView];
    NSMutableArray *images = [[NSMutableArray alloc]initWithCapacity:4];
    for (int i = 1; i <= 4; i++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]]];
    }
    _imageView.animationImages = images;
    _imageView.animationDuration = 1;
    [_imageView startAnimating];
    //title
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake((_bgView.width-204)/2, _bgView.height-44, 204, 20)];
    titleImageView.image = [UIImage imageNamed:@"loading_title"];
    [_bgView addSubview:titleImageView];
    
    /*
     UIImageView *welImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
     if (_imageArray.count) {
     _isShow = YES;
     welImageView.image = [_imageArray firstObject];
     [self.view addSubview:welImageView];
     [self performSelector:@selector(removeTheWelView) withObject:nil afterDelay:3.0];
     }
     else{
     _isShow = NO;
     welImageView.image = [UIImage imageNamed:@"Default"];
     [self.view addSubview:welImageView];
     [self removeTheWelView];
     }
     */
    [self performSelector:@selector(removeLoadingView) withObject:nil afterDelay:kDelayTime];
}

- (void)removeLoadingView {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    /*
    if (_isShow) {
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.5f;
        //        animation.subtype = @"fromRight";//@"fromLeft";
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        //        animation.type = @"push";
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"animation"];
    }
    [self.view removeFromSuperview];
    _currentLoadingVC = nil;
    */
    if (_isShow) {
        [UIView animateWithDuration:0.3f animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            _currentLoadingVC = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoadingViewRemove object:nil];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [[UIApplication sharedApplication] setStatusBarStyle:kApp_StatusBarStyle];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
