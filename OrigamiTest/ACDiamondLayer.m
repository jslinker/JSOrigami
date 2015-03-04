//
//  ACDiamondLayer.m
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/7/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import "ACDiamondLayer.h"

@implementation ACDiamondLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    
    // start in the top center
    CGContextMoveToPoint(ctx, self.bounds.size.width / 2, 0);
    CGContextAddLineToPoint(ctx, 0, self.bounds.size.height / 2);
    CGContextAddLineToPoint(ctx, self.bounds.size.width / 2, self.bounds.size.height);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height / 2);
    
    if (self.image) {
        CGContextClip(ctx);
        CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextDrawImage(ctx, self.bounds, self.image.CGImage);
    } else if (self.fillColor) {
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextFillPath(ctx);
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillPath(ctx);
    }
    
    CGContextRestoreGState(ctx);
}

@end
