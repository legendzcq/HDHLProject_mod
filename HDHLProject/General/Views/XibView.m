//
//  XibView.m
//  MinFramework
//
//  Created by ligh on 14-3-11.
//
//

#import "XibView.h"

@implementation XibView

+ (id)viewFromXIB {
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    if (array && [array count]) {
        return array[0];
    } else {
        return nil;
    }
}

@end
