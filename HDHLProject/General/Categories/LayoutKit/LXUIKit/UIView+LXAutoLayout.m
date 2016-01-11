
#import "UIView+LXAutoLayout.h"

@implementation UIView (LXAutoLayout)

#pragma mark - Base

/*添加约束条件（带优先级）*/
- (NSLayoutConstraint *)addConstraintWithItem:(id)firstItem
                                    attribute:(NSLayoutAttribute)firstAttribute
                                    relatedBy:(NSLayoutRelation)relation
                                       toItem:(id)secondItem
                                    attribute:(NSLayoutAttribute)secondAttribute
                                   multiplier:(CGFloat)multiplier
                                     constant:(CGFloat)constant
                                     priority:(UILayoutPriority)priority
{
    //关闭AutoresizingMask转换
    if (firstItem != self) {
        [firstItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    if (secondItem != self) {
        [secondItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    if ((firstItem == self && secondItem == nil) || (firstItem == nil && secondItem == self)) {//如设置自身固定宽或高
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    //添加子视图
    if (![firstItem superview] && firstItem != self) {
        [self addSubview:firstItem];
    }
    if (![secondItem superview] && secondItem != self) {
        [self addSubview:secondItem];
    }
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:firstItem
                                                                  attribute:firstAttribute
                                                                  relatedBy:relation
                                                                     toItem:secondItem
                                                                  attribute:secondAttribute
                                                                 multiplier:multiplier
                                                                   constant:constant];
    constraint.priority = priority;
    [self addConstraint:constraint];
    
    return constraint;
}

/*添加约束条件*/
- (NSLayoutConstraint *)addConstraintWithItem:(id)firstItem
                                    attribute:(NSLayoutAttribute)firstAttribute
                                    relatedBy:(NSLayoutRelation)relation
                                       toItem:(id)secondItem
                                    attribute:(NSLayoutAttribute)secondAttribute
                                   multiplier:(CGFloat)multiplier
                                     constant:(CGFloat)constant
{
    return [self addConstraintWithItem:firstItem
                             attribute:firstAttribute
                             relatedBy:relation
                                toItem:secondItem
                             attribute:secondAttribute
                            multiplier:multiplier
                              constant:constant
                              priority:UILayoutPriorityRequired];
}

/*添加约束条件（可视化语言）*/
- (NSArray *)addConstraintsWithVisualFormat:(NSString *)format
                                    options:(NSLayoutFormatOptions)options
                                    metrics:(NSDictionary *)metrics
                                      views:(NSDictionary *)views
{
    //关闭AutoresizingMask转换，添加子视图
    for (UIView *view in views.allValues) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        if (!view.superview && view != self) {
            [self addSubview:view];
        }
    }
    
    NSString *visualFormat = format;//标准可视化语言
    
    //正则匹配权重关系
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\w+\\(\\$[\\w.]+\\)\\]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:NULL];
    NSArray *results = [regex matchesInString:format options:0 range:NSMakeRange(0, format.length)];
    if (results.count > 1) {
        NSMutableArray *items = [NSMutableArray array];//权重视图
        NSMutableArray *weights = [NSMutableArray array];//权重值
        
        for (NSTextCheckingResult *result in results) {
            NSString *tempString = [format substringWithRange:NSMakeRange(result.range.location + 1, result.range.length - 2)];
            NSArray *components = [tempString componentsSeparatedByString:@"("];
            
            //移除权重标记
            visualFormat = [visualFormat stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"(%@", components.lastObject] withString:@""];
            
            //视图
            id item = [views valueForKey:components.firstObject];
            if (item) {
                //权重
                NSString *weightKey = components.lastObject;
                weightKey = [weightKey substringWithRange:NSMakeRange(1, weightKey.length - 2)];
                float weight = (weightKey.floatValue > 0.0) ? weightKey.floatValue : [[metrics valueForKey:weightKey] floatValue];
                
                [items addObject:item];
                [weights addObject:[NSNumber numberWithFloat:weight]];
            }
        }
        
        [self addWeightConstraintsWithItems:items
                                    weights:weights
                                  attribute:[format hasPrefix:@"V:"] ? NSLayoutAttributeHeight : NSLayoutAttributeWidth];
    }
    
//    NSLog(@"visualFormat: %@", visualFormat);
    
    //解析标准可视化语言
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                   options:options
                                                                   metrics:metrics
                                                                     views:views];
    [self addConstraints:constraints];
    
    return constraints;
}



#pragma mark - Base Wrap

/*添加固定比例约束条件*/
- (NSLayoutConstraint *)addMultiplierConstraintWithItem:(id)firstItem
                                              attribute:(NSLayoutAttribute)firstAttribute
                                           relativeItem:(id)secondItem
                                              attribute:(NSLayoutAttribute)secondAttribute
                                             multiplier:(CGFloat)multiplier
{
    return [self addConstraintWithItem:firstItem
                             attribute:firstAttribute
                             relatedBy:NSLayoutRelationEqual
                                toItem:secondItem ? secondItem : self
                             attribute:secondAttribute
                            multiplier:multiplier
                              constant:0.0
                              priority:UILayoutPriorityRequired];
}

/*添加固定常量约束条件*/
- (NSLayoutConstraint *)addConstantConstraintWithItem:(id)firstItem
                                            attribute:(NSLayoutAttribute)firstAttribute
                                         relativeItem:(id)secondItem
                                            attribute:(NSLayoutAttribute)secondAttribute
                                             constant:(CGFloat)constant
{
    return [self addConstraintWithItem:firstItem
                             attribute:firstAttribute
                             relatedBy:NSLayoutRelationEqual
                                toItem:secondItem ? secondItem : self
                             attribute:secondAttribute
                            multiplier:1.0
                              constant:constant
                              priority:UILayoutPriorityRequired];
}

/*添加固定常量约束条件*/
- (NSLayoutConstraint *)addConstantConstraintWithItem:(id)firstItem
                                            attribute:(NSLayoutAttribute)firstAttribute
                                             constant:(CGFloat)constant
{
    return [self addConstraintWithItem:firstItem
                             attribute:firstAttribute
                             relatedBy:NSLayoutRelationEqual
                                toItem:nil
                             attribute:NSLayoutAttributeNotAnAttribute
                            multiplier:1.0
                              constant:constant
                              priority:UILayoutPriorityRequired];
}



#pragma mark - Equation Custom

/*添加外边距约束条件*/
- (void)addMarginConstraintsWithItem:(id)firstItem
                        relativeItem:(id)secondItem
                              margin:(UIEdgeInsets)margin
{
    for (int i = 0; i < 4; i++) {
        float constant;
        NSLayoutAttribute attribute;
        
        if (i == 0) {
            constant = margin.top;
            attribute = NSLayoutAttributeTop;
        } else if (i == 1) {
            constant = margin.left;
            attribute = NSLayoutAttributeLeading;
        } else if (i == 2) {
            constant = -margin.bottom;
            attribute = NSLayoutAttributeBottom;
        } else {
            constant = -margin.right;
            attribute = NSLayoutAttributeTrailing;
        }
        
        if (constant != kConstantNone && constant != -kConstantNone) {
            [self addConstantConstraintWithItem:firstItem
                                      attribute:attribute
                                   relativeItem:secondItem
                                      attribute:attribute
                                       constant:constant];
        }
    }
}

/*添加中心点约束条件*/
- (void)addCenterConstraintsWithItem:(id)firstItem
                        relativeItem:(id)secondItem
                              offset:(CGPoint)offset
{
    if (offset.x != kConstantNone) {
        [self addConstantConstraintWithItem:firstItem
                                  attribute:NSLayoutAttributeCenterX
                               relativeItem:secondItem
                                  attribute:NSLayoutAttributeCenterX
                                   constant:offset.x];
    }
    
    if (offset.y != kConstantNone) {
        [self addConstantConstraintWithItem:firstItem
                                  attribute:NSLayoutAttributeCenterY
                               relativeItem:secondItem
                                  attribute:NSLayoutAttributeCenterY
                                   constant:offset.y];
    }
}

/*添加大小约束条件*/
- (void)addSizeConstraintsWithItem:(id)firstItem size:(CGSize)size
{
    if (size.width != kConstantNone && size.width >= 0.0) {
        [self addConstraintWithItem:firstItem
                          attribute:NSLayoutAttributeWidth
                          relatedBy:NSLayoutRelationEqual
                             toItem:nil
                          attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1.0
                           constant:size.width
                           priority:UILayoutPriorityRequired];
    }
    
    if (size.height != kConstantNone && size.height >= 0.0) {
        [self addConstraintWithItem:firstItem
                          attribute:NSLayoutAttributeHeight
                          relatedBy:NSLayoutRelationEqual
                             toItem:nil
                          attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1.0
                           constant:size.height
                           priority:UILayoutPriorityRequired];
    }
}

/*添加权重约束条件*/
- (void)addWeightConstraintsWithItems:(NSArray *)items
                              weights:(NSArray *)weights
                            attribute:(NSLayoutAttribute)attribute
{
    if (items.count <= 1) {
        NSLog(@"Layout Error: items应至少包含两个元素 %s", __FUNCTION__);
        return;
    }
    if (items.count != weights.count && weights != nil) {
        NSLog(@"Layout Error: items与weights元素数量不匹配 %s", __FUNCTION__);
        return;
    }
    
    float firstWeight = weights ? [weights.firstObject floatValue] : 0.0;
    for (int i = 1; i < items.count; i++) {
        float multiplier = (firstWeight != 0.0) ? [[weights objectAtIndex:i] floatValue] / firstWeight : 1.0;
        [self addConstraintWithItem:[items objectAtIndex:i]
                          attribute:attribute
                          relatedBy:NSLayoutRelationEqual
                             toItem:items.firstObject
                          attribute:attribute
                         multiplier:multiplier
                           constant:0.0
                           priority:UILayoutPriorityRequired];
    }
}



#pragma mark - Constraints

/*移除所有约束条件*/
- (void)removeAllConstraints
{
    [self removeConstraints:self.constraints];
}

@end
