//
//  ModalPresentationView.h
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/2/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalPresentationView : UIView

- (void)presentView:(UIView*)view withAnimationType:(ACModalPresentationStyle)presentationStyle;

@end
