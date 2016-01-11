//
//  BetterTableCell.m
//  KunshanTalent
//
//  Created by ligh on 13-9-23.
//
//

#import "BetterTableCell.h"


@implementation BetterTableCell


@synthesize cellData = _cellData;

- (void)dealloc
{
    RELEASE_SAFELY(_cellData);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
//        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        UIView *selectedBackgroundView = [[UIView alloc] init];
        [selectedBackgroundView setBackgroundColor:UIColorFromRGB(233, 233, 233)];
        self.selectedBackgroundView = selectedBackgroundView;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UIView * subview = [[UIView alloc] init];
    subview.userInteractionEnabled = NO;// 不设为NO会屏蔽cell的点击事件
    subview.backgroundColor = [UIColor clearColor];// 设为透明从而使得cell.backgroundColor有效.
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:subview];// cell.contentView是个readonly属性,所以别想着替换contentView了.
    
   // [self disableSelectedBackgroundView];
    
}

- (void)disableSelectedBackgroundView
{
    
    UIView *tempView = [[UIView alloc] init];
    [self setBackgroundView:tempView];
    [self setBackgroundColor:[UIColor clearColor]];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  data
///////////////////////////////////////////////////////////////////////////////
- (void)setCellData:(id)cellData
{
    if(_cellData  != cellData)
    {
        RELEASE_SAFELY(_cellData);
        
        _cellData = cellData;
    
    }
    
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark  view
///////////////////////////////////////////////////////////////////////////////
+ (id)cellFromXIB
{
    id  cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])owner:self options:nil] objectAtIndex:0];
    
    return cell;
}

+ (NSString *)cellIdentifier
{
    return  NSStringFromClass([self class]);
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark  UITextViewDelegate
///////////////////////////////////////////////////////////////////////////////
/******
 尼玛？坑爹的UITextView  UITextViewTextDidBeginEditingNotification通知不会自动发送，
 不知道什么原因，暂时想到的方法只能手动发送。 以为UITextViewTextDidBeginEditingNotification通知会被BaseVieController 接收到，记录下来正在便捷的UITextField或者UITextView 然后键盘弹起时根据记录的View 计算拖动的偏移量。NND这货居然不会发送此通知。。。。。
 **/
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"sss");
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidBeginEditingNotification object:textView];
    return YES;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  ViewActions
/////////////////////////////////////////////////////////////////////////////
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidEndEditingNotification object:textView];
        return NO;
    }
    
    return YES;
}
//设置数据源用
- (void)configerWithDataSource:(id)objectData
{

}
@end
