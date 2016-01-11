//
//  SetPersonBirthVC.m
//  Carte
//
//  Created by zln on 14/12/12.
//
//

#import "SetPersonBirthVC.h"
#import "PickerRowView.h"
#import "SetPersonBirthRequest.h"

@interface SetPersonBirthVC ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UIPickerView *_datePickerView;
    
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    
    //当前时间
    NSString *_currentYear;
    NSString *_currentMonth;
    NSString *_currentDay;
}

@end

@implementation SetPersonBirthVC

- (void)dealloc
{
    RELEASE_SAFELY(_datePickerView);
    RELEASE_SAFELY(yearArray);
    RELEASE_SAFELY(monthArray);
    RELEASE_SAFELY(dayArray);
}

- (void)viewDidUnload
{
    RELEASE_SAFELY(_datePickerView);
    RELEASE_SAFELY(yearArray);
    RELEASE_SAFELY(monthArray);
    RELEASE_SAFELY(dayArray);
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBarView setNavigationBarTitle:@"生日"];
    [self setRightNavigationBarButtonStyle:UIButtonStyleISSave];
    self.navigationBarView.rightBarButton.hidden = NO;

    _datePickerView.delegate = self;
    _datePickerView.dataSource = self;
    _datePickerView.height = 250;
    
    yearArray = [[NSMutableArray alloc] init];
    monthArray = [[NSMutableArray alloc] init];
    dayArray = [[NSMutableArray alloc] init];
    
    //填充数据
    [self createDataSource];
    
    //刷新数据
    [_datePickerView reloadAllComponents];
    
    //默认显示
    [_datePickerView selectRow:yearArray.count/2 inComponent:0 animated:NO];
}


- (void)actionClickNavigationBarRightButton
{
    [self sendRequestOfModifyBirthDay];
}

#pragma  mark - ------UIPickerViewDelegate-----

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) { //日期
        return yearArray.count;
        
    } else if(component == 1) {
        return monthArray.count;
        
    } else {
        NSInteger row0 = [pickerView selectedRowInComponent:0];
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        [self createMonthArrayWithYear:yearArray[row0] month:monthArray[row1]];
        return dayArray.count;
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 92;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *title = nil;
    
    if (component == 0) {
        title = yearArray[row];
    } else if (component == 1) {
        title = monthArray[row];
    } else {
        NSInteger row0 = [pickerView selectedRowInComponent:0];
        NSInteger row1 = [pickerView selectedRowInComponent:1];
        [self createMonthArrayWithYear:yearArray[row0] month:monthArray[row1]];
        title = dayArray[row];
    }
    PickerRowView *rowView = [PickerRowView viewFromXIB];
    [rowView setTitle:title];
    
    return rowView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 1) {
        [_datePickerView reloadComponent:2];
    }
}

#pragma mark - 年月日闰年＝情况分析
/**
 * 创建数据源
 */
- (void)createDataSource
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSArray *currentArray = [currentTime componentsSeparatedByString:@"-"];
    if (currentArray.count != 3) {
        return ;
    }
    
    // 年
    _currentYear = (NSString *)currentArray[0];
    [yearArray removeAllObjects];
    for (int y = 1950; y <= _currentYear.intValue - 1; y++) {
        
        [yearArray addObject:[NSString stringWithFormat:@"%d",y]];
    }
    
    // 月
    _currentMonth = (NSString *)currentArray[1];
    [monthArray removeAllObjects];
    for (int m = 1; m <= 12; m++) {
        
        NSString *mon;
        
        if (m < 10) {
            
            mon = [NSString stringWithFormat:@"0%d",m];
            
        } else {
            
            mon = [NSString stringWithFormat:@"%d",m];
        }
        [monthArray addObject:mon];
    }
    
    // 日（当前日期）
    [self createMonthArrayWithYear:_currentYear month:_currentMonth];
    
}

#pragma mark -

- (void)createMonthArrayWithYear:(NSString *)yearInt month:(NSString *)monthInt
{
    int endDate = 0;
    switch (monthInt.intValue) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            endDate = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            endDate = 30;
            break;
        case 2:
            // 是否为闰年
            if (yearInt.intValue % 400 == 0) {
                endDate = 29;
            } else {
                if (yearInt.intValue % 100 != 0 && yearInt.intValue %4 ==4) {
                    endDate = 29;
                } else {
                    endDate = 28;
                }
            }
            break;
        default:
            break;
    }
    
    // 日
    [dayArray removeAllObjects];
    for(int d = 1; d <= endDate; d++){
        NSString *day;
        if (d < 10) {
            day = [NSString stringWithFormat:@"0%d",d];
        } else {
            day = [NSString stringWithFormat:@"%d",d];;
        }
        [dayArray addObject:day];
    }
}


//发送修改用户昵称请求
-(void) sendRequestOfModifyBirthDay

{
    
    NSInteger row0 = [_datePickerView selectedRowInComponent:0];
    NSInteger row1 = [_datePickerView selectedRowInComponent:1];
    NSInteger row2 = [_datePickerView selectedRowInComponent:2];
    
    NSString *birthDay = [NSString stringWithFormat:@"%@%@%@",yearArray[row0],monthArray[row1],dayArray[row2]];
    
    [SetPersonBirthRequest requestWithParameters:@{@"user_id":[AccountHelper uid],@"birthday":birthDay}
                               withIndicatorView:self.view onRequestFinished:^(ITTBaseDataRequest *request)
     {
         if (request.isSuccess)
         {
             
             [BDKNotifyHUD showSmileyHUDInView:self.view text:@"保存成功"];
             
             UserModel *userInfo = [AccountHelper userInfo];
             userInfo.birthday = birthDay;
             [AccountHelper saveUserInfo:userInfo];
             [self.navigationController popViewControllerAnimated:YES];
             
             
         }else
         {
             if (request.isNoLogin) {
                 return ;
             }
             [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败"];
         }
         
     } onRequestFailed:^(ITTBaseDataRequest *request)
     {
         [BDKNotifyHUD showCryingHUDInView:self.view text:@"保存失败"];
     }];
     
     
}

@end
