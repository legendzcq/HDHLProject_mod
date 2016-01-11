//
//  WelcomeViewController.m
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "WelcomeViewController.h"
#import "AppDelegate.h"
#import "ZWPageControlView.h"
#import "LoadingViewController.h"

#define PAGE_VIEW_SELECTED_DOT   @"public_lead_circlesolid.png"
#define PAGE_VIEW_DOT            @"public_lead_circlehollow.png"

@interface WelcomeViewController () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    
    BOOL shouldRemove;
    UIView *_view1;
    UIView *_view2;
    UIView *_view3;
    UIView *_view4;
    UIView *_view5;
    NSArray *_viewArray;
    ZWPageControlView *_pageView;
    
    RemoveBlock _removeBlock;
}
@end

static WelcomeViewController *_currentwelcomeVC = nil;

@implementation WelcomeViewController

- (void)dealloc {
    RELEASE_SAFELY(_view1);
    RELEASE_SAFELY(_view2);
    RELEASE_SAFELY(_view3);
    RELEASE_SAFELY(_view4);
    RELEASE_SAFELY(_view5);
    RELEASE_SAFELY(_pageView);
    RELEASE_SAFELY(_removeBlock);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showWelcomeView:(WelcomeViewController *)welcomeVC finishBlock:(RemoveBlock)removeBlock {
    RELEASE_SAFELY(_removeBlock);
    _removeBlock = [removeBlock copy];
    
    if (_currentwelcomeVC != nil) {
        return;
    }
    welcomeVC.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [((AppDelegate *)([UIApplication sharedApplication].delegate)).window addSubview:welcomeVC.view];
    _currentwelcomeVC = welcomeVC;
}

- (id)init {
    self = [super init];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
        shouldRemove = NO;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    [self loadUIView1];
    [self loadUiView2];
    [self loadUiView3];
    [self loadUiView4];
    [self loadUiView5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self addPageControlView];
}

- (void)pageControlAction {
    NSInteger  page = _pageView.currentPage;
    [_scrollView setContentOffset:CGPointMake(self.view.width * page, 0)];
}

- (void)addPageControlView {
    if (!_pageView) {
        _pageView  = [[ZWPageControlView alloc] initWithPageNum:5 pageImageName:kWelcomePageViewImageName checkedPageImageName:kWelcomePageViewSelectedImageName pageSpace:kWelcomePageViewSpace];
    }
    _pageView.left = (self.view.width - _pageView.width) / 2;
    _pageView.bottom = self.view.height - kWelcomePageViewBottom;
    [self.view addSubview:_pageView];
}


//点菜
- (void)loadUIView1 {
    _view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _view1.width, _view1.height)];
    imageView.image  = [UIImage imageNamed:@"public_lead_background"];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, 100, 163,163)];
    imageView1.image  = [UIImage imageNamed:@"order_lead"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, imageView1.bottom+110, 197, 71)];
    imageView2.image  =[UIImage imageNamed:@"order_lead_word"];
    
    [_view1 addSubview:imageView];
    [_view1 addSubview:imageView1];
    [_view1 addSubview:imageView2];
    [_scrollView addSubview:_view1];
}

//订座
- (void)loadUiView2 {
    _view2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _view2.width, _view2.height)];
    imageView.image  = [UIImage imageNamed:@"public_lead_background"];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, 100, 163,163)];
    imageView1.image  = [UIImage imageNamed:@"book_lead"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, imageView1.bottom+110, 197, 71)];
    imageView2.image  =[UIImage imageNamed:@"book_lead_word"];
    
    [_view2 addSubview:imageView];
    [_view2 addSubview:imageView1];
    [_view2 addSubview:imageView2];
    [_scrollView addSubview:_view2];
}

//外卖
- (void)loadUiView3 {
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _view3.width, _view3.height)];
    imageView.image  = [UIImage imageNamed:@"public_lead_background"];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, 100, 163,163)];
    imageView1.image  = [UIImage imageNamed:@"take_out_lead"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, imageView1.bottom+110, 197, 71)];
    imageView2.image  =[UIImage imageNamed:@"take_out_lead_word"];
    
    [_view3 addSubview:imageView];
    [_view3 addSubview:imageView1];
    [_view3 addSubview:imageView2];
    [_scrollView addSubview:_view3];
}

//超级促销
- (void)loadUiView4 {
    _view4 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*3, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _view4.width, _view4.height)];
    imageView.image  = [UIImage imageNamed:@"public_lead_background"];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, 100, 163,163)];
    imageView1.image  = [UIImage imageNamed:@"promotion_lead"];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4, imageView1.bottom+110, 197, 71)];
    imageView2.image  =[UIImage imageNamed:@"promotion_lead_word"];
    
    [_view4 addSubview:imageView];
    [_view4 addSubview:imageView1];
    [_view4 addSubview:imageView2];
    [_scrollView addSubview:_view4];
}

//点餐
- (void)loadUiView5 {
    _view5 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*4, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _view5.width, _view5.height)];
    imageView.image  = [UIImage imageNamed:@"public_lead_background"];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4-10, 83, 176,61)];
    imageView1.image  = [UIImage imageNamed:@"public_lead_word1"];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width/4-10, imageView1.top + imageView1.height+MARGIN_L*2, 177, 61)];
    imageView2.image  =[UIImage imageNamed:@"public_lead_word2"];
    
    UIButton *orderButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/4+20, imageView2.bottom+85, 128, 128)];
    [orderButton setTitle:@"开餐" forState:UIControlStateNormal];
    orderButton.titleLabel.font = [UIFont systemFontOfSize:25];
    [orderButton addTarget:self action:@selector(welcomeViewFinishAction:) forControlEvents:UIControlEventTouchUpInside];
    [orderButton setBackgroundImage:[UIImage imageNamed:@"public_lead_button_normal"] forState:UIControlStateNormal];
    
    [_view5 addSubview:imageView];
    [_view5 addSubview:imageView1];
    [_view5 addSubview:imageView2];
    [_view5 addSubview:orderButton];
    [_scrollView addSubview:_view5];
}


#pragma mark - 
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    int page = _scrollView.contentOffset.x / self.view.width;
    _pageView.currentPage = page;
    
    if (_scrollView.contentOffset.x > _scrollView.contentSize.width - self.view.frame.size.width + 8) {
        shouldRemove = YES;
    }
}

//_scrollView.bounces = YES 才会调用该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (shouldRemove) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateWithDuration:0.5f animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            _currentwelcomeVC = nil;
        }];
    }
}

- (void)welcomeViewFinishAction:(UIButton *)button {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (_removeBlock) {
        _removeBlock(YES);
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        _currentwelcomeVC = nil;
    }];
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
