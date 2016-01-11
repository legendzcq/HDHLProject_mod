//
//  BrandActivityView.m
//  Carte
//
//  Created by hdcai on 15/4/20.
//
//

#import "BrandActivityView.h"
#import "StoreModel.h"
#import "ExpandFrameView.h"
#import "RTLabel.h"
#import "WebVC.h"


#define BGVIEW_HIGHT 48.0
#define LEFT_WIDTH   10

@implementation BrandActivityView

{
    NSArray * _dataArray;
    int sectionOpened[99];
    CGFloat contentViewSize;
    NSMutableDictionary *_cells;
    BOOL firstLoadWebView;
    CGFloat mCellHeight;
}

-(void)dealloc
{
    RELEASE_SAFELY(_mTableView);
    _dataArray = nil;
    _cells = nil;
}

- (void)awakeFromNib
{
    //    self.backgroundColor = AddStore_BackGroudColor;
    //    self.storeView.layer.masksToBounds = YES ;
    //    self.storeView.layer.cornerRadius = AddStore_CornerRadius;
    //    titleLabel.textColor = ColorForHexKey(AppColor_About_Share_Text);
    //    FrameLineView *lineLabel = [[FrameLineView alloc]initWithFrame:AddStore_LineFrame];
    //    lineLabel.backgroundColor =  ColorForHexKey(AppColor_AddDishCard_line);
    //    [self. storeView addSubview:lineLabel];
    
}




+ (void)showInView:(UIView *)fatherView WithModelArray:(NSArray *)array WithDelegate:(UIViewController *)viewController
{
    BrandActivityView *BAView = [BrandActivityView viewFromXIB];
    BAView.userInteractionEnabled  = YES ;
    BAView.delegate = (id)viewController;
//    BAView.width = fatherView.width;
    [BAView creatTableViewWithArray:array InView:fatherView];
    [fatherView addSubview:BAView];
}

-(void)creatTableViewWithArray:(NSArray *)array InView:(UIView*)fatherView
{
    _cells = [[NSMutableDictionary alloc]init];
    firstLoadWebView = YES;
    for (int i = 0; i<array.count; i++) {
        sectionOpened[i] = 0;
    }
    self.width = fatherView.width;
    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, BGVIEW_HIGHT * array.count +20)style:UITableViewStylePlain];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    self.mTableView.scrollEnabled = NO;
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.mTableView.userInteractionEnabled = YES;
    [self addSubview:self.mTableView];
    _dataArray = [[NSArray arrayWithArray:array]copy];
    
    fatherView.size = CGSizeMake(self.width, self.mTableView.frame.size.height + 30);
    
}


#pragma tableviewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sectionOpened[section] == 0 ? 0:1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

#pragma tableviewdelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *mCell = [tableView dequeueReusableCellWithIdentifier:@"mCell"];
//    if (!mCell) {
    UITableViewCell *mCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mCell"];
    mCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
   UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(LEFT_WIDTH*2, 0, self.width-LEFT_WIDTH*4, 45)];
    NSString * text = nil;
    if ([[[_dataArray objectAtIndex:indexPath.section] objectForKey:@"activity_desc"] isKindOfClass:[NSNull class]])
    {
        text = kDefaultActivityContent;
    }else{
        text = [[_dataArray objectAtIndex:indexPath.section]objectForKey:@"activity_desc"];
    }
    if ([NSString isBlankString:text]) {
        text = kDefaultActivityContent;
    }
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.delegate = self;
    webView.tag = indexPath.section;
    //禁止UIWebView拖动
    [webView.scrollView setScrollEnabled:NO];
    [webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_cells setObject:mCell forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    [webView setScalesPageToFit:NO];
    [webView loadHTMLString:text baseURL:nil];
    [mCell addSubview:webView];
    mCell.frame = CGRectMake(0, 0, self.width, webView.frame.size.height + 10);
    return mCell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, BGVIEW_HIGHT)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    UIImageView * leftImageV = [[UIImageView alloc]initWithFrame:CGRectMake(LEFT_WIDTH, LEFT_WIDTH+4, 20, 20)];
    leftImageV.image = [UIImage imageNamed:@"public_icon10"];
    [bgView addSubview:leftImageV];
    UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, self.width - 80, 20)];
    if (![NSString isBlankString:[[_dataArray objectAtIndex:section]objectForKey:@"activity_title"]]) {
        titleLbl.text = [[_dataArray objectAtIndex:section]objectForKey:@"activity_title"];
    }
    titleLbl.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:titleLbl];
    UIImageView * rightImageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.width -15 -17, 20, 15, 9)];
    if (sectionOpened[section] == 0) {
        rightImageV.image = nil;
        [rightImageV setImage:[UIImage imageNamed:@"public_arrow_down"]];
    }else{
        rightImageV.image = nil;
        [rightImageV setImage:[UIImage imageNamed:@"public_arrow_up"]];
    }
    [bgView addSubview:rightImageV];
    bgView.tag = section;
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTapClick:)];
    
    [bgView addGestureRecognizer:tapGestureR];
    if (section == 0) {
        UILabel *lineLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        lineLbl.backgroundColor = ColorForHexKey(AppColor_Second_Level_Title2);
        [bgView addSubview:lineLbl];
    }else{
        UILabel *lineLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, self.width-15, 0.5)];
        lineLbl.backgroundColor = ColorForHexKey(AppColor_Second_Level_Title2);
        [bgView addSubview:lineLbl];

    }
    if (section == _dataArray.count -1) {
        UILabel *lineLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-0.5, self.width, 0.5)];
        lineLbl.backgroundColor = ColorForHexKey(AppColor_Second_Level_Title2);
        [bgView addSubview:lineLbl];
        if (!sectionOpened[_dataArray.count -1]) {
            lineLbl.hidden = NO;
        }else{
            lineLbl.hidden = YES;
        }
    }
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BGVIEW_HIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return mCellHeight;
    
}

//点击事件

-(void)bgViewTapClick:(UITapGestureRecognizer*)tap
{
    firstLoadWebView = YES;
    for (int i=0; i<_dataArray.count; i++) {
        if (i != tap.view.tag) {
            sectionOpened[i] = 0;
        }
    }
    if ([[[_dataArray objectAtIndex:tap.view.tag] objectForKey:@"activity_desc"] isKindOfClass:[NSNull class]]) {
        return;
    }
    sectionOpened[tap.view.tag] =! sectionOpened[tap.view.tag];
    if (!sectionOpened[tap.view.tag]) {
        self.mTableView.frame = CGRectMake(0, 0, self.width, _dataArray.count*BGVIEW_HIGHT+20) ;
        [self.delegate changeBrandActivitySuperViewFrameWithFloat: _dataArray.count *BGVIEW_HIGHT+20];

    }
    [self.mTableView reloadData];

}
#pragma webviewDelegate

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    webView.delegate = nil;
    
    webView.height = webView.scrollView.contentSize.height;

    UITableViewCell *cell =[_cells objectForKey:[NSString stringWithFormat:@"%ld",(long)webView.tag]];
    cell.contentView.height = webView.height;
    [cell setNeedsLayout];
    
    if(firstLoadWebView){
        mCellHeight = webView.height;
        if (![self.mTableView hasAmbiguousLayout]) {
            [self.mTableView reloadData];
        }
        firstLoadWebView = NO;
    }
    if (webView.tag == _dataArray.count -1) {
        UILabel *lineLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, webView.frame.size.height - 0.5, self.width, 0.5)];
        lineLbl.backgroundColor = ColorForHexKey(AppColor_Second_Level_Title2);
        [cell.contentView addSubview:lineLbl];
    }
    webView  = nil;
    self.mTableView.frame = CGRectMake(0, 0, self.width, _dataArray.count*BGVIEW_HIGHT + mCellHeight +20) ;
    [self.delegate changeBrandActivitySuperViewFrameWithFloat:mCellHeight + _dataArray.count *BGVIEW_HIGHT+20];
}


@end
