//
//  TTViewController.h
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/2/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ACModalPresentationStyle) {
    ACModalPresentationStyleNone = 0,
    ACModalPresentationStyleSlideFromLeft = 1,
    ACModalPresentationStyleSlideFromRight = 2,
    ACModalPresentationStyleSlideFromBottom = 3,
    ACModalPresentationStyleSlideFromTop = 4,
    ACModalPresentationStyleOrigami = 5
    };

@interface TTViewController : UIViewController

- (void)presentViewController:(UIViewController *)viewControllerToPresent withPresentationStyle:(ACModalPresentationStyle)presentationStyle;

@end
