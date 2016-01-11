//
//  QRCodeAddBrand.m
//  HDHLProject
//
//  Created by hdcai on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QRCodeAddBrand.h"
#import "QRCodeAddCardRequest.h"
#import "NotLoginView.h"
#import "LoginVC.h"
#import "TakeOrderVC.h"
#import <AVFoundation/AVFoundation.h>

#define SCANVIEW_EdgeTop 80.0
#define SCANVIEW_EdgeLeft 50.0

#define TINTCOLOR_ALPHA 0.5  //浅色透明度
#define DARKCOLOR_ALPHA 0.5  //深色透明度


@interface QRCodeAddBrand ()
{
//    ZBarReaderView * readview;
    UIImageView * readLineView;
    UIView * scanZomeBack;
    NSString *store_id;
    NSString *share_user_id;
    UIImageView * qrlineImageV;
    NSTimer *_timer;
}
@end

@implementation QRCodeAddBrand

- (void)dealloc
{
//    RELEASE_SAFELY(readview);
    RELEASE_SAFELY(readLineView);
    RELEASE_SAFELY(scanZomeBack);
    RELEASE_SAFELY(qrlineImageV);
}

- (void)viewDidUnload
{
//    RELEASE_SAFELY(readview);
    RELEASE_SAFELY(readLineView);
    RELEASE_SAFELY(scanZomeBack);
    
    [super viewDidUnload];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([AccountHelper isLogin]) {
        [self buildUI];
    }
    [self refreshUI];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)configViewController
{
    [super configViewController];

    [self setNavigationBarTitle:@"扫一扫"];
}

-(void)buildUI
{
    [self setScanView];
//    readview= [[ZBarReaderView alloc]init];
//    readview.frame =CGRectMake(0,0,self.contentView.frame.size.width, self.contentView.frame.size.height);
//    readview.tracksSymbols=NO;
//    readview.trackingColor = [UIColor clearColor];
//    readview.readerDelegate =self;
//    [readview addSubview:scanZomeBack];
//    [self.contentView addSubview:readview];
}

-(void)refreshUI
{
    self.contentView.backgroundColor = [UIColor blackColor];
    //////
    if ([AccountHelper isLogin]){
        [NotLoginView dismissFromSuperView:self.contentView];
    }else{
        [NotLoginView showInView:self.contentView WithText:@"您还没有登录"WithBoolTableBarView:NO  WithBlock:^{
            LoginVC *loginVC= [[LoginVC alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }];
    }
    //关闭闪光灯
//    readview.torchMode =0;
    /////
    [self judgeAVAuthorizationStatus];
    [self createTimer];
//    [readview start];
}

//判断有没有开启摄像头的判断
-(void)judgeAVAuthorizationStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized)
    {
        UIAlertView *avaStatusAlert = [[UIAlertView alloc]initWithTitle:nil message:@"开启相机功能 请在iPhone的\"设置\"-\"隐私\"-\"相机\"功能中，找到应用程序更改" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [avaStatusAlert show];
    }
}


-(void)setScanView
{
    scanZomeBack =[[UIView alloc] initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width,self.contentView.frame.size.height-64)];
    scanZomeBack.backgroundColor=[UIColor clearColor];
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.contentView.frame.size.width,SCANVIEW_EdgeTop)];
    upView.alpha =TINTCOLOR_ALPHA;
    upView.backgroundColor = [UIColor blackColor];
    [scanZomeBack addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft)];
    leftView.alpha =TINTCOLOR_ALPHA;
    leftView.backgroundColor = [UIColor blackColor];
    [scanZomeBack addSubview:leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft,self.view.frame.size.width-2*SCANVIEW_EdgeLeft)];
    scanCropView.image=[UIImage imageNamed:@"sweep_around"];
    
    //    scanCropView.layer.borderColor=[UIColor redColor];
    //    scanCropView.layer.borderWidth=2.0;
    
    scanCropView.backgroundColor=[UIColor clearColor];
    [scanZomeBack addSubview:scanCropView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop, SCANVIEW_EdgeLeft,self.contentView.frame.size.width -2*SCANVIEW_EdgeLeft)];
    rightView.alpha =TINTCOLOR_ALPHA;
    rightView.backgroundColor = [UIColor blackColor];
    [scanZomeBack addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0,self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop,self.view.frame.size.width, self.contentView.frame.size.height-(self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop))];
    downView.alpha = TINTCOLOR_ALPHA;
    downView.backgroundColor = [UIColor blackColor];
    //    downView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:TINTCOLOR_ALPHA];
    [scanZomeBack addSubview:downView];
    //用于说明的label
    UILabel *labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor blackColor];
    labIntroudction.frame=CGRectMake(0,15, self.contentView.frame.size.width,20);
    labIntroudction.numberOfLines=1;
    labIntroudction.font=[UIFont systemFontOfSize:15.0];
    labIntroudction.textAlignment=NSTextAlignmentCenter;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text=@"将二维码对准方框，即可自动扫描";
    [downView addSubview:labIntroudction];
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, downView.frame.size.height-100.0,self.contentView.frame.size.width, 100.0)];
    darkView.alpha = TINTCOLOR_ALPHA;
    darkView.backgroundColor = [UIColor blackColor];
    //    darkView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:DARKCOLOR_ALPHA];
    [downView addSubview:darkView];
    //    //用于开关灯操作的button
    //    UIButton *openButton=[[UIButtonalloc] initWithFrame:CGRectMake(10,20, 300.0, 40.0)];
    //    [openButtonsetTitle:@"开启闪光灯" forState:UIControlStateNormal];
    //    [openButton setTitleColor:[UIColorwhiteColor] forState:UIControlStateNormal];
    //    openButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    //    openButton.backgroundColor=[UIColorgetThemeColor];
    //    openButton.titleLabel.font=[UIFontsystemFontOfSize:22.0];
    //    [openButton addTarget:selfaction:@selector(openLight)forControlEvents:UIControlEventTouchUpInside];
    //    [darkViewaddSubview:openButton];
    
    //画中间的基准线
    qrlineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCANVIEW_EdgeLeft,SCANVIEW_EdgeTop-2, self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft,4)];
    qrlineImageV.image = [UIImage imageNamed:@"sweep_line"];
    [scanZomeBack addSubview:qrlineImageV];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self stopTimer];
//    [readview stop];
}

#pragma mark 获取扫描结果
//- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
//{
    //    // 得到扫描的条码内容
    //    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    //    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    //    NSLog(@"%@",symbolStr);
    //    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
    //        // 是否QR二维码
    //    }
    //
    //    for (ZBarSymbol *symbol in symbols) {
    ////        [sTxtField setText:symbol.data];
    //        break;
    //    }
    //
    //    [readerView stop];
    //    [readerView removeFromSuperview];
    
    
//    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
//    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
//    
//    NSArray * array = [symbolStr componentsSeparatedByString:@"/"];
//    NSArray * array1 = [symbolStr componentsSeparatedByString:@"&"];
//    if (array.count>0) {
//        for (int i = 0; i<array.count; i++) {
//            if ([array[i] rangeOfString:@"@"].location != NSNotFound) {
//                NSRange range = [array[i] rangeOfString:@"@"];
//                store_id = [array[i] substringToIndex:range.location];
//                share_user_id = [array[i] substringFromIndex:(range.location + 1)];
//            }
//        }
//    }
//    if (array1.count>0) {
//        for (int i=0; i<array1.count; i++) {
//            if ([array[i] rangeOfString:@"@"].location != NSNotFound) {
//                NSRange range = [array[i] rangeOfString:@"@"];
//                store_id = [array[i] substringToIndex:range.location];
//                share_user_id = [array[i] substringFromIndex:(range.location + 1)];
//            }
//        }
//    }
//    if ([store_id intValue]) {
//        //////////////////////跳转操作
//        TakeOrderVC *takeorderVC = [[TakeOrderVC alloc]initWithStoreID:store_id];
//        takeorderVC.share_user_id = share_user_id;
//        [self.navigationController pushViewController:takeorderVC animated:YES];
//        
//    }else{
//        [BDKNotifyHUD showCryingHUDInView:self.view text:@"您扫描的品牌二维码有误，请重新扫描"];
//    }
//    
//}
//
//-(void)sendRequestForAddCard
//{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    if (![NSString isBlankString:s_id]) {
//        [params setObject:s_id forKey:@"s_id"];
//    }
//    if (![NSString isBlankString:store_id]) {
//        [params setObject:store_id forKey:@"store_id"];
//    }
//    [params setObject:[AccountHelper uid] forKey:@"user_id"];
//    
//    [QRCodeAddCardRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
//     {
//         if (request.isSuccess) {
//             [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:nil];
//         }else{
//             if (request.isNoLogin) {
//                 return ;
//             }
//         }
//         [self changeTabBarControllerWithTabbarIndex:kTabbarIndex0];
//         NSString *msg = request.resultDic[@"msg"];
//         [BDKNotifyHUD showCryingHUDWithText:msg];
//
//     } onRequestFailed:^(ITTBaseDataRequest *request) {
//         [self changeTabBarControllerWithTabbarIndex:kTabbarIndex0];
//         [BDKNotifyHUD showCryingHUDWithText:@"添加失败"];
//     }];
//    
//}
-(void)createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

//二维码的横线移动
- (void)moveUpAndDownLine
{
    CGFloat Y=qrlineImageV.frame.origin.y;
//    CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop -2==Y){
        
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:2];
        qrlineImageV.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop-2, self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft,4);
        [UIView commitAnimations];
    }else if(SCANVIEW_EdgeTop - 2==Y){
        [UIView beginAnimations:@"asa" context:nil];
        [UIView setAnimationDuration:2];
        qrlineImageV.frame=CGRectMake(SCANVIEW_EdgeLeft, self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop -2, self.contentView.frame.size.width-2*SCANVIEW_EdgeLeft,4);
        [UIView commitAnimations];
    }
    
}

- (void)stopTimer
{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer =nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
