//
//  ACOrigamiLayer.m
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/7/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import "ACOrigamiLayer.h"
#import "ACCornerLayerContainer.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ACOrigamiLayer()

@property (nonatomic,retain) UIView* baseView;
@property (nonatomic, retain) UIImage* baseViewImage;
@property (nonatomic, assign) BOOL isOpen;

@property (nonatomic, retain) ACCornerLayerContainer* topLeftCorner;
@property (nonatomic, retain) ACCornerLayerContainer* topRightCorner;
@property (nonatomic, retain) ACCornerLayerContainer* bottomLeftCorner;
@property (nonatomic, retain) ACCornerLayerContainer* bottomRightCorner;

@property (nonatomic, retain) ACDiamondLayer* centerLayer;
@property (nonatomic, retain) ACDiamondLayer* centerTint;

@end

@implementation ACOrigamiLayer

#pragma mark - Initialization and Setter Override -

- (id)initWithView:(UIView*)view {
    self = [super init];
    if (self) {
        self.baseView = view;
        self.isOpen = YES;
        [self setupCenterLayers];
        [self setupCornerLayers];
        [self setupImages];
    }
    return self;
}

- (void)setupCornerLayers {
    self.topLeftCorner = [self createCornerLayerContainerWithFrontColor:[UIColor whiteColor] backColor:[UIColor whiteColor] direction:CornerDirectionTopLeft];
    self.topRightCorner = [self createCornerLayerContainerWithFrontColor:[UIColor whiteColor] backColor:[UIColor whiteColor] direction:CornerDirectionTopRight];
    self.bottomLeftCorner = [self createCornerLayerContainerWithFrontColor:[UIColor whiteColor] backColor:[UIColor whiteColor] direction:CornerDirectionBottomLeft];
    self.bottomRightCorner = [self createCornerLayerContainerWithFrontColor:[UIColor whiteColor] backColor:[UIColor whiteColor] direction:CornerDirectionBottomRight];
}

- (void)setupCenterLayers {
    self.centerLayer = [[ACDiamondLayer alloc]init];
    self.centerTint = [[ACDiamondLayer alloc]init];
    
    self.centerLayer.fillColor = [UIColor whiteColor];
    self.centerTint.fillColor = [UIColor blackColor];
    
    self.centerLayer.zPosition = INT_MIN;
    
    [self.centerLayer addSublayer:self.centerTint];
    [self addSublayer:self.centerLayer];
}

- (void)setupImages {
    UIGraphicsBeginImageContext(self.baseView.frame.size);
    [self.baseView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.baseViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGImageRef trimmedImage = CGImageCreateWithImageInRect(self.baseViewImage.CGImage, CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height / 2));
    self.topLeftCorner.frontSide.image = [UIImage imageWithCGImage:trimmedImage];
    
    trimmedImage = CGImageCreateWithImageInRect(self.baseViewImage.CGImage, CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height / 2));
    self.topRightCorner.frontSide.image = [UIImage imageWithCGImage:trimmedImage];
    
    trimmedImage = CGImageCreateWithImageInRect(self.baseViewImage.CGImage, CGRectMake(0, self.bounds.size.height / 2, self.bounds.size.width / 2, self.bounds.size.height / 2));
    self.bottomLeftCorner.frontSide.image = [UIImage imageWithCGImage:trimmedImage];
    
    trimmedImage = CGImageCreateWithImageInRect(self.baseViewImage.CGImage, CGRectMake(self.bounds.size.width / 2, self.bounds.size.height / 2, self.bounds.size.width / 2, self.bounds.size.height / 2));
    self.bottomRightCorner.frontSide.image = [UIImage imageWithCGImage:trimmedImage];
    
    self.centerLayer.image = self.baseViewImage;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self updateSubLayerBounds];
}

#pragma mark - Perform Animations -

- (void)toggleFolds {
    if (self.isOpen) {
        [self flipClosed];
    } else {
        [self flipOpen];
    }
}

- (void)flipOpen {
    self.isOpen = YES;
    [self rotateSelfFrom:225 toAngle:0];
    [self animateTintFromValue:1 toValue:0.0];

    [self updateSubLayersWithRotationAngle:180];
    [self animateSublayersWithRotationAngle:0];
    [self animateSubLayersGradientsWithStartValue:1 endValue:0.0];
}

- (void)flipClosed {
    self.isOpen = NO;
    [self rotateSelfFrom:0 toAngle:225];
    [self animateTintFromValue:0.0 toValue:1];

    [self updateSubLayersWithRotationAngle:0];
    [self animateSublayersWithRotationAngle:180];
    [self animateSubLayersGradientsWithStartValue:0.0 endValue:1];
}

- (void)rotateSelfFrom:(float)startDegrees toAngle:(float)endDegrees {
    self.transform = [self createRotationTransformWithAngle:startDegrees acrossAxes:CGPointMake(0, 0) withZ:1 andAdditionalTransform:CATransform3DIdentity];
    CATransform3D rotation = [self createRotationTransformWithAngle:endDegrees acrossAxes:CGPointMake(0, 0) withZ:1 andAdditionalTransform:CATransform3DIdentity];
    [self addAnimation:[self createAnimationWithTransform:rotation delegate:self] forKey:@"transform"];
}

- (void)animateTintFromValue:(CGFloat)startValue toValue:(CGFloat)endValue {
    CABasicAnimation* animation = [self createAnimationWithKeypath:@"opacity" delegate:nil];
    animation.fromValue = [NSNumber numberWithFloat:startValue];
    animation.toValue = [NSNumber numberWithFloat:endValue];
    [self.centerTint addAnimation:animation forKey:@"opacity"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self toggleFolds];
}

#pragma mark - Manage Sublayers -

- (void)animateSubLayersGradientsWithStartValue:(float)startValue endValue:(float)endValue {
    CABasicAnimation* animation = [self createAnimationWithKeypath:@"opacity" delegate:nil];
    animation.fromValue = [NSNumber numberWithFloat:startValue];
    animation.toValue = [NSNumber numberWithFloat:endValue];
    [self.topLeftCorner.gradient addAnimation:animation forKey:@"opacity"];
    [self.topRightCorner.gradient addAnimation:animation forKey:@"opacity"];
    [self.bottomLeftCorner.gradient addAnimation:animation forKey:@"opacity"];
    [self.bottomRightCorner.gradient addAnimation:animation forKey:@"opacity"];
}

- (void)updateSubLayersWithRotationAngle:(CGFloat)degrees {
    [self.topLeftCorner updateLayersWithTranform:[self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(-1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity]];
    [self.topRightCorner updateLayersWithTranform:[self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity]];
    [self.bottomLeftCorner updateLayersWithTranform:[self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity]];
    [self.bottomRightCorner updateLayersWithTranform:[self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(-1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity]];
}

- (void)animateSublayersWithRotationAngle:(CGFloat)degrees {
    CATransform3D rotation = [self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(-1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity];
    [self.topLeftCorner performAnimation:[self createAnimationWithTransform:rotation delegate:nil] forKey:@"transform.rotation"];
    
    rotation = [self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity];
    [self.topRightCorner performAnimation:[self createAnimationWithTransform:rotation delegate:nil] forKey:@"transform.rotation"];
    
    rotation = [self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity];
    [self.bottomLeftCorner performAnimation:[self createAnimationWithTransform:rotation delegate:nil] forKey:@"transform.rotation"];
    
    rotation = [self createRotationTransformWithAngle:degrees acrossAxes:CGPointMake(-1, 1) withZ:0 andAdditionalTransform:CATransform3DIdentity];
    [self.bottomRightCorner performAnimation:[self createAnimationWithTransform:rotation delegate:nil] forKey:@"transform.rotation"];
}

// setting positions looks funny because the animation requires
// the anchor point to be at (0.5, 0.5).  That means that setting
// the position is setting the center point and not the corner.
- (void)updateSubLayerBounds {
    float halfSelfWidth = self.bounds.size.width / 2;
    float halfSelfHeight = self.bounds.size.height / 2;
    CGRect cornerRect = CGRectMake(0, 0, halfSelfWidth, halfSelfHeight);
    
    self.centerLayer.anchorPoint = CGPointZero;
    self.centerLayer.bounds = self.bounds;
    self.centerLayer.position = CGPointZero;
    [self.centerLayer setNeedsDisplay];
    
    self.centerTint.anchorPoint = CGPointZero;
    self.centerTint.bounds = self.bounds;
    self.centerTint.position = CGPointZero;
    [self.centerTint setNeedsDisplay];
    
    [self.topLeftCorner updateLayersWithBounds:cornerRect andPosition:CGPointMake(halfSelfWidth / 2, halfSelfHeight / 2)];
    [self.topRightCorner updateLayersWithBounds:cornerRect andPosition:CGPointMake(halfSelfWidth + halfSelfWidth / 2, halfSelfHeight / 2)];
    [self.bottomLeftCorner updateLayersWithBounds:cornerRect andPosition:CGPointMake(halfSelfWidth / 2, halfSelfHeight + halfSelfHeight / 2)];
    [self.bottomRightCorner updateLayersWithBounds:cornerRect andPosition:CGPointMake(halfSelfWidth + halfSelfWidth / 2, halfSelfHeight + halfSelfHeight / 2)];
    
    [self setupImages];
}

#pragma mark - Helper Methods -

-(ACCornerLayerContainer*)createCornerLayerContainerWithFrontColor:(UIColor*)frontColor backColor:(UIColor*)backColor direction:(CornerDirection)direction {
    ACCornerLayerContainer* newContainer = [[ACCornerLayerContainer alloc]initWithFrontColor:frontColor backColor:backColor andCornerPosition:direction];
    [self addSublayer:newContainer.backSide];
    [self addSublayer:newContainer.frontSide];
    [self addSublayer:newContainer.gradient];
    return newContainer;
}

-(CABasicAnimation*)createAnimationWithStartTransform:(CATransform3D)startTransform endTransform:(CATransform3D)endTransform delegate:(id)delegate{
    CABasicAnimation* animation = [self createAnimationWithKeypath:@"transform" delegate:delegate];
    animation.fromValue = [NSValue valueWithCATransform3D:startTransform];
    animation.toValue = [NSValue valueWithCATransform3D:endTransform];
    return animation;
}

- (CATransform3D)createRotationTransformWithAngle:(float)degrees acrossAxesX:(float)x y:(float)y z:(float)z {
    CATransform3D transformToRotation = CATransform3DIdentity;
    transformToRotation.m34 = 1.0 / -1000; // Adds perspective to the rotation, smaller denominator = less perspective
    transformToRotation = CATransform3DRotate(transformToRotation, DEGREES_TO_RADIANS(degrees), x, y, z);
    return transformToRotation;
}

-(CABasicAnimation*)createAnimationWithTransform:(CATransform3D) transform delegate:(id)delegate{
    CABasicAnimation* animation = [self createAnimationWithKeypath:@"transform" delegate:delegate];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    return animation;
}

-(CABasicAnimation*)createAnimationWithKeypath:(NSString*)keypath delegate:(id)delegate{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:keypath];
    animation.duration = 2;
    animation.cumulative = YES;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = delegate;
    return animation;
}

-(CATransform3D)createRotationTransformWithAngle:(float)degrees acrossAxes:(CGPoint)axes withZ:(CGFloat)z andAdditionalTransform:(CATransform3D)transform{
    CATransform3D transformToRotation = CATransform3DIdentity;
    transformToRotation.m34 = 1.0 / -1000; // Adds perspective to the rotation, smaller denominator = less perspective
    transformToRotation = CATransform3DRotate(transformToRotation, DEGREES_TO_RADIANS(degrees), axes.x, axes.y, z);
    transformToRotation = CATransform3DConcat(transformToRotation, transform);
    transformToRotation.m34 = 1.0 / -1000; // Adds perspective to the rotation, smaller denominator = less perspective
    return transformToRotation;
}

@end
