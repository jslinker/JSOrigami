//
//  TTViewController.m
//  OrigamiTest
//
//  Created by Joseph Slinker on 5/2/13.
//  Copyright (c) 2013 Joseph Slinker. All rights reserved.
//

#import "TTViewController.h"
#import "ModalPresentationView.h"

@interface TTViewController ()

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self presentViewController:nil withPresentationStyle:ACModalPresentationStyleNone];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = [UIScreen mainScreen].bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent withPresentationStyle:(ACModalPresentationStyle)presentationStyle{
    UIImageView* imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Demo-Image"]];
    [(ModalPresentationView*)self.view presentView:imageView withAnimationType:ACModalPresentationStyleOrigami];
}

@end
