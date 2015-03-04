//
//  ACOrigamiLayer.h
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/7/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ACCornerLayer.h"
#import "ACDiamondLayer.h"

@interface ACOrigamiLayer : CALayer

- (id)initWithView:(UIView*)view;
- (void)toggleFolds;

@end
