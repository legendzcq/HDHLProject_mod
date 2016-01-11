//
//  InvoiceCheckView.h
//  Carte
//
//  Created by ligh on 15-1-11.
//
//

#import "ExpandFrameView.h"

#define InvoiceTag_NONE  0 //不要发票
#define InvoiceTag_HAVE  1 //普通发票

@protocol InvoiceCheckDelegate <NSObject>
- (void)invoiceCheckValue:(NSInteger)selIndex;
@end

@interface InvoiceCheckView : ExpandFrameView

@property (nonatomic, assign) id <InvoiceCheckDelegate> delegate;
- (NSString *)invoiceCheckValue;
- (BOOL)isHaveInvoice;
- (NSString *)invoiceCheckTitle; //发票抬头信息

- (void)showBottomLine; //强制显示top bottom分割线
- (void)hiddBottomLine;

@end
