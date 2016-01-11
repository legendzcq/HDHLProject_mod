//
//  BetterTabBarController.m
//  ZWProject
//
//  Created by ZGX on 15/5/23.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "BetterTabBarController.h"
//#import "UIViewController+PresentAnimation.h"

@interface BetterTabBarController ()

@end

@implementation BetterTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tabBar.hidden = YES;    
    self.customTabbarView = [[CustomTabBarView alloc] initWithSuperView:self.view];
    __weak __typeof(self)weakSelf = self;
    [self.customTabbarView setSelectedIndexChangedTo:^(kTabbarIndex index) {
        weakSelf.selectedIndex = index;
    }];
    self.customTabbarView.selectedIndex = kTabbarIndex0;
}

- (void)configTabBarWithViewControllerArray:(NSArray *)controllerNameArray {
    NSMutableArray *controllerArray = [NSMutableArray array];
    for (int i = 0; i < [controllerNameArray count]; i++) {
        NSString *controllerName = controllerNameArray[i];
        Class controllerClass = NSClassFromString(controllerName);
        UIViewController *controller = [[controllerClass alloc] initWithNibName:controllerName bundle:nil];
//        UINavigationController *naviController = [[UINavigationController alloc]initWithRootViewController:controller];
        [controllerArray addObject:controller];
    }
    self.viewControllers = controllerArray;
    self.selectedViewController = controllerArray[kTabbarIndex0]; //默认选中第一个
}

//显示指定视图
- (void)selectedViewControllerWithIndex:(NSInteger)index {
    self.customTabbarView.selectedIndex = index;
    self.selectedIndex = index;
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
