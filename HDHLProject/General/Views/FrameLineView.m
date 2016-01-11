//
//  FrameLineView.m
//  iSchool
//
//  Created by ligh on 13-9-26.
//
//

#import "FrameLineView.h"

@implementation FrameLineView

- (id)init {
    if (self = [super init]) {
        self.backgroundColor = UIColorFromRGB(220, 220, 220);
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(220, 220, 220);
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColorFromRGB(220, 220, 220);
    if (self.width > 1) {
        self.height = 0.5;
    }
    if (self.height > 1) {
        self.width = 0.5;
    }
}

@end
