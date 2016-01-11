//
//  ExpandFrameView.h
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "FrameView.h"
#define Default_Height 48

@protocol ExpandFrameViewDeleagte;

@interface ExpandFrameView : FrameView

@property (retain,nonatomic) IBOutlet UIButton *arrowButton;
@property (retain,nonatomic) IBOutlet UIButton *headerTitleButton;

@property (assign,nonatomic) IBOutlet id<ExpandFrameViewDeleagte> layoutDelegate;

@property (nonatomic,assign) BOOL opened;

//切换显示w
-(IBAction) switchShow;
-(void) layoutSuperView;
-(float) allSubViewHeight;


//展开
-(void)openup:(BOOL) animation;
-(void) openup;
//闭合
-(void) close;

@end

@protocol ExpandFrameViewDeleagte <NSObject>
//返回view 距离顶部view的距离
-(float) expandFrameView:(ExpandFrameView *) expandFrameView topMarginOfView:(UIView *) view;
@end
