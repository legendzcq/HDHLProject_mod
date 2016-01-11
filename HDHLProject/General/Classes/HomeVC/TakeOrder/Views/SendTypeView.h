//
//  OrderSendTypeView.h
//  Carte
//
//  Created by ligh on 14-7-24.
//
//

#import "XibView.h"

typedef void(^SendTypeDismissBlock)(void);

@protocol SendTypeViewDelegate;


@interface SendTypeView : XibView

@property (assign,nonatomic) id<SendTypeViewDelegate> delegate;

@property (copy,nonatomic) SendTypeDismissBlock block;

-(void) showInView:(UIView *) inView atPoint:(CGPoint) point;
-(void) dismiss;
-(void) selectSendType:(SendType) sendType;

@end

@protocol SendTypeViewDelegate <NSObject>

-(void) selectedSendType:(SendType) type;

@end
