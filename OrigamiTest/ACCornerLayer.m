//
//  ACCornerLayer.m
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/7/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import "ACCornerLayer.h"

@implementation ACCornerLayer

- (id)initWithCornerDirection:(CornerDirection)direction {
    self = [super init];
    if (self) {
        self.direction = direction;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGPoint startGradient = CGPointZero;
    CGPoint endGradient = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // draw the path
    switch (self.direction) {
        case CornerDirectionTopLeft:
            CGContextMoveToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
            CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
            break;
        case CornerDirectionTopRight:
            CGContextMoveToPoint(ctx, self.bounds.size.width, 0);
            CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
            CGContextAddLineToPoint(ctx, 0, 0);
            startGradient = CGPointMake(self.bounds.size.width, 0);
            break;
        case CornerDirectionBottomRight:
            CGContextMoveToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
            CGContextAddLineToPoint(ctx, 0, self.bounds.size.height);
            CGContextAddLineToPoint(ctx, self.bounds.size.width, 0);
            startGradient = CGPointMake(self.bounds.size.width, self.bounds.size.height);
            break;
        case CornerDirectionBottomLeft:
            CGContextMoveToPoint(ctx, 0, self.bounds.size.height);
            CGContextAddLineToPoint(ctx, 0, 0);
            CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height);
            startGradient = CGPointMake(0, self.bounds.size.height);
            break;
        default:
            break;
    }
    
    // fill the path
    if (self.image) {
        CGContextClip(ctx);
        CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
        CGContextScaleCTM(ctx, 1, -1);
        CGContextDrawImage(ctx, self.bounds, self.image.CGImage);
    } else if (self.fillColor) {
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextFillPath(ctx);
    } else if (self.gradientColor) {
        CGContextClip(ctx);
        NSArray* colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, self.gradientColor.CGColor, nil];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (__bridge CFArrayRef)colors, nil);
        CGContextDrawLinearGradient(ctx, gradient, startGradient, endGradient, 0);
    } else {
        CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextFillPath(ctx);
    }
    
    CGContextRestoreGState(ctx);
}

@end
