//
//  UPPayPluginManager.m
//  Carte
//
//  Created by ligh on 15-1-19.
//
//

#import "UPPayPluginManager.h"

#define kAlertWaiting     @"正在获取TN,请稍后..."
#define kAlertTitle       @"提示"
#define kAlertConfirm     @"确定"
#define kAlertErrorNet    @"网络错误"
#define kResult           @"%@"

#define kMode_Development @"00" //@"00":生产环境(正式版需要); @"01":开发测试环境(测试版本需要);
#define kURL_TN_Normal    @"http://202.101.25.178:8080/sim/gettn"
//#define kURL_TN_Configure @"http://202.101.25.178:8080/sim/app.jsp?user=123456789"

#define UPRelease(X) if (X != nil) {X = nil;}

@interface UPPayPluginManager () <UPPayPluginDelegate, UIAlertViewDelegate>
{
    UIAlertView      *_alertView;
    NSMutableData    *_responseData;
    UIViewController *_currentVC; //银联支付当前依附的页面控制器
    
    UPPaySuccessBlock _successBlock;
    UPPayFailBlock    _failBlock;
    UPPayCancelBlock  _cancelBlock;
    
}
@property(nonatomic, copy)NSString *tnMode;

@end

@implementation UPPayPluginManager

static id instance;
+ (id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)dealloc
{
    UPRelease(_successBlock);
    UPRelease(_failBlock);
    UPRelease(_cancelBlock);
}

- (void)uPPayPluginStartViewController:(UIViewController *)view uPPayTN:(NSString *)tn successBlock:(UPPaySuccessBlock)success failBlock:(UPPayFailBlock)fail cancelBlock:(UPPayCancelBlock)cancel
{
    UPRelease(_successBlock);
    UPRelease(_failBlock);
    UPRelease(_cancelBlock);
    _successBlock = [success copy];
    _failBlock    = [fail copy];
    _cancelBlock  = [cancel copy];
    
    self.tnMode = kMode_Development;
    _currentVC = view;
//    //获取TN（开发环境）
//    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
    //获取TN（正式环境）
//    NSString *tn = @"自己后台服务器给的tn订单号";
    if (tn != nil && tn.length > 0) {
        [UPPayPlugin startPay:tn mode:self.tnMode viewController:_currentVC delegate:self];
    }
}


- (void)uPPayPluginStartViewController:(UIViewController *)view
{
    self.tnMode = kMode_Development;
    
    
    _currentVC = view;
    //获取TN
    [self startNetWithURL:[NSURL URLWithString:kURL_TN_Normal]];
}

- (void)startNetWithURL:(NSURL *)url
{
    [self showAlertWait];
    
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
}


#pragma mark - UPPayPluginDelegate / UPPayPluginResult

- (void)UPPayPluginResult:(NSString *)result
{
    NSString *resultStr = result;
    if ([result isEqualToString:@"success"]) {
        resultStr = kResultSuccess;
        if(_successBlock) {
            _successBlock([NSString stringWithFormat:kResult, resultStr]);
        }
    }
    if ([result isEqualToString:@"fail"]) {
        resultStr = kResultError;
        if(_failBlock) {
            _failBlock([NSString stringWithFormat:kResult, resultStr]);
        }
    }
    if ([result isEqualToString:@"cancel"]) {
        resultStr = kResultCancel;
        if(_cancelBlock) {
            _cancelBlock([NSString stringWithFormat:kResult, resultStr]);
        }
    }
//    NSString* msg = [NSString stringWithFormat:kResult, resultStr];
//    [self showAlertMessage:msg];
}


#pragma mark - NSHTTPURL-Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    NSInteger code = [rsp statusCode];
    if (code != 200)
    {
        if(_failBlock) {
            _failBlock(kAlertErrorNet);
        }
        [self showAlertMessage:kAlertErrorNet];
        [connection cancel];
    }
    else
    {
        UPRelease(_responseData);
        _responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        NSLog(@"---------UPPayPlugin---------tn=%@",tn);
        [UPPayPlugin startPay:tn mode:self.tnMode viewController:_currentVC delegate:self];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self showAlertMessage:kAlertErrorNet];
}

#pragma mark - Alert

- (void)showAlertWait
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kAlertWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_alertView show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_alertView.frame.size.width / 2.0f - 15, _alertView.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_alertView addSubview:aiv];
}

- (void)showAlertMessage:(NSString*)msg
{
    [self hideAlert];
    _alertView = [[UIAlertView alloc] initWithTitle:kAlertTitle message:msg delegate:self cancelButtonTitle:kAlertConfirm otherButtonTitles:nil, nil];
    [_alertView show];
}
- (void)hideAlert
{
    if (_alertView != nil) {
        [_alertView dismissWithClickedButtonIndex:0 animated:NO];
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    _alertView = nil;
}

@end
