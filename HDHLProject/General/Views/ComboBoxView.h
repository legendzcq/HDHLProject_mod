//
//  ComboBoxView.h
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "ExpandFrameView.h"
#import "CheckboxOptinosView.h"
#import "OptionsModel.h"
#import "ComboxHeaderView.h"

@protocol ComboBoxViewDelegate;


/**
 *  下拉框
 */
@interface ComboBoxView : ExpandFrameView

@property (assign,nonatomic) IBOutlet id<ComboBoxViewDelegate> comboBoxViewDelegate;

//所有选项
@property (retain,nonatomic) NSArray        *optionsModelArray;
@property (assign,nonatomic) OptionsModel   *selectedOptionsMoel; //选中项

//获取选中项
@property (assign,nonatomic) NSArray        *selectedOptionsModelArray;
//下拉里面是否显示已经选中的项 默认不显示
@property (assign,nonatomic) BOOL           showSelectedModelOnDropdown;

-(ComboxHeaderView *) comboxHeaderView;

//重新加载数据
-(void) reload;

//返回对应Model 的选项view 子类可以自由定义   默认返回带有选中按钮的checkbox view
-(CheckboxOptinosView *) checboxViewForOptionsModel:(OptionsModel *) optionsModel;
-(void) setHeaderTitle:(NSString *) title;
-(void) setHeaderName:(NSString *)headerName;

-(void) didSelectedCheckboxOptionsView:(CheckboxOptinosView *) optionsView;
-(void) removeAllOptionsView;


@end

@protocol ComboBoxViewDelegate <NSObject>

-(void) comboBoxView:(ComboBoxView *) comboBoxView didSelectedOptionsModel:(OptionsModel *) optionsModel;
@optional
-(void) comboBoxViewDidDismiss:(ComboBoxView *) comboBoxView;

@end
