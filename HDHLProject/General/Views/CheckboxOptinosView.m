//
//  CheckboxOptinosView.m
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "CheckboxOptinosView.h"

@interface CheckboxOptinosView()
{
    //显示标题的button
    IBOutlet UIButton       *_titleButton;
    //选中按钮
    IBOutlet UIButton       *_checkboxButton;
    
}
@end

@implementation CheckboxOptinosView

- (void)dealloc
{
    RELEASE_SAFELY(_selectedBlock);
    
    RELEASE_SAFELY(_titleButton);
    RELEASE_SAFELY(_checkboxButton);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [_titleButton setTitleColor:ColorForHexKey(AppColor_Select_Box_Text4) forState:UIControlStateNormal];
}

-(UIButton *)checkboxButton
{
    return _checkboxButton;
}

-(UIButton *)titleButton
{
    return _titleButton;
}

-(void)setOptionsModel:(OptionsModel *)optionsModel
{
    if (optionsModel != _optionsModel)
    {
        RELEASE_SAFELY(_optionsModel);
        _optionsModel = optionsModel ;
    }
    
    [_titleButton setTitle:optionsModel.title forState:UIControlStateNormal];
    _checkboxButton.selected = optionsModel.checked;
    
    
}


-(BOOL)checked
{
    return _checkboxButton.selected;
}

-(void)setChecked:(BOOL)checked
{
    _checkboxButton.selected = checked;
}

- (IBAction)clickAction:(id)sender
{
    if (_selectedBlock)
    {
        _selectedBlock(self);
    }
}

@end
