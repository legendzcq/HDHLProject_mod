
#import <UIKit/UIKit.h>

#define kConstantNone 99999

@interface UIView (LXAutoLayout)

///添加约束条件（带优先级）
- (NSLayoutConstraint *)addConstraintWithItem:(id)firstItem
                                    attribute:(NSLayoutAttribute)firstAttribute
                                    relatedBy:(NSLayoutRelation)relation
                                       toItem:(id)secondItem
                                    attribute:(NSLayoutAttribute)secondAttribute
                                   multiplier:(CGFloat)multiplier
                                     constant:(CGFloat)constant
                                     priority:(UILayoutPriority)priority;

///添加约束条件
- (NSLayoutConstraint *)addConstraintWithItem:(id)firstItem
                                    attribute:(NSLayoutAttribute)firstAttribute
                                    relatedBy:(NSLayoutRelation)relation
                                       toItem:(id)secondItem
                                    attribute:(NSLayoutAttribute)secondAttribute
                                   multiplier:(CGFloat)multiplier
                                     constant:(CGFloat)constant;

///添加约束条件（可视化语言）。支持权重$，例[view($1)]。
- (NSArray *)addConstraintsWithVisualFormat:(NSString *)format
                                    options:(NSLayoutFormatOptions)options
                                    metrics:(NSDictionary *)metrics
                                      views:(NSDictionary *)views;



///添加固定比例约束条件。relativeItem为空时表示相对父视图。
- (NSLayoutConstraint *)addMultiplierConstraintWithItem:(id)firstItem
                                              attribute:(NSLayoutAttribute)firstAttribute
                                           relativeItem:(id)secondItem
                                              attribute:(NSLayoutAttribute)secondAttribute
                                             multiplier:(CGFloat)multiplier;

///添加固定常量约束条件。relativeItem为空时表示相对父视图。
- (NSLayoutConstraint *)addConstantConstraintWithItem:(id)firstItem
                                            attribute:(NSLayoutAttribute)firstAttribute
                                         relativeItem:(id)secondItem
                                            attribute:(NSLayoutAttribute)secondAttribute
                                             constant:(CGFloat)constant;

///添加固定常量约束条件
- (NSLayoutConstraint *)addConstantConstraintWithItem:(id)firstItem
                                            attribute:(NSLayoutAttribute)firstAttribute
                                             constant:(CGFloat)constant;



/**
 *  @brief  添加外边距约束条件
 *  @param  item            视图
 *  @param  relativeItem    相对视图，为空时表示相对父视图
 *  @param  margin          外边距，取值为kConstantNone的属性不计
 */
- (void)addMarginConstraintsWithItem:(id)firstItem
                        relativeItem:(id)secondItem
                              margin:(UIEdgeInsets)margin;

/**
 *  @brief  添加中心点约束条件
 *  @param  item            视图
 *  @param  relativeItem    相对视图，为空时表示相对父视图
 *  @param  offset          偏移量，取值为kConstantNone的属性不计
 */
- (void)addCenterConstraintsWithItem:(id)firstItem
                        relativeItem:(id)secondItem
                              offset:(CGPoint)offset;

/**
 *  @brief  添加尺寸约束条件
 *  @param  item            视图
 *  @param  size            尺寸，取值为kConstantNone的属性不计
 */
- (void)addSizeConstraintsWithItem:(id)firstItem size:(CGSize)size;

/**
 *  @brief  添加权重约束条件
 *  @param  items           视图数组
 *  @param  weights         权重数组，为空时表示权重都相等
 *  @param  attribute       计算权重的属性
 */
- (void)addWeightConstraintsWithItems:(NSArray *)items
                              weights:(NSArray *)weights
                            attribute:(NSLayoutAttribute)attribute;



///移除所有约束条件
- (void)removeAllConstraints;

@end
