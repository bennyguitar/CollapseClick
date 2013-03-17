//
//  CollapseClickIcon.m
//  CollapseClick
//
//  Created by Ben Gordon on 3/17/13.
//  Copyright (c) 2013 Ben Gordon. All rights reserved.
//

#import "CollapseClickArrow.h"

@implementation CollapseClickArrow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrowColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    [self.arrowColor setFill];
    [arrow moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [arrow addLineToPoint:CGPointMake(0, 0)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [arrow fill];
}


@end
