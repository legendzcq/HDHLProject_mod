//
//  StrikethroughLabel.m
//  Carte
//
//  Created by ligh on 14-4-22.
//
//

#import "StrikethroughLabel.h"

@implementation StrikethroughLabel


- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    
    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGFloat strikeWidth = textSize.width + 0.5;
    CGRect lineRect;
    
    if ([self textAlignment] == NSTextAlignmentRight)
    {
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2, strikeWidth, 1.2);
        
    } else if ([self textAlignment] == NSTextAlignmentCenter)
    {
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 1.2);
        
    } else {
        
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1.2);
    }
    

    CGContextRef context = UIGraphicsGetCurrentContext();
 //   CGContextSetStrokeColorSpace(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, lineRect);
}



@end
