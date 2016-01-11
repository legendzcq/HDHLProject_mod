//
//  OptionsModel.h
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import <Foundation/Foundation.h>

/**
 *  选项model
 */
@interface OptionsModel : BaseModelObject

//每个选项对应的action 标记 用来区别此选项的事件类型
@property (assign,nonatomic) NSInteger actionTag;
@property (assign,nonatomic) BOOL checked; //是否选中了此model
@property (assign,nonatomic) BOOL enable; //当前选项是否允许选择

//选项title
@property (retain,nonatomic) NSString *title;


@end
