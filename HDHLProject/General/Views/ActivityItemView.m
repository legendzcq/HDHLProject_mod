//
//  ActivityItemView.m
//  Carte
//
//  Created by ligh on 14-9-15.
//
//

#import "ActivityItemView.h"
#import "ActivityNotesView.h"

@interface ActivityItemView()
{
    IBOutlet UIButton   *_checkboxButton;
    IBOutlet UILabel    *_gifsLabel;
    IBOutlet UILabel    *_activityNameLabel;
    IBOutlet UIButton   *_activityNoteTitleButton;
}
@end

@implementation ActivityItemView


- (void)dealloc
{
    _delegate = nil;
    RELEASE_SAFELY(_checkboxButton);
    RELEASE_SAFELY(_gifsLabel);
    RELEASE_SAFELY(_activityNameLabel);
    RELEASE_SAFELY(_activityNoteTitleButton);
}


-(void)awakeFromNib
{
    [super awakeFromNib];
        
    _enable = YES;
}

-(void)setActivityModel:(ActivityModel *)activityModel
{
    if (_activityModel != activityModel)
    {
        RELEASE_SAFELY(_activityModel);
        _activityModel =  activityModel ;
        _gifsLabel.text = [NSString stringWithFormat:@"赠品:%@",_activityModel.activity_rel];
        _activityNameLabel.text = _activityModel.activity_title;
        
        if ([NSString isBlankString:_activityModel.gifts])
        {
            self.height = 40;
            
        }else
        {
            float giftsContentHeight = [_activityModel.gifts heightWithFont:_gifsLabel.font boundingRectWithSize:CGSizeMake(_gifsLabel.width, MAXFLOAT)];
            _gifsLabel.height = giftsContentHeight + 20;
            self.height = _gifsLabel.top +  _gifsLabel.height + MARGIN_L;
            
        }
        
    }
}

#pragma mark Actions
- (IBAction)didSelectedAction:(id)sender
{
    if (_enable)
    {
        _checkboxButton.selected =  !_checkboxButton.selected;
        
        [_delegate didSelectedActivityItemView:self];

    }else
    {
        [_delegate didSelectedActivityItemView:self];
    }
}


-(void)setEnable:(BOOL)enable
{
    _enable = enable;
    if (!enable)
    {
        _checkboxButton.selected = NO;
    }
}


-(void)setSelected:(BOOL)selected
{
    _checkboxButton.selected = selected;
}

-(BOOL)selected
{
    return _checkboxButton.selected;
}

- (IBAction)showActivityNotesView:(id)sender
{
    [[ActivityNotesView viewFromXIB] showInWindowWithText:_activityModel.activity_desc];
}


@end
