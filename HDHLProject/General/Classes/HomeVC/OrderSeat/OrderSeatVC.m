//
//  OrderSeatVC.m
//  Carte
//
//  Created by ligh on 14-4-14.
//
//

#import "OrderSeatVC.h"
#import "PickerRowView.h"
#import "GenderPickerView.h"

#import "BookSeatInitRequest.h"
#import "BookSeatRequest.h"
#import "OrderVC.h"

@interface OrderSeatVC () <UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate,UITextFieldDelegate> {
    
    IBOutlet UIPickerView *_pickerView;
    IBOutlet UILabel *_pickerTimeTitleLabel;
    IBOutlet UILabel *_pickerPersonTitleLabel;
    IBOutlet UILabel *_pickerDateLabel;
    IBOutlet UILabel *_pickerDeskLabel;

    IBOutlet UITextField    *_nameInfoText;//联系人姓名
    IBOutlet UITextField    *_phoneNumberInfoText;//联系人电话
    IBOutlet UITextField    *_remarkTextField;//备注
    IBOutlet UIScrollView   *_scrollView;
    IBOutlet UIView         *_confirmView;
    IBOutlet UIButton       *_submitOrderButton;//提交订单按钮
    GenderPickerView        *_genderView;
    IBOutlet FrameView      *_contactInfoView;
    
    StoreModel            *_storeModel;//订座商家
    NSArray               *_bookDataArray;//支持的预定时间
    NSArray               *_bookPerArray;
    NSArray               *_seatArtay;//座位类型
    
    BOOL textFieldCanChange;
    NSString *nameText;
}
@end

@implementation OrderSeatVC


- (void)dealloc {
    RELEASE_SAFELY(_storeModel);
    RELEASE_SAFELY(_pickerView);
    RELEASE_SAFELY(_nameInfoText);
    RELEASE_SAFELY(_phoneNumberInfoText);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_remarkTextField);
    RELEASE_SAFELY(_confirmView);
    RELEASE_SAFELY(_submitOrderButton);
    RELEASE_SAFELY(_contactInfoView);
    RELEASE_SAFELY(_pickerTimeTitleLabel);
    RELEASE_SAFELY(_pickerPersonTitleLabel);
    RELEASE_SAFELY(_pickerDateLabel);
    RELEASE_SAFELY(nameText);
}

- (void)viewDidUnload {
    RELEASE_SAFELY(_pickerView);
    RELEASE_SAFELY(_nameInfoText);
    RELEASE_SAFELY(_phoneNumberInfoText);
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_remarkTextField);
    RELEASE_SAFELY(_confirmView);
    RELEASE_SAFELY(_submitOrderButton);
    RELEASE_SAFELY(_contactInfoView);
    RELEASE_SAFELY(_pickerTimeTitleLabel);
    RELEASE_SAFELY(_pickerPersonTitleLabel);
    RELEASE_SAFELY(_pickerDateLabel);
    RELEASE_SAFELY(nameText);
    [super viewDidUnload];
}

- (id)initWithStoreIdOfOrderSeat:(NSString *)storeId {
    if (self = [super init]) {
        if (!_storeModel) {
            _storeModel = [[StoreModel alloc] init];
        }
        _storeModel.store_id = storeId;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    textFieldCanChange = YES;
    nameText = [[NSString alloc] initWithString:_nameInfoText.text];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configViewController {
    [super configViewController];
    [self loadColorConfig];    
    [self setNavigationBarTitle:@"订座"];
    
    [_scrollView setContentSize:CGSizeMake(0, 450)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyboardSeatVC:)];
    [_scrollView addGestureRecognizer:singleTap];
    
    [self refreshUI];
    [self sendReqeustOfInit];
}

- (void)loadColorConfig {
    _submitOrderButton.titleLabel.font = FONT_BOTTOM_BUTTON;
    
    _pickerTimeTitleLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _pickerPersonTitleLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _pickerDateLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
    _pickerDeskLabel.textColor = ColorForHexKey(AppColor_OrderList_NameText);
}

- (void)hiddenKeyboardSeatVC:(UITapGestureRecognizer* )singleTap {
    [self endEditing];
}

- (void)refreshUI {
    if(![NSString isBlankString:[AccountHelper userInfo].username]) {
        _nameInfoText.text = [AccountHelper userInfo].username;
    }
    if(![NSString isBlankString:[AccountHelper userInfo].mobile]) {
        _phoneNumberInfoText.text = [AccountHelper userInfo].mobile;
    }
    _genderView = [GenderPickerView viewFromXIB];
    _genderView.left = _contactInfoView.width-10-_genderView.width;
    _genderView.top  = 7;
    [_contactInfoView addSubview:_genderView];
    
    //确认按钮frame设置
    [_submitOrderButton setTitleColor:ColorForHexKey(AppColor_Default_Button_Text) forState:UIControlStateNormal];
    [_submitOrderButton setBackgroundImage:[UIImage resizableWithImage:[UIImage imageNamed:@"list_button"]] forState:UIControlStateNormal];
    [_submitOrderButton setBackgroundImage:[UIImage resizableWithImage:[UIImage imageNamed:@"list_button_click"]] forState:UIControlStateHighlighted];
//    _submitOrderButton.center = _confirmView.center;
}

- (void)adjustPickerView {
    _pickerView.height = 150; //设置pickerView的高度 为 item height *  3 //正好显示三行
    //到店日期
    [_pickerView selectRow:1 inComponent:0 animated:NO];
    [_pickerView reloadComponent:1];
    //时间
    [_pickerView selectRow:1 inComponent:1 animated:NO];
    //人数
    [_pickerView selectRow:1 inComponent:2 animated:NO];
    //餐台
    [_pickerView selectRow:1 inComponent:3 animated:NO];
}


- (HoursModel *)selectedHoursModel {
    NSInteger dateRow =  [_pickerView selectedRowInComponent:0];
    NSInteger hourceRow = [_pickerView selectedRowInComponent:1];
    PayInfoDateModel *dateModel = _bookDataArray[dateRow];
    HoursModel *hoursModel =  dateModel.hours[hourceRow];
    return hoursModel;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self endEditing];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    //日期
    if (component == 0) {
        return _bookDataArray.count;
    } else if(component == 1) {
        NSInteger row =  [pickerView selectedRowInComponent:0];
        PayInfoDateModel *dateModel = _bookDataArray[row];
        return dateModel.hours.count;
    } else if(component == 2) {
        return _bookPerArray.count;
    } else if(component == 3) {
        return _seatArtay.count;;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        if (row == 0) {
            [_pickerView selectRow:1 inComponent:component animated:YES];
        } else if (row == _bookDataArray.count-1) {
            [_pickerView selectRow:(_bookDataArray.count-2) inComponent:component animated:YES];
        }
    } else if (component == 1) {
        if (row == 0) {
            [_pickerView selectRow:1 inComponent:component animated:YES];
        } else {
            NSInteger comRow =  [pickerView selectedRowInComponent:0];
            PayInfoDateModel *dateModel = _bookDataArray[comRow];
            if (row == dateModel.hours.count-1) {
                [_pickerView selectRow:(dateModel.hours.count-2) inComponent:component animated:YES];
            }
        }
    } else if (component == 2) {
        if (row == 0) {
            [_pickerView selectRow:1 inComponent:component animated:YES];
        } else if (row == _bookPerArray.count-1) {
            [_pickerView selectRow:(_bookPerArray.count-2) inComponent:component animated:YES];
        }
    } else if (component == 3) {
        if (row == 0) {
            [_pickerView selectRow:1 inComponent:component animated:YES];
        } else if (row == _seatArtay.count-1) {
            [_pickerView selectRow:(_seatArtay.count-2) inComponent:component animated:YES];
        }
    }
    
    if (component == 0) {
        [pickerView reloadComponent:1];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 4;
}


- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return _pickerView.width/4-10; //92
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    NSString *title = nil;
    
    //日期
    if (component == 0) {
        PayInfoDateModel *dateModel = _bookDataArray[row];
        title = [NSString stringWithFormat:@"%@ %@",dateModel.md,dateModel.week];
        
    } else if(component == 1) {
        NSInteger dateRow =  [pickerView selectedRowInComponent:0];
        PayInfoDateModel *dateModel = _bookDataArray[dateRow];
        HoursModel *hoursModel =  (HoursModel *)dateModel.hours[row];
        title = hoursModel.minute;
    } else if(component == 2) {
        if (row == 0 || row == _bookPerArray.count-1) {
            title = [NSString stringWithFormat:@"%@",_bookPerArray[row]];
        } else {
            title = [NSString stringWithFormat:@"%@人",_bookPerArray[row]];
        }
    } else if(component == 3) {
        SeatModel *seatModel = _seatArtay[row];
        title = seatModel.seat_name;
    }
    PickerRowView *rowView = [PickerRowView viewFromXIB];
    [rowView setTitle:title];
    
    return rowView;
}

//确认预定事件
- (IBAction)makeOrderAction:(id)sender {
    [self sendRequestOfBookSeat];
}

- (void)actionClickNavigationBarLeftButton {
    [BookSeatInitRequest cancelUseDefaultSubjectRequest];
    [BookSeatRequest cancelUseDefaultSubjectRequest];
    [super actionClickNavigationBarLeftButton];
}

#pragma mark - Request

//订座初始化请求  获取商家支持的日期 时间 人数 包间类型
- (void)sendReqeustOfInit {
    self.contentView.hidden = YES;
    _confirmView.hidden = YES;
    
    if ([NSString isBlankString:_storeModel.store_id]) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Id forKey:@"user_id"];
    [params setObject:_storeModel.store_id forKey:@"store_id"];
    [params setObject:[NSString stringWithFormat:@"%d", SeatOrderType] forKey:@"order_type"];
    
    [BookSeatInitRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
         
         if (request.isSuccess) {
             _storeModel = (StoreModel *)[StoreModel reflectObjectsWithJsonObject:request.resultDic[@"data"]]; //分店信息
             
             _bookDataArray  = request.resultDic[KTakeOrderDateResultRequest];
             _bookPerArray = request.resultDic[KTakeOrderMaxPerResultRequest];
             _seatArtay = request.resultDic[KTakeOrderSeatsModelResultRequest];
             
             if (_bookDataArray.count && _bookPerArray.count && _seatArtay.count) {
                 [_pickerView reloadAllComponents];
                 [self adjustPickerView];
                 self.contentView.hidden = NO;
                 _confirmView.hidden = NO;
                 [self hidePromptView];
             } else {
                 [self showServerErrorPromptView];
             }
         } else {
             if (request.isNoLogin) {
                 return ;
             }
             if (request.resultDic) {
                 [self showServerErrorPromptView];
             } else {
                 [self showNetErrorPromptView];
             }
         }
     } onRequestFailed:^(ITTBaseDataRequest *request) {
         [self showNetErrorPromptView];
     }];
}

//预定座位
- (void)sendRequestOfBookSeat {
    if ([NSString isBlankString:_nameInfoText.text]) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:_nameInfoText.placeholder];
        return;
    }
    
    if ([NSString isBlankString:_phoneNumberInfoText.text]) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:_phoneNumberInfoText.placeholder];
        return;
    }
    
    if (!_bookDataArray || _bookDataArray.count == 0) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"未选择日期"];
        return;
    }
    
    PayInfoDateModel *dateModel = _bookDataArray[ [_pickerView selectedRowInComponent:0]];
    
    if (!dateModel.hours || dateModel.hours.count == 0) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"未选择时间"];
        return;
    }
    
    if (!_bookPerArray || _bookPerArray.count == 0) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"未选择人数"];
        return;
    }
    
    if (!_seatArtay || _seatArtay.count == 0) {
        [BDKNotifyHUD showCryingHUDInView:self.view text:@"未选择房间类型"];
        return;
    }
    
    _submitOrderButton.enabled = NO;
    
    HoursModel *timeModel = [self selectedHoursModel];
    NSString *per = [NSString stringWithFormat:@"%@",_bookPerArray[[_pickerView selectedRowInComponent:2]]];
    SeatModel *seatModel =_seatArtay[[_pickerView selectedRowInComponent:3]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_storeModel.store_id forKey:@"store_id"];
    [params setObject:[AccountHelper uid] forKey:@"user_id"];
    [params setObject:_nameInfoText.text forKey:@"user_name"];
    [params setObject:_phoneNumberInfoText.text forKey:@"user_mobile"];
    [params setObject:per forKey:@"order_man"];
    [params setObject:[NSString stringWithFormat:@"%@", timeModel.time] forKey:@"order_time"];
    [params setObject:seatModel.seat_id forKey:@"seat_id"];
    [params setObject:seatModel.seat_name forKey:@"seat_name"];
    [params setObject:_genderView.genderStringValueOfChecked forKey:@"user_gender"];
    [params setObject:[NSString stringWithFormat:@"%d",SeatOrderType] forKey:@"order_type"];
    
    if (![NSString isBlankString:_remarkTextField.text]) {
        [params setObject:_remarkTextField.text forKey:@"content"];
    }
    
    [BookSeatRequest requestWithParameters:params withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request) {
         if (request.isSuccess) {
             [BDKNotifyHUD showSmileyHUDInView:self.view text:@"已提交 等待商家确认" completion:
              ^{
//                  OrderVC *orderListVC = [[OrderVC alloc] init];
                  //订座 跳 OrderVC 列表页面
                  [self popFromViewControllerToRootViewControllerWithTabBarIndex:kTabbarIndex1 animation:YES];
                  //刷新订单列表
                  [self postNotificaitonName:kRefreshOrdersListNotification];
            }];
         } else {
             _submitOrderButton.enabled = YES;
             NSString *msg = request.resultDic[@"msg"];
             [BDKNotifyHUD showCryingHUDInView:self.view text:[NSString isBlankString:msg] ? @"下单失败，请重试" : msg];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request) {
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"下单失败 请重试"];
         _submitOrderButton.enabled = YES;
     }];
}


#pragma mark 限制备输入输入长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _nameInfoText) {
        if (range.length == 1) {
            return YES;
        }else if ([string isEqualToString:@" "]){
            return NO;
        }
        return textFieldCanChange;
    }
    
    if (range.location >= 30)
        return NO;
    return YES;
}

#pragma mark - NSNotification

- (void)fieldTextChanged:(NSNotification *)notification {
    if (_nameInfoText.text.length >= 8) {
        _nameInfoText.text = [_nameInfoText.text substringWithRange:NSMakeRange(0,8)];
        textFieldCanChange = NO;
    } else {
        textFieldCanChange = YES;
    }
}

@end