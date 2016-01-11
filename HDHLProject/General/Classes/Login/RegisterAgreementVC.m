//
//  RegisterAgreementVC.m
//  Carte
//
//  Created by ligh on 14-6-10.
//
//

#import "RegisterAgreementVC.h"
#import "RegsiterAgreementRequest.h"

@interface RegisterAgreementVC ()
{

}
@end

@implementation RegisterAgreementVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigationBarTitle:@"使用条款和隐私政策"];
    
    [self sendRequestOfAgreement];
}
#pragma mark viewActions
-(void)actionClickNavigationBarLeftButton
{
    [RegsiterAgreementRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}
-(void)clickPromptViewAction
{
    [self sendRequestOfAgreement];
}

/**
 *  获取汇点协议
 */
-(void) sendRequestOfAgreement
{
    [RegsiterAgreementRequest requestWithParameters:nil withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
    {
        if (request.isSuccess)
        {
            NSString *content = request.resultDic[@"data"][@"protocol"];
            UIWebView *webView = (UIWebView *)self.contentView;
            [webView loadHTMLString:content baseURL:nil];
            
            [self hidePromptView];
            
        }else
        {
            if (request.resultDic)
            {
                [self showServerErrorPromptView];
            }else
            {
                [self showNetErrorPromptView];
            }
        }
        
    } onRequestFailed:^(ITTBaseDataRequest *request)
    {
        [self showNetErrorPromptView];
    }];
}

@end
