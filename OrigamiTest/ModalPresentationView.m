//
//  ModalPresentationView.m
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/2/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import "ACOrigamiLayer.h"
#import "TTViewController.h"
#import "ModalPresentationView.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ModalPresentationView()

@property (nonatomic, retain) UIView* presentedView;

@end

@implementation ModalPresentationView

+ (Class)layerClass {
    return [CATransformLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)presentView:(UIView*)view withAnimationType:(ACModalPresentationStyle)presentationStyle {
    _presentedView = view;
    [self addSubview:view];
    view.frame = [self startRectForView:view withPresentationStyle:presentationStyle];
    CGRect endRect = [self centeredRectForView:view];
    float animationDuration = presentationStyle == ACModalPresentationStyleNone ? 0.0f : 1.0f;
    
    if (presentationStyle != ACModalPresentationStyleOrigami) {
        [UIView animateWithDuration:animationDuration animations:^{
            view.frame = endRect;
        }];
    } else {
        [self performOrigamiPresentation];
    }
    
}

- (void)performOrigamiPresentation {
    UIImage* imageRepresentation = [self imageWithView:self.presentedView];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *myImageData = UIImagePNGRepresentation(imageRepresentation);
    [fileManager createFileAtPath:@"/Users/jslinker/Desktop/myimage.png" contents:myImageData attributes:nil];
    
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:imageRepresentation];
    ACOrigamiLayer* origamiLayer = [[ACOrigamiLayer alloc]initWithView:imageView];
    origamiLayer.bounds = CGRectMake(0, 0, imageRepresentation.size.width, imageRepresentation.size.height);
    origamiLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [origamiLayer setNeedsDisplay];
    [self.layer addSublayer:origamiLayer];
    [origamiLayer toggleFolds];
}

-(CABasicAnimation*)createAnimationWithTransform:(CATransform3D) transform{
    CABasicAnimation* animation = [self createAnimationWithKeypath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    return animation;
}

-(CABasicAnimation*)createAnimationWithKeypath:(NSString*)keypath{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:keypath];
    animation.duration = 1;
    animation.cumulative = YES;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    return animation;
}

-(CATransform3D)createRotationTransformWithAngle:(float)degrees andAdditionalTransform:(CATransform3D)transform{
    CATransform3D transformToRotation = CATransform3DIdentity;
    transformToRotation.m34 = 1.0 / -1000; // Adds perspective to the rotation, smaller denominator = less perspective
    transformToRotation = CATransform3DRotate(transformToRotation, DEGREES_TO_RADIANS(degrees), 0, 1, 0);
    transformToRotation = CATransform3DConcat(transformToRotation, transform);
    return transformToRotation;
}

- (CGImageRef)croppedImage:(UIImage*)image withRect:(CGRect)rect {
    return CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width / 2, image.size.height));
}

- (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (CGRect)startRectForView:(UIView*)view withPresentationStyle:(ACModalPresentationStyle)presentationStyle {
    CGRect startRect = [self centeredRectForView:view];
    switch (presentationStyle) {
        case ACModalPresentationStyleNone:
            startRect = [self centeredRectForView:view];
            break;
        case ACModalPresentationStyleSlideFromBottom:
        case ACModalPresentationStyleOrigami:
            startRect = CGRectMake(startRect.origin.x, startRect.origin.y + self.frame.size.height, startRect.size.width, startRect.size.height);
            break;
        case ACModalPresentationStyleSlideFromLeft:
            startRect = CGRectMake(startRect.origin.x - self.frame.size.width, startRect.origin.y, startRect.size.width, startRect.size.height);
            break;
        case ACModalPresentationStyleSlideFromRight:
            startRect = CGRectMake(startRect.origin.x + self.frame.size.width, startRect.origin.y, startRect.size.width, startRect.size.height);
            break;
        case ACModalPresentationStyleSlideFromTop:
            startRect = CGRectMake(startRect.origin.x, startRect.origin.y - self.frame.size.height, startRect.size.width, startRect.size.height);
            break;
        default:
            break;
    }
    return startRect;
}

- (CGRect)centeredRectForView:(UIView*)view {
    return CGRectMake(self.frame.size.width - view.frame.size.width - view.frame.size.width / 4, self.frame.size.height - view.frame.size.height - view.frame.size.height / 2, view.frame.size.width, view.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
