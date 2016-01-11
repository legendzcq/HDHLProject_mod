//
//  PersonalSettingVC.m
//  Carte
//
//  Created by zln on 14/12/15.
//
//

#import "PersonalSettingVC.h"
#import "SetNameVC.h"
#import "SetGenderVc.h"
#import "UploadAvatarRequest.h"
#import "UserDetailsRequest.h"
#import "SetPersonBirthVC.h"
#import "AddressCell.h"

#import "TakeoutAddresListRequest.h"
#import "DelAddressRequest.h"
#import "SettingDefaultAddressRequest.h"
#import "CommonHelper.h"
#import "AddAddressView.h"
#import "AddressPopUpBoxView.h"
#import "EditAddressRequest.h"
#import "FrameViewWB.h"
#import "AddressPopUpBoxView.h"
#import "LoginVC.h"

#define SetTabelCellHeight 108

@interface PersonalSettingVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    IBOutlet UIScrollView *_scrollView;
    //性别btn
    IBOutlet UIButton *_genderButton;
    //名字btn
    IBOutlet UIButton *_nameButton;
    //生日btn
    IBOutlet UIButton *_birthDayButton;
    //头像
    IBOutlet WebImageView *_avatarImageView;
    //账号
    IBOutlet UILabel *_accountLabel;
    //账号NUM
    IBOutlet UILabel *_accountNumLabel;
    //个人信息
    IBOutlet FrameView *_personInfoView;
    //姓名label
    IBOutlet UILabel *_nameLabel;
    //生日label
    IBOutlet UILabel *_birthDayLabel;
    //性别label
    IBOutlet UILabel *_genderLabel;
}

@end


@implementation PersonalSettingVC

- (void)dealloc {
    
    RELEASE_SAFELY(_avatarImageView);
    RELEASE_SAFELY(_personInfoView);
    RELEASE_SAFELY(_scrollView);
    
}
- (void)viewDidUnload {
    
    RELEASE_SAFELY(_avatarImageView);
    RELEASE_SAFELY(_personInfoView);
    RELEASE_SAFELY(_scrollView);
    
    [super viewDidUnload];
}

-(void)showPromptViewWithPromptText:(NSString *)text
{
    [self promptView].hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self sendReqeustOfUserDetails];
}

- (void)configViewController
{
    [super configViewController];
    [self loadColorView];
    
    [self setNavigationBarTitle:@"个人信息"];
    
    //头像名字信息
    [_avatarImageView.layer setCornerRadius:_avatarImageView.height/2];
    _avatarImageView.layer.masksToBounds = YES;
    [self refreshUserInfoUI];

    [self sendReqeustOfUserDetails];
}

- (void)loadColorView
{
    _accountLabel.textColor = ColorForHexKey(AppColor_Share_Button_Text);
    _accountNumLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
    [_nameButton setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    [_birthDayButton setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    [_genderButton setTitleColor:ColorForHexKey(AppColor_Share_Button_Text) forState:UIControlStateNormal];
    _nameLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
    _birthDayLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
    _genderLabel.textColor = ColorForHexKey(AppColor_Content_Text2);
}

//刷新个人信息视图
- (void)refreshUserInfoUI
{
    UserModel *userInfoModel = [AccountHelper userInfo];
    
    _accountNumLabel.text = userInfoModel.mobile;
    [_avatarImageView setImageWithUrlString:userInfoModel.image_big placeholderImage:KNotLoginUserIconImage];
    
    [_nameLabel setText:userInfoModel.username];
    
    if (userInfoModel.gender.intValue == UserGenderIsMan)
    {
        _genderLabel.text = @"先生";
        
    } else if (userInfoModel.gender.intValue == UserGenderIsWoman)
   {
       _genderLabel.text = @"女士";

       
    }else{
        _genderLabel.text = @"未知";

    }
    
    _birthDayLabel.text = userInfoModel.birthday;

}

#pragma ViewActions
-(void)actionClickNavigationBarLeftButton
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super actionClickNavigationBarLeftButton];
}


//获取用户详情请求
-(void) sendReqeustOfUserDetails
{
    
    if (![AccountHelper isLogin])
    {
        [AccountHelper logout];
        
        [BDKNotifyHUD showCryingHUDWithText:@"账户异常,请重新登录" completion:^{
            LoginVC *loginVC = [[LoginVC alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
        return;
    }
    
    [UserDetailsRequest requestWithParameters:@{@"user_id": [AccountHelper uid]} withIndicatorView:nil  onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             NSDictionary *data = request.resultDic[@"data"];
             
             UserModel *user = [AccountHelper userInfo];
             user.birthday = [NSString isBlankString:data[@"birthday"]] ? user.birthday : data[@"birthday"];
             NSString *gen = data[@"gender"];
             user.gender = [NSString isBlankString:data[@"gender"]] ? user.gender : gen;
             user.image_big = [NSString isBlankString:data[@"image_big"]] ? user.image_big : data[@"image_big"];
             user.image_small = [NSString isBlankString:data[@"image_small"]] ? user.image_small : data[@"image_small"];
             user.user_id = [NSString isBlankString:data[@"user_id"]] ? user.user_id : data[@"user_id"];
             user.username = [NSString isBlankString:data[@"username"]] ? user.username : data[@"username"];
             user.mobile = [NSString isBlankString:data[@"mobile"]] ? user.mobile : data[@"mobile"];
             
             [AccountHelper saveUserInfo:user];
             
             [self refreshUserInfoUI];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         
     }];
}

#pragma mark=========用户信息============


//修改用户名
- (IBAction)PersonNameAction:(id)sender {
    
    SetNameVC *nameVC = [[SetNameVC alloc]init];
    [self.navigationController pushViewController:nameVC animated:YES];
    nameVC.nameTextField.text = _nameLabel.text;
    
}
//修改用户的生日
- (IBAction)PersonBirthAction:(id)sender
{
    SetPersonBirthVC *bitrhVC = [[SetPersonBirthVC alloc] init];
    [self.navigationController pushViewController:bitrhVC animated:YES];
}

//修改用户性别

- (IBAction)PersonGenderAction:(id)sender
{
    UserModel *userInfoModel = [AccountHelper userInfo];

    SetGenderVc *genderVC = [[SetGenderVc alloc] init];
    NSNumberFormatter *genderFormatter = [[NSNumberFormatter alloc] init];
    [genderFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    genderVC.genderStr = [genderFormatter numberFromString:userInfoModel.gender];
    [self.navigationController pushViewController:genderVC animated:YES];
}

//显示从相册和图库
- (IBAction)showAvatarPickerAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册上传", nil];
    
    [actionSheet showInView:self.view];
    
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)//拍照
    {
        
        [self startImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
    } else if(buttonIndex == 1)//从手机相册上传
    {
        [self startImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = soureType;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
    
}

//上传头像
-(void) sendRequestForUploadAvatar
{
    
    NSData *dataObj = UIImageJPEGRepresentation(_avatarImageView.image, 0.1);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:dataObj forKey:@"file"];
    
    [UploadAvatarRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             UserModel *user = [AccountHelper userInfo];
             user.image_big =  request.resultDic[@"data"][@"image_big"];
             user.image_small =  request.resultDic[@"data"][@"image_big"];
             [AccountHelper saveUserInfo:user];
             
             [_avatarImageView setImageWithUrlString:user.image_big placeholderImage:KNotLoginUserIconImage];
             [BDKNotifyHUD showSmileyHUDInView:self.view text:@"已保存"];
             [[NSNotificationCenter defaultCenter] postNotificationName:kUserInfoChangedNotification object:nil];
         }else
         {
             if (request.isNoLogin) {
                 return ;
             }
             [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败 请重试"];
             [_avatarImageView setImageWithUrlString:[AccountHelper userInfo].image_big placeholderImage:KNotLoginUserIconImage];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [_avatarImageView setImageWithUrlString:[AccountHelper userInfo].image_big placeholderImage:KNotLoginUserIconImage];
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败 请重试"];
     }];
}




@end
