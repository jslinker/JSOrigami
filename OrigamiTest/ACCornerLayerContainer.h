//
//  ACCornerLayerContainer.h
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/9/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCornerLayer.h"

@interface ACCornerLayerContainer : NSObject

@property (nonatomic, retain, readonly) ACCornerLayer* frontSide;
@property (nonatomic, retain, readonly) ACCornerLayer* backSide;
@property (nonatomic, retain, readonly) ACCornerLayer* gradient;

- (id)initWithFrontColor:(UIColor*)frontColor backColor:(UIColor*)backColor andCornerPosition:(CornerDirection)cornerDirection;
- (void)updateLayersWithBounds:(CGRect)bounds andPosition:(CGPoint)position;
- (void)updateLayersWithTranform:(CATransform3D)transform;
- (void)performAnimation:(CABasicAnimation*)animation forKey:(NSString*)key;

@end
