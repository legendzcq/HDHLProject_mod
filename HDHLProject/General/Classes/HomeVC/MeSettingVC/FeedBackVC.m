//
//  FeedBackVC.m
//  Carte
//
//  Created by user on 14-4-16.
//
//

#import "FeedBackVC.h"
#import "FeedBackRequest.h"


@interface FeedBackVC ()<UITextViewDelegate>
{
    //反馈内容textView
    IBOutlet UITextView     *_textView;
    
    IBOutlet UILabel *_placeHodlerLabel;
}
@end

@implementation FeedBackVC

- (void)dealloc
{
    RELEASE_SAFELY(_textView);
    RELEASE_SAFELY(_placeHodlerLabel);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_textView);
    RELEASE_SAFELY(_placeHodlerLabel);
    [super viewDidUnload];
}

-(void)configViewController
{
    [_textView becomeFirstResponder];
    [super configViewController];
    [self setNavigationBarTitle:@"意见反馈"];
    [self setRightNavigationBarButtonStyle:UIButtonStyleFaBu];
    self.navigationBarView.rightBarButton.hidden = NO;

    
}

-(void)actionClickNavigationBarLeftButton
{

    [FeedBackRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

-(void)actionClickNavigationBarRightButton{
    
    [self sendFeedBackRequest];
    
}

#pragma mark UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    _placeHodlerLabel.hidden = textView.text.length > 0;
}

//发送反馈请求
-(void)sendFeedBackRequest
{
    
    [self endEditing];
    
    if ([NSString isBlankString:_textView.text])
    {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"请输入反馈内容"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [params setObject:_textView.text forKey:@"content"];
    [FeedBackRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess) {
           
            [BDKNotifyHUD showSmileyHUDInView:self.view text:request.resultDic[@"msg"] completion:^{
                _textView.text = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            if (request.resultDic)
            {
                [BDKNotifyHUD showCryingHUDInView:self.view text:request.resultDic[@"msg"]];
            }else {
                [BDKNotifyHUD showCryingHUDInView:self.view text:@"服务器加载失败"];
            }
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
    }];
}



@end















