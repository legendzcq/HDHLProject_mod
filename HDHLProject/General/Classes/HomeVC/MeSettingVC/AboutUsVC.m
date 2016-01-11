//
//  AboutUsVC.m
//  Carte
//
//  Created by user on 14-4-17.
//
//

#import "AboutUsVC.h"
#import "AboutUsRequest.h"

@interface AboutUsVC ()

@property (retain, nonatomic) IBOutlet UITextView *aboutUsText;
@property (retain, nonatomic) IBOutlet UILabel *versionLabel;
@property (retain, nonatomic) IBOutlet UILabel *supportLabel;


@end

@implementation AboutUsVC

- (void)dealloc {
    RELEASE_SAFELY(_aboutUsText);
    RELEASE_SAFELY(_versionLabel);
    RELEASE_SAFELY(_supportLabel);
    RELEASE_SAFELY(_aboutImageView);
}

- (void)viewDidUnload
{
    
    RELEASE_SAFELY(_aboutUsText);
    RELEASE_SAFELY(_versionLabel);
    RELEASE_SAFELY(_supportLabel);
    RELEASE_SAFELY(_aboutImageView);
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _versionLabel.hidden = YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.contentView.backgroundColor = [UIColor whiteColor];
    _versionLabel.textColor = ColorForHexKey(AppColor_Content_Text3);
    _supportLabel.textColor = ColorForHexKey(AppColor_Defaule_Hollow_Button_Text1);
    _aboutUsText.textColor = ColorForHexKey(AppColor_Content_Text3);
    
    [self setNavigationBarTitle:@"关于"];
    
    UIImage *logoImage =  _aboutImageView.image;
    _aboutImageView.size = CGSizeMake(logoImage.size.width - 3, logoImage.size.height-3);
    _aboutImageView.left = (self.view.frame.size.width - _aboutImageView.width)/2.0;
    _aboutImageView.top = 20;
    _versionLabel.top = _aboutImageView.bottom + MARGIN_M;
    
    [self readVersionInfo];
    
    [self sendAboutUsRequest];
}

-(void)actionClickNavigationBarLeftButton
{
    [AboutUsRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

-(void) readVersionInfo
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"version %@",app_Version];
}

//发送关于请求
-(void)sendAboutUsRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [AboutUsRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        if (request.isSuccess) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.firstLineHeadIndent = 24.f;
            paragraphStyle.lineSpacing = 5;
            
            NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
            _aboutUsText.attributedText = [[NSAttributedString alloc]initWithString:request.resultDic[@"data"] attributes:attributes];
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"网络连接错误"];
    }];
}


@end
