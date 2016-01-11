//
//  ShareView.m
//  Carte
//
//  Created by ligh on 14-4-16.
//
//

#import "ShareView.h"
#import "JCRBlurView.h"
#import <MessageUI/MessageUI.h>


@interface ShareView () <MFMessageComposeViewControllerDelegate> {
    IBOutlet UILabel  *_titleLabel;   //显示的标题

    IBOutlet UILabel  *_friendCircleTitleLabel; //朋友圈
    IBOutlet UILabel  *_sinaWeiboTitleLabel;    //新浪微博
    IBOutlet UILabel  *_weixinFriendLabel;//腾讯微博
    UIViewController  *_baseController;
    ActivityModel     *_activityModel;
    BOOL               _activityShare;
}
@end

@implementation ShareView

- (void)dealloc {
    RELEASE_SAFELY(_titleLabel);
    RELEASE_SAFELY(_friendCircleTitleLabel);
    RELEASE_SAFELY(_sinaWeiboTitleLabel);
    RELEASE_SAFELY(_weixinFriendLabel);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _shareContent = @"初始化内容";
}

- (void)showInView:(UIView *)inView shareContent:(NSString *)shareContent {
    self.shareContent = shareContent;
    [self showInView:inView shareContent:shareContent title:@"分享到"];
}

- (void)showInView:(UIView *)inView shareContent:(NSString *)shareContent title:(NSString *)title {
    self.shareContent = shareContent;
    [self showInView:inView title:title];
}

- (void)showInView:(UIView *)inView currentContainer:(UIViewController *)controller shareContent:(NSString *)shareContent title:(NSString *)title {
    _baseController = controller;
    [self showInView:inView shareContent:shareContent title:title];
}

- (void)showInView:(UIView *)inView currentContainer:(UIViewController *)controller shareContent:(NSString *)shareContent {
    _baseController = controller;
    [self showInView:inView shareContent:shareContent];
}

- (void)showInView:(UIView *)inView currentContainer:(UIViewController *)controller title:(NSString *)title withActivityModel:(ActivityModel *)activityModel {
    _activityShare  = YES;
    _baseController = controller;
    _activityModel  = activityModel ;
    [KUserDefaults setObject:[NSNumber numberWithBool:_activityShare] forKey:ACTIVITYSHARE_KEY];//切换到微博视图，将参数和BOOL值记下
    [KUserDefaults setObject:activityModel.share_param forKey:ACTIVITYSHARE_PARAMERKEY];
        if(![activityModel.share_param length]){
            [BDKNotifyHUD showCryingHUDWithText:@"参数为空"];
        }
    [self showInView:inView title:title];
}

- (void)showInView:(UIView *)inView title:(NSString *)title {
    _titleLabel.text = title;
    [self showPickerInView:inView];
    if ([NSString isBlankString:_shareContent]) {
        [BDKNotifyHUD showCryingHUDWithText:@"警告：分享内容为空！"];
    }
}

#pragma mark -
#pragma mark - ViewAcitons

//新浪微博
- (IBAction)sinaAction:(id)sender {
    if(![WeiboSDK isWeiboAppInstalled]) {
        [BDKNotifyHUD showCryingHUDWithText:@"尚未安装新浪微博客户端"];
        [self dismissPicker];
        return;
    }
    [self dismissPicker];
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = _shareContent;
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

//QQ
- (IBAction)qqAction:(id)sender {
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:_shareContent];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    QQApiSendResultCode code = [QQApiInterface sendReq:req];
    [self handleQQSendResult:code];
    [self dismissPicker];
}

- (void)handleQQSendResult:(QQApiSendResultCode)sendResult {
    switch (sendResult) {
        case EQQAPIQQNOTINSTALLED: {
            [BDKNotifyHUD showCryingHUDWithText:@"尚未安装手机QQ客户端"];
            break;
        } default: {
            [BDKNotifyHUD showCryingHUDWithText:@"发送失败"];
            break;
        }
    }
}

//腾讯微博
- (IBAction)tencentWeiboAction:(id)sender {
    [[TencentWeiboApiManager shareManager] tencentWbShareWithContent:_shareContent successCompletion:^(BOOL success) {
    } failureCompletion:^(BOOL failure) {
    }];
    [self dismissPicker];
}

//微信朋友圈
- (IBAction)wxSceneTimelineAction:(id)sender {
    if(![WXApi isWXAppInstalled]) {
        [BDKNotifyHUD showCryingHUDWithText:@"尚未安装微信客户端"];
        [self dismissPicker];
        return;
    }
    [[WXApiManager shareManager] wxShareForMessage:WXApiTypeSceneTimeline content:_shareContent successCompletion:^(BOOL success) {
    } failureCompletion:^(BOOL failure) {
    }];
    [self dismissPicker];
}

//微信好友
- (IBAction)wxSceneSessionAction:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        [BDKNotifyHUD showCryingHUDWithText:@"尚未安装微信客户端"];
        [self dismissPicker];
        return;
    }
    [[WXApiManager shareManager] wxShareForMessage:WXApiTypeWXSceneSession content:_shareContent successCompletion:^(BOOL success) {
    } failureCompletion:^(BOOL failure) {
    }];
    [self dismissPicker];
}

//短信分享
- (IBAction)sMSAction:(id)sender {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        controller.body = _shareContent;
        controller.messageComposeDelegate = self;
        [_baseController presentViewController:controller animated:YES completion:^(void){
        }];
    } else {
        [BDKNotifyHUD showCryingHUDWithText:@"此设备无法发送短息"];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [controller dismissViewControllerAnimated:YES completion:^(void){
        switch (result) {
            case MessageComposeResultCancelled:
                [BDKNotifyHUD showCryingHUDWithText:@"发送取消"];
                [self dismissPicker];
                break;
            case MessageComposeResultFailed:
                [BDKNotifyHUD showCryingHUDWithText:@"发送失败"];
                [self dismissPicker];
                break;
            case MessageComposeResultSent:
                [BDKNotifyHUD showSmileyHUDWithText:@"已发送"];
                [self dismissPicker];
                break;
            default:
                break;
        }
    }];
}

- (void)dismiss:(BOOL)isRemove {
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        if (isRemove) {
            [self removeFromSuperview];
        }
    }];
}

- (void)sendActivityShareWithShareType:(ShareChannelType)shareType {
    if(! [[KUserDefaults objectForKey:ACTIVITYSHARE_KEY] boolValue]){
        return ;
    }
    [self activityShareSuccessWithShareType:shareType];
}

//分享活动成功的请求
- (void)activityShareSuccessWithShareType:(ShareChannelType)shareType {
    NSString *parameters =[[KUserDefaults objectForKey:ACTIVITYSHARE_KEY] boolValue] ? [KUserDefaults objectForKey:ACTIVITYSHARE_PARAMERKEY]:_activityModel.share_param;
    if(![parameters length]){
        return ;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:parameters forKey:@"share_param"];
    [params setObject:[NSString stringWithFormat:@"%d",shareType] forKey:@"share_channel"];
    [ActivityShareRequest requestWithParameters:params withIndicatorView:nil onRequestFinished:^(ITTBaseDataRequest *request) {
        
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

@end
