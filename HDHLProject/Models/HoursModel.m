//
//  HoursModel.m
//  Carte
//
//  Created by ligh on 14-5-7.
//
//

#import "HoursModel.h"

@implementation HoursModel

- (void)dealloc
{
    
    RELEASE_SAFELY(_minute);
    RELEASE_SAFELY(_time);
}

@end
