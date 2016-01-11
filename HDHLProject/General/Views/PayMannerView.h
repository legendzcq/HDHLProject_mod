//
//  PayMannerView.h
//  Carte
//
//  Created by hdcai on 15/4/15.
//
//

#import "XibView.h"
#import "PayMannerView.h"
#import "OptionsModel.h"

/**
 *  支付方式view
 */

typedef void (^MySelectBlcok)(id obj);

@interface PayMannerView : XibView

@property (retain,nonatomic) OptionsModel *optionsModel;

@property (nonatomic,copy)MySelectBlcok selectBlock;

+ (void)showInView:(UIView *)fatherView WithModelArray:(NSArray *)array WithSelectedBlock:(MySelectBlcok)selectBlock;


@end
