//
//  AddressCell.h
//  Carte
//
//  Created by ligh on 14-4-9.
//
//

#import "SwipeEditCell.h"

@protocol AddressCellDelegate;



@interface AddressCell : SwipeEditCell

/**
 *  编辑 删除 选中 事件delegate
 */
@property (assign,nonatomic) id<AddressCellDelegate> actionDelegate;

-(BOOL) isChecked;
-(void) setChecked:(BOOL) check;

@end


@protocol AddressCellDelegate <NSObject>

@optional
//选中状态改变
-(void) addressCell:(AddressCell *) cell checkStatusChanged:(BOOL) checked;

//点击编辑按钮事件
-(void) addressCellEditAction:(AddressCell *) cell;
//点击删除按钮事件
-(void) addressCellDelAction:(AddressCell *) cell;


@end