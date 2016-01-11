//
//  SetAddressVC.m
//  HDHLProject
//
//  Created by liu on 15/8/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SetAddressVC.h"
#import "CityListVC.h"

static NSString *cityString ;

@interface SetAddressVC ()<UITextFieldDelegate,CityDelegate>

@property (nonatomic,strong) CityListVC *cityListVC;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UILabel *setAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTextFeild;
@property (weak, nonatomic) IBOutlet FrameViewWB *positionView;
@property (nonatomic,strong) UIImageView *dropDownView;
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic,assign) BOOL showCityView;
@end

#define MySearchView_MaxTextCount 9
#define MySearchView_TitleFont     [UIFont boldSystemFontOfSize:19.0f]//标题的字体大小
#define MySearchView_TitleLabel_Frame CGRectMake(7 ,15, detailSize.width, 14) //标题的frame
#define MySearchView_DropDownView_Frame CGRectMake(detailSize.width, 7, 30, 30)//三角图标
#define MySearchView_TitleBtn_Frame CGRectMake(0, 0, self.titleView.width, 44)//标题按钮
#define MySearchView_dropDownView_Width 30   //三角图标宽度
#define MySearchView_Title_Height 44.0f   //view的高度
#define MySearchView_ImageView_Frame CGRectMake(7, 0, 15,15)
#define MySearchView_LeftView_Frame CGRectMake(0, 0, 30, 15)

#define CityViewTag  888
@implementation SetAddressVC

- (void)configViewController
{
    [super configViewController];
    [self setColors];
    [self creatTitleView];
    [self adjustSearchView];
    self.showCityView =NO ;
}
- (void)setColors{
    self.searchView.backgroundColor = HomeColorForHexKey(AppColor_Home_NavBg1);
    [self.searchBtn setTitleColor:HomeColorForHexKey(AppColor_Home_NavBg1) forState:UIControlStateNormal];
    [self.setAddressLabel setTextColor:HomeColorForHexKey(AppColor_Home_NavBg1)];
}
- (void)creatTitleView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:MySearchView_ImageView_Frame];
    imageView.image = [UIImage imageNamed:@"home_search_gay.png"];
    UIView *leftView = [[UIView alloc]initWithFrame:MySearchView_LeftView_Frame];
    [leftView addSubview:imageView];
    
    self.searchTextFeild.leftView = leftView;
    self.searchTextFeild.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextFeild.delegate =self ;
    self.searchTextFeild.returnKeyType = UIReturnKeyDone;
}
- (void)adjustSearchView
{
    if(self.titleView){
        [self.titleView removeAllSubviews];
        [self.titleView removeFromSuperview];
        self.titleView = nil ;
    }
    if(![cityString length]){
        cityString  =@"北京";
    }
    [self.navigationBarView setNavBarTitleViewHide];
     NSString * lengthString = [cityString length]>=MySearchView_MaxTextCount?[cityString substringToIndex:MySearchView_MaxTextCount-1]: cityString;
    CGSize detailSize = [lengthString sizeWithFont:MySearchView_TitleFont constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat titleViewWidth =detailSize.width+MySearchView_dropDownView_Width;
    self.titleView= [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- titleViewWidth)/2, 20,  titleViewWidth, MySearchView_Title_Height)];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = MySearchView_TitleLabel_Frame;
    label.text = cityString;
    label.font = MySearchView_TitleFont;
    label.textColor= [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:label];
    
    self.dropDownView = [[UIImageView alloc]init];
     self.dropDownView.image= [UIImage imageNamed:@"home_triangle.png"];
     self.dropDownView.frame = MySearchView_DropDownView_Frame;
    [self.titleView addSubview: self.dropDownView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = MySearchView_TitleBtn_Frame;
    [button addTarget:self action:@selector(navigationBarCenterBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:button];
    
    [self.navigationBarView addSubview:self.titleView];
    self.titleView.centerX = self.navigationBarView.centerX;
    [self.navigationBarView bringSubviewToFront:self.titleView];
}

#pragma mark - 定位自己的位置 -
- (IBAction)StartPosition:(UIButton *)sender
{
        if(self.adressBlock )
        {
            self.adressBlock(@"startLocaitonAgin",@"");
        }
     [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)searchBtnClick:(UIButton *)sender
{
    if([NSString isBlankString:self.searchTextFeild.text])
    {
        return;
    }
    NSString *addressString = self.searchTextFeild.text ;
    self.adressBlock(addressString,cityString);
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([NSString isBlankString:self.searchTextFeild.text])
    {
        return NO;
    }
    self.adressBlock(textField.text,cityString);
    [self.navigationController popViewControllerAnimated:YES];
    return  YES ;
}
#pragma mark - 选择城市 -
- (void)navigationBarCenterBtnClick
{
    if(!self.cityListVC){
        self.cityListVC = [[CityListVC alloc]init];
        self.cityListVC.cityDelegate = self ;
        [self addChildViewController:self.cityListVC];
        UIView *contentView = [[self.cityListVC.view subviews] lastObject];
        contentView.top= 0;
        contentView.tag =CityViewTag;
        [self.contentView addSubview:contentView];
    }
    [self.searchTextFeild resignFirstResponder];
    UIView *contentView = [self.view viewWithTag:CityViewTag];
    if(!self.showCityView)
    {
        contentView.hidden = NO;
        self.dropDownView.image = [UIImage imageNamed:@"home_triangle_shang.png"];
    }else{
        contentView.hidden = YES;
        self.dropDownView.image = [UIImage imageNamed:@"home_triangle.png"];
    }
    self.showCityView = !self.showCityView;
}

#pragma  mark - 城市选择后的代理 -

- (void)citySelectedAction:(NSString *)cityNameString
{
    cityString = cityNameString;
    [self navigationBarCenterBtnClick];
    [self adjustSearchView];
}


@end
