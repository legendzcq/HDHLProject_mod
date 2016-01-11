//
//  SlideEditCell.m
//  Travelbag
//
//  Created by ligh on 13-11-17.
//  Copyright (c) 2013年 partner. All rights reserved.
//

#import "SwipeEditCell.h"

#define KSwipeCellWillSwipeEditNotificaitonName @"SwipeCellWillSwipeEditNotificaitonName"


@interface SwipeEditCell()
{
    
    float           _swipeContentViewX;
    
    
}
@end

@implementation SwipeEditCell


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self enableSlideEdit];
    
    _swipeContentViewX = _swipeContentView.left;
    
    
    _swipeLeftEditView.hidden = YES;
    _swipeRightEditView.hidden = YES;
    _swipeEditEnable = YES;
    
    [_swipeLeftEditView addTarget:self action:@selector(didTapLeftEditView) forControlEvents:UIControlEventTouchUpInside];
    [_swipeRightEditView addTarget:self action:@selector(didTapRightEdithView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEditNotification:) name:KSwipeCellWillSwipeEditNotificaitonName object:nil];
}


-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    
    [self pullbackSwipeContentViewAnimationd:YES];
}

-(void) enableSlideEdit
{
    _swipeContentView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *swipGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipGestureRecognizer.delegate = self;
    [_swipeContentView addGestureRecognizer:swipGestureRecognizer];
}


-(void) willEditNotification:(NSNotification *) notification
{
    if(notification.object != self)
    {
        [self pullbackSwipeContentViewAnimationd:YES];
    }
}


/////////////////////////////////////////////////////////////////////////
#pragma mark EditView Actions
/////////////////////////////////////////////////////////////////////////
-(void)didTapLeftEditView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self pullbackSwipeContentViewAnimationd:NO];
        
    } completion:^(BOOL finished) {
        
        if (_delegate &&  [_delegate respondsToSelector:@selector(didSelectLeftEditViewOfCell:)])
        {
            [_delegate didSelectLeftEditViewOfCell:self];
        }
        
    }];
    
}


-(void) didTapRightEdithView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self pullbackSwipeContentViewAnimationd:NO];
        
    } completion:^(BOOL finished) {
        
        if (_delegate &&  [_delegate respondsToSelector:@selector(didSelectRightEditViewOfCell:)])
        {
            [_delegate didSelectRightEditViewOfCell:self];
        }
        
    }];
    
}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIGestureRecognizerDelegate
/////////////////////////////////////////////////////////////////////////
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (!self.swipeEditEnable)
    {
        return NO;
    }
    
    if ([gestureRecognizer respondsToSelector:@selector(translationInView:)])
    {
        
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        
        BOOL gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
        if(gestureVertical)
        {
            return NO;
        }
        
        
        if ((self.swipeContentView.left) < -5 || abs((int)self.swipeContentView.left) > 5)
        {
            return YES;
        }
        
        
        if(translation.x > 0 && !self.swipeLeftEditView)
        {
            return NO;
        }
        
        if (translation.x < 0 && !self.swipeRightEditView)
        {
            return NO;
        }
        
    }
    
    
    return YES;
}



+(BOOL) pullbackCellsForTableView:(UITableView *)tableView
{
    
    NSArray *cells =  [tableView visibleCells];
    __block BOOL result = NO;
    
    [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj class] isSubclassOfClass:[self class]])
        {
            SwipeEditCell *cell = obj;
            if (cell.swipeViewEditing)
            {
                [cell pullbackSwipeContentViewAnimationd:YES];
                result = YES;
            }
        }
    }];
    
    return result;
    
}

-(void)pullbackSwipeContentViewAnimationd:(BOOL)animation completion:(void (^)(void))completion
{
    
    _swipeViewEditing = NO;
    
    
    if (animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _swipeContentView.left = _swipeContentViewX;
            
        } completion:^(BOOL finished) {
            _swipeLeftEditView.hidden = YES;
            _swipeRightEditView.hidden = YES;
            if(completion)
            {
                completion();
            }
        }];
        
    }else
    {
        _swipeContentView.left = _swipeContentViewX;
        _swipeLeftEditView.hidden = YES;
        _swipeRightEditView.hidden = YES;
        if(completion)
        {
            completion();
        }
    }
    
}

-(void)pullbackSwipeContentViewAnimationd:(BOOL)animation
{
    
    [self pullbackSwipeContentViewAnimationd:animation completion:nil];
    
}


//当 当前View不是阅读模式时（当前view的left!=0) 监听Panview拖动事件
-(void) handlePanGesture:(UIPanGestureRecognizer *) recognizer
{
    
    CGPoint translation = [recognizer translationInView:self.superview];
    
    //    if (_swipeContentViewX == _swipeContentView.left)
    //    {
    //        //向右滑动
    //        if (translation.x > 0 && !_swipeLeftEditView)
    //        {
    //            return;
    //
    //        }else if(translation.x < 0 && !_swipeRightEditView)//向左滑动
    //        {
    //            return;
    //        }
    //    }
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KSwipeCellWillSwipeEditNotificaitonName object:self];
        
        //        CGPoint translation = [recognizer translationInView:self.superview];
        
    } else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        _swipeContentView.left += translation.x;
        [recognizer setTranslation:CGPointZero inView:self.superview];
        
        _swipeLeftEditView.hidden  = _swipeContentView.left < _swipeLeftEditView.left;
        _swipeRightEditView.hidden = _swipeContentView.left > _swipeLeftEditView.left;
        
        //右视图跟随移动设置
        if (_swipeContentView.left <= _swipeLeftEditView.left && _swipeContentView.left >= _swipeLeftEditView.left-_swipeRightEditView.width) {
            
            _swipeRightEditView.left = _swipeContentView.right;
            //向左滑动
            if (translation.x <= 0) {
                
                if ((_swipeRightEditView.left+_swipeRightEditView.width) >= _swipeContentView.width) {
                    _swipeRightEditView.left = _swipeContentView.right;
                } else {
                    _swipeRightEditView.left = _swipeContentView.width-_swipeRightEditView.width;
                }
            }
            //向右滑动
            if (translation.x > 0) {
                
                //                if ((_swipeRightEditView.left+_swipeRightEditView.width) >_swipeContentView.width + 10) {
                //
                //                    _swipeContentView.left = 0;
                //
                //                }
            }
        }
        
    } else if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (_swipeLeftEditView && _swipeContentView.left  >= _swipeLeftEditView.right / 2) {
            [UIView beginAnimations:@"AnimationMove" context:NULL];
            
            _swipeContentView.left = _swipeLeftEditView.right;
            
            [UIView commitAnimations];
            
            _swipeViewEditing = YES;
            
        } else if (_swipeRightEditView ) {
            
            if (_swipeContentView.right < _swipeContentView.width - _swipeRightEditView.width/2) {
                
                [UIView beginAnimations:@"AnimationMove" context:NULL];
                _swipeContentView.right = _swipeContentView.width-_swipeRightEditView.width;
                _swipeRightEditView.left = _swipeContentView.width-_swipeRightEditView.width;
                [UIView commitAnimations];
                _swipeViewEditing = YES;
                
            }
            if (_swipeContentView.right > _swipeContentView.width - _swipeRightEditView.width) {
                
                [UIView beginAnimations:@"AnimationMove" context:NULL];
                _swipeContentView.left = 0;
                _swipeRightEditView.left = _swipeContentView.right;
                [UIView commitAnimations];
                _swipeViewEditing = NO;
                
            }
            
        } else {
            
            [self pullbackSwipeContentViewAnimationd:YES];
        }
        
    }else {
        //  [self pullbackSwipeContentViewAnimationd:YES];
    }
}
@end
