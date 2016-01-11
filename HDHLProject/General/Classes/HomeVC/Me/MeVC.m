//
//  MeVC.m
//  Carte
//
//  Created by ligh on 14-3-24.
//
//

#import "MeVC.h"
#import "VouchersListVC.h"
#import "MoreVC.h"
#import "QPCodeVC.h"
#import "CallPhoneView.h"
#import "MyCollectionVC.h"
#import "MyRefundVC.h"
#import "MessageCenterVC.h"
#import "QRCodeAddBrand.h"
#import "NotLoginView.h"
//请求类
#import "MyDishCardsRequest.h"
#import "MeHOmeInfoRequest.h"
#import "UserDetailsRequest.h"
#import "ModifyNickNameRequest.h"
#import "UploadAvatarRequest.h"

#import "BrandModel.h"
#import "UserModel.h"

#define KActionSheetPhotoType 1
#define KActionSheetCallPhoneType 2
#define ActionImageViewWidth  32
#define ActionTitleFount 12
#define ActionViewWidth 80

typedef enum
{
    SupportActionNoShow = 0 ,//置灰
    SupportActionIsShow = 1 //显示
    
}ActionShow;

#define KSeatModuleActionTag 1 //订座模块action tag
#define KDishesModuleActionTag 2 //点菜模块action tag
#define KSendModuleActionTag 3 //外卖模块action tag
#define KGrouponModuleActionTag 4 //团购模块action tag

#define StoreTableViewFrame    CGRectMake(0, 138, self.contentView.size.width, self.contentView.frame.size.height-138)    //店铺列表的Frame
// 加的线
#define MyLineOne_Frame   CGRectMake(10,103, SCREEN_WIDTH - 20,0.5)
#define MyLineTwo_Frame   CGRectMake(SCREEN_WIDTH/2,111,0.5,20)
#define MyLineThree_Frame CGRectMake(214,111,0.5,20)

//tableView
#define MyTableView_RowHeight  69
//button
#define MyTableView_MyOrdersBtnWidth CGRectMake(0, 103, SCREEN_WIDTH/2, 34)
#define MyTableView_discountBtnWidth CGRectMake(SCREEN_WIDTH/2, 103, SCREEN_WIDTH/2, 34)

@interface MeVC () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,LogoutButtonClickDelegate>
{
    //功能支持份模块
    IBOutlet UIView *_personInfoView;
    //用户头像
    IBOutlet WebImageView   *_avatarImageView;
    //手机号
    IBOutlet UILabel        *_phoneNumberLabel;
    //更多功能
    IBOutlet UIScrollView *_functionInfoView;
    //优惠劵
    IBOutlet UIButton *_discountBtn;
    //退款
    IBOutlet UIButton *aRefundBtn;
    //消息
    IBOutlet UIButton *myNewsBtn;
    //收藏
    IBOutlet UIButton *myCollectionBtn;
    //扫一扫
    IBOutlet UIButton *scanBtn;
    //客服电话
    IBOutlet UIButton *serviceTelephone;
    //未登录按钮
    IBOutlet UIButton *notLoginBtn;
    IBOutlet UIView *personImageInfoView;
    IBOutlet UIView *myBackGroundView;
    IBOutlet UIImageView *messageAlertImageView;
    UserModel *_userModel;
    IBOutlet FrameViewWB *serviceTelBGView;
}
@end

@implementation MeVC


- (void)dealloc
{
    RELEASE_SAFELY(_avatarImageView);
    RELEASE_SAFELY(_phoneNumberLabel);
    RELEASE_SAFELY(_personInfoView);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_avatarImageView);
    RELEASE_SAFELY(_phoneNumberLabel);
    RELEASE_SAFELY(_personInfoView);

    [super viewDidUnload];
}


-(void)configViewController
{
    [super configViewController];
//    //个人设置信息改变通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUIfromNotificationCenter) name:kUserInfoChangedNotification object:nil];
//    //再次登录通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUIfromNotificationCenter) name:kLoginOnceMoreNotification object:nil];
    [self loadColorConfig];
    [self setViewAndDatas];
}

- (void)setViewAndDatas
{
    self.navigationBarView.hidden = YES;
    self.contentView.hidden = YES;
    self.navigationBarView.leftBarButton.hidden = YES;
    self.navigationBarView.rightBarButton.hidden = YES;
   
    float height = _functionInfoView.height;
    _functionInfoView.height = self.view.height - TAB_BAR_HEIGHT - _personInfoView.height;
    [_functionInfoView setContentSize:CGSizeMake(self.contentView.width, height)];
    
    [_avatarImageView.layer setCornerRadius:_avatarImageView.width/2.0];
}


-(void) loadColorConfig
{
    myBackGroundView.backgroundColor = UIColorFromRGB_BGColor;
    _personInfoView.backgroundColor = ColorForHexKey(AppColor_Money_Color_Text1);
    [_discountBtn setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    [aRefundBtn setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    [myNewsBtn setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    [myCollectionBtn setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];;
    [scanBtn setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    [serviceTelephone setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateNormal];
    _phoneNumberLabel.textColor = ColorForHexKey(AppColor_Default_Button_Text);
    [notLoginBtn setTitleColor:ColorForHexKey(AppColor_Money_Color_Text1) forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([AccountHelper isLogin])
    {
        notLoginBtn.hidden = YES;
        personImageInfoView.hidden = NO;
        if (_userModel.message_number.intValue >0) {
            messageAlertImageView.hidden = NO;
        }else{
            messageAlertImageView.hidden = YES;
        }
        [self sendReqeustOfUserDetails];
    }else{
        notLoginBtn.hidden = NO;
        personImageInfoView.hidden = YES;
        messageAlertImageView.hidden = YES;
        [self refreshUI];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

/**
 *  刷新ui
 */

-(void) refreshUI
{
    
    UserModel *userInfoModel = [AccountHelper userInfo];
    if (![NSString isBlankString:userInfoModel.phone]) {
        [serviceTelephone setTitle:[NSString stringWithFormat:@"客服 %@",userInfoModel.phone]forState:UIControlStateNormal];
    }
    [_avatarImageView setImageWithUrlString:userInfoModel.image_big placeholderImage:KNotLoginUserIconImage];
    if (![NSString isBlankString:userInfoModel.mobile]) {
        serviceTelBGView.hidden = NO;
        _phoneNumberLabel.text = userInfoModel.mobile;
    }else{
        serviceTelBGView.hidden = YES;
    }
    
}


#pragma mark ViewActions

-(void)actionClickNavigationBarRightButton
{
    MoreVC *moreVC = [[MoreVC alloc] init];
    [self pushFromRootViewControllerToViewController:moreVC animation:YES];
}


#pragma mark 点击事件


//我的优惠券
- (IBAction)voucherAction:(id)sender
{
    VouchersListVC *vouchersListVC = [[VouchersListVC alloc] init];
    [self pushFromRootViewControllerToViewController:vouchersListVC animation:YES];
}
//我的退款
- (IBAction)aRefundBtnAction:(id)sender {
    MyRefundVC *myRefundVC = [[MyRefundVC alloc]init];
    [self pushFromRootViewControllerToViewController:myRefundVC animation:YES];
}
//我的消息
- (IBAction)MynewsmyNewsBtnAction:(id)sender {
    messageAlertImageView.hidden = YES;
    MessageCenterVC *messageCenterVC = [[MessageCenterVC alloc]init];
    [self pushFromRootViewControllerToViewController:messageCenterVC animation:YES];
}
//我的收藏
- (IBAction)myCollectionBtnAction:(id)sender {
    MyCollectionVC *myCollectionVC = [[MyCollectionVC alloc]init];
    [self.navigationController pushViewController:myCollectionVC animated:YES];
}
//扫一扫
- (IBAction)scanBtnAction:(id)sender {
    QRCodeAddBrand *qrCodeAddBrandVC = [[QRCodeAddBrand alloc]init];
    [self pushFromRootViewControllerToViewController:qrCodeAddBrandVC animation:YES];
}
//客服电话
- (IBAction)serviceTelephoneAction:(id)sender {
    UserModel *userInfoModel = [AccountHelper userInfo];
    NSArray *mobileArray = [PhoneNumberHelper parseText:userInfoModel.phone];
    if (!(mobileArray && mobileArray.count))
    {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"无客服电话"];
        return ;
    }
    CallPhoneView *callView = [CallPhoneView viewFromXIB];
    [callView showInView:KAPP_WINDOW phoneNumArray:mobileArray];
}
//设置按钮
- (IBAction)personSettingBtnAction:(id)sender {
    MoreVC *moreVC = [[MoreVC alloc] init];
    moreVC.delegate = self;
    [self pushFromRootViewControllerToViewController:moreVC animation:YES];
}
//未登录注册按钮
- (IBAction)notLoginBtnAction:(id)sender {
    LoginVC *loginVC = [[LoginVC alloc]init];
    [self pushFromRootViewControllerToViewController:loginVC animation:YES];
}



//显示从相册和图库
- (IBAction)showAvatarPickerAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册上传", nil];
    [actionSheet showInView:self.contentView];
}   

#pragma mark LogoutDelegate

-(void)didLogoutAction
{
    [self refreshUI];
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.tag == KActionSheetCallPhoneType)
    {
        NSString *mobile = [actionSheet buttonTitleAtIndex:buttonIndex];
        [PhoneNumberHelper callPhoneWithText:mobile];
        
    }else
    {
        if (buttonIndex == 0)//拍照
        {
            [self startImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
            
        } else if(buttonIndex == 1)//从手机相册上传
        {
            [self startImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}


#pragma mark 限制用户名输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 20)
        return NO;
    return YES;
}
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _avatarImageView.image = [self scaleFromImage:image toSize:CGSizeMake(80, 80)];
    [self sendRequestForUploadAvatar];
    [[UIApplication sharedApplication] setStatusBarStyle:[AppColorHelper preferredStatusBarStyle]];

}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[UIApplication sharedApplication] setStatusBarStyle:[AppColorHelper preferredStatusBarStyle]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//启动相机或者图库
-(void) startImagePickerWithSourceType:(UIImagePickerControllerSourceType) soureType
{
  //  [KAPP_Delegate dismissTabBar];
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = soureType;
    imagePickerController.allowsEditing = YES;
    if([[UIDevice currentDevice] systemVersion].floatValue>=8.0){
       imagePickerController.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}


#pragma mark UITextFieldDelegate nickname

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"亲,昵称不能为空哦"];
        return NO;
    }
    
    textField.tag = 1;
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark request

//上传头像
-(void) sendRequestForUploadAvatar
{
    NSData *dataObj = UIImageJPEGRepresentation(_avatarImageView.image, 0.1);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:dataObj forKey:@"file"];
    
    [UploadAvatarRequest requestWithParameters:params withIndicatorView:self.contentView onRequestFinished:^(ITTBaseDataRequest *request)
    {
        if (request.isSuccess)
        {
            UserModel *user = [AccountHelper userInfo];
            user.image_big =  request.resultDic[@"data"][@"image_big"];
            user.image_small =  request.resultDic[@"data"][@"image_big"];
            [AccountHelper saveUserInfo:user];
            
            [_avatarImageView setImageWithUrlString:user.image_small    placeholderImage:KNotLoginUserIconImage];
            [BDKNotifyHUD showSmileyHUDInView:self.view text:@"已保存"];
        }else
        {
            [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败 请重试"];
            [_avatarImageView setImageWithUrlString:[AccountHelper userInfo].image_big placeholderImage:KNotLoginUserIconImage];
        }
    }onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [_avatarImageView setImageWithUrlString:[AccountHelper userInfo].image_big placeholderImage:KNotLoginUserIconImage];
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
    }];
}

#pragma mark - 请求类 -

//获取用户详情请求
-(void) sendReqeustOfUserDetails
{
    if (![AccountHelper isLogin]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [MeHOmeInfoRequest requestWithParameters:params withIndicatorView:nil  onRequestFinished:^(ITTBaseDataRequest *request)
    {
        if (request.isSuccess)
        {
             _userModel =  request.resultDic[KRequestResultDataKey];
            [AccountHelper saveUserInfo:_userModel];
            [self refreshUI];
        }else{
            if (request.resultDic)
            {
                [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
            }else {
                [BDKNotifyHUD showCryingHUDInView:self.view text:@"服务器加载失败"];
            }
        }
    } onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
    }];
}




@end
