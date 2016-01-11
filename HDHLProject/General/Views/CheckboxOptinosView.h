//
//  CheckboxOptinosView.h
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "XibView.h"

#import "OptionsModel.h"

@class CheckboxOptinosView;


typedef void(^CheckboxOptionsViewSelectedBlock)(CheckboxOptinosView *);

/**
 * 下拉框默认view
 */
@interface CheckboxOptinosView : XibView


@property (retain,nonatomic) OptionsModel *optionsModel;
@property (copy,nonatomic) CheckboxOptionsViewSelectedBlock selectedBlock;

-(UIButton *) checkboxButton;
-(UIButton *) titleButton;

@end
