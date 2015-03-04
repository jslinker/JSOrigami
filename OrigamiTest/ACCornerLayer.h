//
//  ACCornerLayer.h
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/7/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_OPTIONS(NSUInteger, CornerDirection){
    CornerDirectionTopLeft = 1,
    CornerDirectionTopRight = 2,
    CornerDirectionBottomLeft = 3,
    CornerDirectionBottomRight = 4
};

@interface ACCornerLayer : CALayer

@property (nonatomic, retain) UIColor* fillColor;
@property (nonatomic, assign) CornerDirection direction;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIColor* gradientColor;

- (id)initWithCornerDirection:(CornerDirection)direction;

@end
