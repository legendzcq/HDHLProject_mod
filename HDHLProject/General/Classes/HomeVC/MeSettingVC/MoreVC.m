//
//  MoreVC.m
//  Carte
//
//  Created by ligh on 14-4-10.
//
//

#import "MoreVC.h"
#import "FeedBackVC.h"
#import "AboutUsVC.h"
#import "UserModel.h"
#import "LoginVC.h"
#import "PersonalSettingVC.h"
#import "CallPhoneView.h"
#import "ResetPasswordVC.h"

#define KActionSheetCallPhoneType 2


@interface MoreVC ()<UIActionSheetDelegate>
{
    IBOutlet UIButton *_feedbackTitleButton;//意见反馈
    IBOutlet UIButton *_appstoreTitleButton;//去appstore
    IBOutlet UIButton *_aboutTitleButton;//关于
    IBOutlet UIButton *_layOutButton;
    IBOutlet UIView *_meSettingBGView;
    IBOutlet UIView *_feedbackBGView;
    IBOutlet UIView *_changePasswordBGView;
    IBOutlet UIView *_aboutUsBGView;
    IBOutlet FrameViewWB *_logoutBGView;
    
    IBOutlet FrameViewWB *_functionBGView;
}
@end

@implementation MoreVC


- (void)dealloc
{
    RELEASE_SAFELY(_feedbackTitleButton );
    RELEASE_SAFELY(_appstoreTitleButton );
    RELEASE_SAFELY(_aboutTitleButton );
    RELEASE_SAFELY(_layOutButton);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_feedbackTitleButton );
    RELEASE_SAFELY(_appstoreTitleButton );
    RELEASE_SAFELY(_aboutTitleButton );
    RELEASE_SAFELY(_layOutButton);

    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)configViewController
{
    [super configViewController];
    [self setNavigationBarTitle:@"设置"];
    //重设UI
    if (![AccountHelper isLogin]) {
        _meSettingBGView.hidden = YES;
        _changePasswordBGView.hidden = YES;
        _logoutBGView.hidden = YES;
        _feedbackBGView.top = 0;
        _aboutUsBGView.top = _feedbackBGView.bottom;
        _functionBGView.height = _feedbackBGView.height +_aboutUsBGView.height;
    }
    
    [self loadColorConfig];
}


#pragma mark View Actions

-(void) loadColorConfig
{
    [_feedbackTitleButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text4) forState:UIControlStateNormal];
    [_appstoreTitleButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text4) forState:UIControlStateNormal];
    [_feedbackTitleButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text4) forState:UIControlStateNormal];
    [_aboutTitleButton setTitleColor:ColorForHexKey(AppColor_Defaule_Hollow_Button_Text4) forState:UIControlStateNormal];
}

//意见反馈
- (IBAction)GoToFeedBackAction:(UIButton *)sender
{
//    if ([AccountHelper isLogin]) {
        FeedBackVC* feedBackVC = [[FeedBackVC alloc]init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        
//    } else {
//        [[AccountStatusObserverManager shareManager] addObserverBlock:^(AcconutStatusType statusType) {
//            
//            FeedBackVC* feedBackVC = [[FeedBackVC alloc]init];
//            [self pushViewController:feedBackVC];
//        }];
//        
//        LoginVC *loginVC = [[LoginVC alloc] init];
//        [self.navigationController pushViewController:loginVC animated:NO];
//    }
}


//修改密码
- (IBAction)ResetPasswordAction:(UIButton *)sender
{
    UserModel *userInfoModel = [AccountHelper userInfo];
    ResetPasswordVC *reset = [[ResetPasswordVC alloc]initWithRetrievePasswordPhoneNumber:userInfoModel.mobile withResetPasswordWithType:ResetPasswordWithSettingType];
    [self.navigationController pushViewController:reset animated:YES];
}

//关于
- (IBAction)AboutUsAction:(UIButton *)sender
{
    AboutUsVC* aboutUsVC = [[AboutUsVC alloc]init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

//个人设置
- (IBAction)PersonSetAction:(UIButton *)sender
{
    PersonalSettingVC *personSet = [[PersonalSettingVC alloc] init];
    [self.navigationController pushViewController:personSet animated:YES];
}

//退出登录
- (IBAction)LayOutAction:(UIButton *)sender
{
    [[MessageAlertView viewFromXIB] showAlertViewInView:self.view msg:@"你是否确定要退出？" cancelTitle:@"取消" confirmTitle:@"确定" onCanleBlock:nil onConfirmBlock:^{
        
        [self logoutRequestAction];
    }];
}

- (void)logoutRequestAction
{
    [AccountHelper logout];
    [BDKNotifyHUD showSmileyHUDWithText:@"已注销" completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:nil];
        if ([_delegate respondsToSelector:@selector(didLogoutAction)]) {
            [_delegate didLogoutAction];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end

