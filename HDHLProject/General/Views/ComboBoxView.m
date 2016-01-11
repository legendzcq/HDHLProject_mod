//
//  ComboBoxView.m
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "ComboBoxView.h"
#import "CheckboxOptinosView.h"



@interface ComboBoxView()
{

    ComboxHeaderView    *_comboxHeaderView;

}
@end

@implementation ComboBoxView

- (void)dealloc
{
    RELEASE_SAFELY(_comboxHeaderView);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
 
    self.showSelectedModelOnDropdown = YES;
    
    _comboxHeaderView = [ComboxHeaderView viewFromXIB] ;
    [self addSubview:_comboxHeaderView];
    
    [self close];
    
     self.arrowButton = _comboxHeaderView.arrowButton;
    [_comboxHeaderView.actionButton addTarget:self action:@selector(switchShow) forControlEvents:UIControlEventTouchUpInside];
}

-(ComboxHeaderView *)comboxHeaderView
{
    return _comboxHeaderView;
}

-(void)setHeaderName:(NSString *)headerName
{
    _comboxHeaderView.nameLabel.text = headerName;
}

-(void)setHeaderTitle:(NSString *)title
{
    _comboxHeaderView.titleLabel.text = title;
}

-(void)setSelectedOptionsMoel:(OptionsModel *)selectedOptionsMoel
{
    if (selectedOptionsMoel != _selectedOptionsMoel)
    {
        RELEASE_SAFELY(_selectedOptionsMoel);
        _selectedOptionsMoel = selectedOptionsMoel ;
    }

    _comboxHeaderView.titleLabel.text = selectedOptionsMoel.title;
    
    //选中一个后反选其他选项
    for (OptionsModel *optionsModel  in _optionsModelArray)
    {
        optionsModel.checked = optionsModel == selectedOptionsMoel;
        
        if (_comboBoxViewDelegate  && [_comboBoxViewDelegate respondsToSelector:@selector(comboBoxView:didSelectedOptionsModel:)] && optionsModel.checked)
        {
            [_comboBoxViewDelegate comboBoxView:self didSelectedOptionsModel:optionsModel];
        }
    }
}

-(NSArray *) selectedOptionsModelArray
{
    NSMutableArray *selectedOptionsModelArray = [NSMutableArray array];
    
    for (OptionsModel *optionsMoel in _optionsModelArray)
    {
        if (optionsMoel.checked)
        {
            [selectedOptionsModelArray addObject:optionsMoel];
        }
    }
    
    return selectedOptionsModelArray;
}

-(void) removeAllOptionsView
{
        [self removeAllSubviews];
       [self addSubview:_comboxHeaderView];
}

-(void)reload
{
    [self removeAllOptionsView];
    
    float y = _comboxHeaderView.bottom;
    
    for (OptionsModel *optionsModel  in _optionsModelArray)
    {
        
        if (self.selectedOptionsMoel)
        {
            optionsModel.checked = self.selectedOptionsMoel.actionTag == optionsModel.actionTag;
        }
        
        if (optionsModel == self.selectedOptionsMoel)
        {
            
            [self setSelectedOptionsMoel:optionsModel];
            
            if (_showSelectedModelOnDropdown)
            {
             
                CheckboxOptinosView *checkBoxView = [self checboxViewForOptionsModel:optionsModel];
                [checkBoxView setOptionsModel:optionsModel];

                [checkBoxView setSelectedBlock:^(CheckboxOptinosView *view)
                {
                    
                    [self didSelectedCheckboxOptionsView:view];
                    
                }];
                
                checkBoxView.top = y;
                y = checkBoxView.bottom;
                
                [self addSubview:checkBoxView];
            }
            
        }else
        {
            CheckboxOptinosView *checkBoxView = [self checboxViewForOptionsModel:optionsModel];

            [checkBoxView setSelectedBlock:^(CheckboxOptinosView *view){
                
                [self didSelectedCheckboxOptionsView:view];
                
            }];
            checkBoxView.top = y;
            y = checkBoxView.bottom;
            
            [self addSubview:checkBoxView];
        }
        
    }
}

-(void)didSelectedCheckboxOptionsView:(CheckboxOptinosView *)optionsView
{
    [self setSelectedOptionsMoel:optionsView.optionsModel];
    [self close];
}

-(void)close
{
    [super close];
    if (_comboBoxViewDelegate && [_comboBoxViewDelegate respondsToSelector:@selector(comboBoxViewDidDismiss:)])
    {
        [_comboBoxViewDelegate comboBoxViewDidDismiss:self];
    }
}

//返回默认选项 view
-(CheckboxOptinosView *)checboxViewForOptionsModel:(OptionsModel *)optionsModel
{
    CheckboxOptinosView *optionsView = [CheckboxOptinosView viewFromXIB];
    [optionsView setOptionsModel:optionsModel];
    return optionsView;
}

-(void)openup
{
    [self reload];
    
    [super openup];
}

@end
