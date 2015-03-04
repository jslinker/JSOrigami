//
//  ACCornerLayerContainer.m
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/9/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import "ACCornerLayerContainer.h"

@implementation ACCornerLayerContainer

- (id)initWithFrontColor:(UIColor*)frontColor backColor:(UIColor*)backColor andCornerPosition:(CornerDirection)cornerDirection {
    self = [super init];
    if (self) {
        _frontSide = [[ACCornerLayer alloc]initWithCornerDirection:cornerDirection];
        _backSide = [[ACCornerLayer alloc]initWithCornerDirection:cornerDirection];
        _gradient = [[ACCornerLayer alloc]initWithCornerDirection:cornerDirection];
        
        _frontSide.fillColor = frontColor;
        _backSide.fillColor = backColor;
        
        _frontSide.zPosition = _gradient.zPosition - 1;
        _backSide.zPosition = _frontSide.zPosition - 1;
        
        _frontSide.doubleSided = NO;
        _gradient.doubleSided = NO;
        
        _gradient.opacity = 0.7f;
        _gradient.gradientColor = [UIColor blackColor];
        
        [self setNeedsDisplay];
    }
    return self;
}

- (void)setNeedsDisplay {
    [_frontSide setNeedsDisplay];
    [_backSide setNeedsDisplay];
    [_gradient setNeedsDisplay];
}

- (void)performAnimation:(CAAnimation *)animation forKey:(NSString *)key {
    [self.frontSide addAnimation:animation forKey:key];
    [self.backSide addAnimation:animation forKey:key];
    [self.gradient addAnimation:animation forKey:key];
}

- (void)updateLayersWithTranform:(CATransform3D)transform {
    _frontSide.transform = transform;
    _backSide.transform = transform;
    _gradient.transform = transform;
}

- (void)updateLayersWithBounds:(CGRect)bounds andPosition:(CGPoint)position {
    _frontSide.bounds = bounds;
    _frontSide.position = position;
    
    _backSide.bounds = bounds;
    _backSide.position = position;
    
    _gradient.bounds = bounds;
    _gradient.position = position;
    
    [self setNeedsDisplay];
}

@end
