
//
//  NewAddressVC.m
//  Carte
//
//  Created by ligh on 14-4-4.
//
//
#import <MapKit/MapKit.h>

#import "EditAddressVC.h"
#import "FrameView.h"
#import "BMKLocationManager.h"

#import "EditAddressRequest.h"

@interface EditAddressVC () <UITextViewDelegate>
{

    IBOutlet FrameView      *_frameView;
    
    IBOutlet UITextField    *_nameTextField;//用户姓名
    IBOutlet UITextField    *_phoneNumberTextField;//用户手机号码
    IBOutlet UITextField    *_userCityTextField;//用户所在城市
    IBOutlet UITextView     *_sendAddressTextField;//送餐地址
    IBOutlet UILabel        *_sendAdressPlaceHolderLabel;//送餐地址占位文字
 
    IBOutlet UIActivityIndicatorView *_positionActivityView;//定位当前城市指示器view
    
    IBOutlet UIButton *_clearPositionInfoButton;
    
    TakeoutAddressModel     *_addressModel;

}
@end

@implementation EditAddressVC


- (void)dealloc
{

    //views
    RELEASE_SAFELY(_frameView);
    RELEASE_SAFELY(_nameTextField);
    RELEASE_SAFELY(_phoneNumberTextField);
    RELEASE_SAFELY(_userCityTextField);
    RELEASE_SAFELY(_sendAddressTextField);
    RELEASE_SAFELY(_sendAdressPlaceHolderLabel);
    RELEASE_SAFELY(_positionActivityView);
    
    //models
    RELEASE_SAFELY(_addressModel);
    RELEASE_SAFELY(_clearPositionInfoButton);
    [EditAddressRequest cancelUseDefaultSubjectRequest];
}


-(id)initWithAddressModel:(TakeoutAddressModel *)addressModel
{
    if (self = [super init])
    {
        _addressModel = [[TakeoutAddressModel alloc] init];
        _addressModel = addressModel;
    }
    
    return self;
}


- (void)viewDidUnload
{
    [EditAddressRequest cancelUseDefaultSubjectRequest];
    
    RELEASE_SAFELY(_frameView);
    RELEASE_SAFELY(_nameTextField);
    RELEASE_SAFELY(_phoneNumberTextField);
    RELEASE_SAFELY(_userCityTextField);
    RELEASE_SAFELY(_sendAddressTextField);
    RELEASE_SAFELY(_sendAdressPlaceHolderLabel);    
    RELEASE_SAFELY(_positionActivityView);
    RELEASE_SAFELY(_clearPositionInfoButton);
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setRightNavigationBarButtonStyle:UIButtonStyleSave];
    self.navigationBarView.rightBarButton.hidden = NO;
    
    
    if (!_addressModel.city)
    {
        _positionActivityView.hidden = NO;
        [_positionActivityView startAnimating];
        [self startLocaiton];
    }else
    {
        _positionActivityView.hidden = YES;
        [_positionActivityView stopAnimating];
    }

    [self setNavigationBarTitle: _addressModel ? @"编辑地址" : @"新建地址"];
    [self refreshUI];
}




-(void) refreshUI
{
    if (!_addressModel)
    {
        return;
    }
    
    _nameTextField.text = _addressModel.username;
    _phoneNumberTextField.text = _addressModel.mobile;
    _userCityTextField.text = _addressModel.city;
    _sendAddressTextField.text = _addressModel.address;
    _sendAdressPlaceHolderLabel.hidden = _addressModel.address !=nil && _addressModel.address.length > 0;
}


/**
 *  定位用户位置 解析出当前位置的城市名称
 */
-(void) startLocaiton
{
    _positionActivityView.hidden = NO;
    [_positionActivityView startAnimating];
    
    /*
    [[LocationManager defaultInstance] startUpdatingLocationWithUpdateToLocationBlock:^(CLLocation *newLocation, CLLocation *oldLocation)
     {
         //将经纬度解析出城市信息
         CLGeocoder* geocoder = [[CLGeocoder alloc] init];
         [geocoder reverseGeocodeLocation:newLocation completionHandler:
          
          ^(NSArray* placemarks, NSError* error){
              
              if(!error && placemarks.count)
              {
                  MKPlacemark *place = placemarks[0];
                  _userCityTextField.text = place.addressDictionary[@"State"];
                  [_positionActivityView stopAnimating];
                  _positionActivityView.hidden = YES;
              }
              
          }];
         
         
     } errorBlock:^(NSError *error) {
         
     }];
     */
    
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIView Actions
/////////////////////////////////////////////////////////////////////////
-(void)actionClickNavigationBarLeftButton
{
    [EditAddressRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

-(void)actionClickNavigationBarRightButton
{
    [self sendRequestOfEditAddress];
}

//情况TextField
- (IBAction)clearTextFieldTextAction:(UIView *)sender
{
    if (sender.tag == 0)
    {
        [_nameTextField setText:nil];
        
    }else if(sender.tag == 1)
    {
        [_phoneNumberTextField setText:nil];
        
    }else if(sender.tag == 2)
    {
        [_userCityTextField setText:nil];
        
    }else if(sender.tag == 3)
    {
        [_sendAddressTextField setText:nil];
        [self textView:_sendAddressTextField shouldChangeTextInRange:NSMakeRange(0, 0)  replacementText:nil];
        _sendAdressPlaceHolderLabel.hidden = NO;
    }
}



/////////////////////////////////////////////////////////////////////////
#pragma mark UITextViewDelegate
/////////////////////////////////////////////////////////////////////////
-(void)textViewDidBeginEditing:(UITextView *)textView
{

    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidBeginEditingNotification object:textView];

}


#pragma mark 限制用户名输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 20)
        return NO;
    
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    _clearPositionInfoButton.hidden =  [NSString isBlankString:textView.text];
}

-(void)textViewDidChange:(UITextView *)textView
{
    _clearPositionInfoButton.hidden =  textView.text.length <= 0;
    _sendAdressPlaceHolderLabel.hidden = textView.text.length > 0;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    //禁止换行
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    NSString *textString = textView.text;
    CGSize textSize = [textString sizeWithFont:textView.font boundingRectWithSize:CGSizeMake(textView.width, MAXFLOAT)];
    
    [UIView beginAnimations:@"" context:nil];
    
    if (textSize.height > textView.font.lineHeight) //换好了
    {
        _frameView.height = 208;
    }else
    {
        _frameView.height = 182;
    }
    
    [UIView commitAnimations];
    
    return YES;
    
}


/***
 验证手机号码
 **/
-(BOOL) validateInputData
{
    if (_nameTextField.text.length == 0)
    {
         [BDKNotifyHUD showCryingHUDWithText:@"请输入您的姓名"];
        return NO;
    }
    
    if (_phoneNumberTextField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"请填写您的手机号"];
        return NO;
    }
    
    if (![PhoneNumberHelper validateMobile:_phoneNumberTextField.text])
    {
        [BDKNotifyHUD showCryingHUDWithText:@"手机号格式不正确"];
        return NO;
    }
    
    if (_sendAddressTextField.text.length == 0)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"请填写送餐地址"];
        return NO;
    }
    
    return YES;
}

#pragma mark Request
-(void) sendRequestOfEditAddress
{
    [self endEditing];
    
    
    if (![self validateInputData])
    {
        return;
    }
    
    
   NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObjectsAndKeys:[AccountHelper uid],@"user_id",_nameTextField.text,@"username",_phoneNumberTextField.text,@"mobile",_userCityTextField.text, @"city",_sendAddressTextField.text,@"address", nil];
    
    if (_addressModel)
    {
        [parms setObject:_addressModel.a_id forKey:@"a_id"];
    }
    
    [EditAddressRequest requestWithParameters:parms withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
    {
        if (request.isSuccess)
        {
            
            if (request.resultDic[@"data"])
            {
                TakeoutAddressModel *addressModel = [[TakeoutAddressModel alloc] initWithDictionary:request.resultDic[@"data"]];
                NSArray *cacheAddressArray = (NSArray *)[[DataCacheManager sharedManager] getCachedObjectByKey:KAddressListCacheKey];
                if (!cacheAddressArray || cacheAddressArray.count == 0)
                {
                    [[DataCacheManager sharedManager] addObject:@[addressModel] forKey:KAddressListCacheKey];
                }
                
                if (_actionDelegate)
                {
                    [_actionDelegate editAddressVC:self addressModel:addressModel];
                }
            }
            [BDKNotifyHUD showSmileyHUDWithText:@"已保存" completion:^{
                [self actionClickNavigationBarLeftButton];
            }];
        }else
        {
            if (request.isNoLogin) {
                return ;
            }
            [BDKNotifyHUD showCryingHUDWithText:@"保存失败"];
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"保存失败"];
    }];
}



@end












