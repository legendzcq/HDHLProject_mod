//
//  SetGenderVc.m
//  Carte
//
//  Created by zln on 14/12/12.
//
//

#import "SetGenderVc.h"
#import "ModifyNickNameRequest.h"
#import "CommonHelper.h"

@interface SetGenderVc ()
{
    
    IBOutlet UIButton *_manCheckButton;
    
    IBOutlet UIButton *_womanCheckButton;
 
    
}

@end

@implementation SetGenderVc
//
- (void)dealloc {
    
    RELEASE_SAFELY(_manCheckButton);
    RELEASE_SAFELY(_womanCheckButton);
}
- (void)viewDidUnload {
    
    RELEASE_SAFELY(_manCheckButton);
    RELEASE_SAFELY(_womanCheckButton);
    RELEASE_SAFELY(_genderStr);

    [super viewDidUnload];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    _manCheckButton.hidden = YES;
//    _womanCheckButton.hidden = YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_genderStr.intValue == UserGenderIsMan)
    {
        _womanCheckButton.hidden = YES;
        
    } else if (_genderStr.intValue == UserGenderIsWoman)
    {
        _manCheckButton.hidden = YES;
    }
    
        
    [self.navigationBarView setNavigationBarTitle:@"性别"];

}

- (void)viewWillAppear:(BOOL)animated
{
    _womanCheckButton.hidden = YES ;
    _manCheckButton.hidden = YES ;
    if (_genderStr.intValue == UserGenderIsMan)
    {
        _manCheckButton.hidden = NO;
        
    } else if (_genderStr.intValue == UserGenderIsWoman)
    {
        _womanCheckButton.hidden =  NO;
    }
}

-(void)setChecked:(BOOL)checked
{
    _manCheckButton.hidden = !checked;
    _womanCheckButton.hidden = !checked;
}



//选择男性
- (IBAction)SelectManAction:(UIButton *)sender
{
    _manCheckButton.hidden = NO;
    _womanCheckButton.hidden = YES;
    [self sendRequestOfModifyUserGender:@"1"];

    
}

//选择女性
- (IBAction)SelectWomanAction:(UIButton *)sender
{
    _manCheckButton.hidden = YES;
    _womanCheckButton.hidden = NO;
    [self sendRequestOfModifyUserGender:@"2"];

}



//发送修改用户性别请求
-(void) sendRequestOfModifyUserGender:(NSString *)tag
{
 
    [ModifyNickNameRequest requestWithParameters:@{@"user_id":[AccountHelper uid] , @"gender":tag}
                               withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             [BDKNotifyHUD showSmileyHUDInView:self.view text:@"保存成功"];
        
             [self.navigationController popViewControllerAnimated:YES];
             
             
         }else
         {
             if (request.isNoLogin) {
                 return ;
             }
             [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败"];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败"];
     }];
}


@end
