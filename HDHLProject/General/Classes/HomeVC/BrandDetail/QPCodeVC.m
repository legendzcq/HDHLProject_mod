//
//  QPCodeVC.m
//  Carte
//
//  Created by zln on 15/1/7.
//
//

#import "QPCodeVC.h"
#import "QRCodeRequest.h"
#import "QRCodeModel.h"
#import "ShareView.h"
#import "StoreModel.h"

@interface QPCodeVC ()
{
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet WebImageView *_QPCode;
    QRCodeModel *_qrModel;
    NSString                *_storeID;
    NSString                *_storeName;
}

@end

@implementation QPCodeVC

-(id)initWithStoreID:(NSString *)store_id withStoreName:(NSString *)storeName
{
    if (self = [super init])
    {
        _storeID = store_id;
        _storeName = storeName;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sendRequestOfQRCode];
    self.contentView.hidden = YES;
    [self.navigationBarView setNavigationBarTitle:@"二维码"];
    self.navigationBarView.rightBarButton.hidden = YES;
//    [self setRightNavigationBarButtonStyle:UIButtonStyleShare];
    _titleLabel.textColor = ColorForHexKey(AppColor_First_Level_Title1);
}

- (void)dealloc {
    
    RELEASE_SAFELY(_QPCode);
    RELEASE_SAFELY(_titleLabel);
}
- (void)viewDidUnload {
    
    RELEASE_SAFELY(_QPCode);
    RELEASE_SAFELY(_titleLabel);
    
    _QPCode = nil;
    [super viewDidUnload];
}

//- (void)actionClickNavigationBarRightButton
//{
//    ShareView *shareView = [ShareView viewFromXIB];
//    if (_qrModel != nil && _qrModel.share_content != nil) {
//        shareView.shareContent = _qrModel.share_content;
//    }
//    [shareView showInView:self.view currentContainer:self shareContent:shareView.shareContent title:@"分享到"];
//}
- (void)sendRequestOfQRCode{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Id forKey:@"user_id"];
    }
    [params setObject:_storeID forKey:@"store_id"];

    [QRCodeRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
        
        if (request.isSuccess)
        {
            _qrModel = (QRCodeModel*)[QRCodeModel reflectObjectsWithJsonObject:request.resultDic[@"data"]];
            self.contentView.hidden = NO;
            [_QPCode setImageWithUrlString:_qrModel.img placeholderImage:KBigPlaceHodlerImage];
            _titleLabel.text = [NSString stringWithFormat:@"扫一扫，即可下载使用"];

        } else
        {
            if (request.resultDic) {
                [self showServerErrorPromptView];
            } else
            {
                [self showNetErrorPromptView];
            }
        }
    } onRequestFailed:^(ITTBaseDataRequest *request) {
        
        [self showNetErrorPromptView];
        
    }];
}


@end
