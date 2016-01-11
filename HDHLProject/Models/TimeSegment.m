//
//  TimeSegment.m
//  Carte
//
//  Created by ligh on 14-5-10.
//
//

#import "TimeSegment.h"

@implementation TimeSegment

- (void)dealloc
{
    RELEASE_SAFELY(_minute);
    RELEASE_SAFELY(_time);
}

@end
