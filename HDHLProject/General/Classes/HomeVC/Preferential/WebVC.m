//
//  WebVC.m
//  Carte
//
//  Created by ligh on 14-5-16.
//
//

#import "WebVC.h"
#import "ActityRequest.h"
#import "shareView.h"
#import "ActivityModel.h"

/*
               _ooOoo_
              o8888888o
              88" . "88
              (| -_- |)
              O\  =  /O
           ____/`---'\____
       .  '  \\|     |//  `.
        /  \\|||  :  |||//  \
       /  _||||| -:- |||||-  \
       |   | \\\  -  /// |   |
       | \_|  ''\---/''  |   |
       \  .-\__  `-`  ___/-. /
     ___`. .'  /--.--\  `. . __
  ."" '<  `.___\_<|>_/___.'  >'"".
 | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 \  \ `-.   \_ __\ /__ _/   .-` /  /
 ==========`-.____`-.___\_____/___.-`===========
 `=---='
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 佛祖保佑       永无BUG    永不修改
 */

@interface WebVC ()<UIWebViewDelegate> {
    IBOutlet UIWebView  *_webView;
    NSString            *_contentID;
    NSString            *_content;
    ActivityModel       *_activityModel;
}
@end

@implementation WebVC

- (void)dealloc {
    RELEASE_SAFELY(_contentID);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_webView);
}

- (void)viewDidUnload {
    RELEASE_SAFELY(_contentID);
    RELEASE_SAFELY(_content);
    RELEASE_SAFELY(_webView);
    [super viewDidUnload];
}

- (id)initWithContentID:(NSString *)contentID {
    if (self = [super init]) {
        _contentID = contentID;
    }
    return self;
}

- (id)initWithContent:(NSString *)content {
    if (self = [super init]) {
        _content = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarTitle:@"活动"];
    self.navigationBarView.rightBarButton.hidden = NO;
    [self setRightNavigationBarButtonStyle:UIButtonStyleShare];
    if (_content) {
        [_webView loadHTMLString:_content baseURL:nil];
    } else {
        [self sendReauestOfActivityContent];
    }
}

- (void)actionClickNavigationBarLeftButton {
    [ActityRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

- (void)actionClickNavigationBarRightButton {
    ShareView *shareView = [ShareView viewFromXIB];
    if (![NSString isBlankString:_activityModel.share_content]) {
        shareView.shareContent = _activityModel.share_content;
    }
    [shareView showInView:self.view currentContainer:self shareContent:_activityModel.share_content];
}

#pragma mark - WebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

#pragma mark - Request

- (void)sendReauestOfActivityContent {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_contentID forKey:@"activity_id"];
    
    [ActityRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess) {
            _activityModel = [[ActivityModel alloc] initWithDictionary:request.resultDic[@"data"]];
            
            NSString *conent = request.resultDic[@"data"][@"content"];
            if ([NSString isBlankString:conent]) {
                conent = kDefaultActivityContent;
            }
            [_webView loadHTMLString:conent baseURL:nil];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
    }];
}

@end
