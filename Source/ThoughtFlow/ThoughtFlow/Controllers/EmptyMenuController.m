//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "EmptyMenuController.h"
#import "DPFadeTransition.h"
#import "Model.h"

@implementation EmptyMenuController

- (void) loadView {
    [super loadView];

    NSAttributedString *string = [[NSAttributedString alloc] initWithString: textField.placeholder
                                                                 attributes: @{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [textField setAttributedPlaceholder: string];
    textField.delegate = self;

}

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationController.delegate = self;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    //    [super touchesBegan: touches withEvent: event];
    [self.view endEditing: YES];
}

#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField1 {
    [textField1 resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *) textField1 {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    if (self.isValid) {
        NSDictionary *newProject = @{
                TFProjectName : textField.text
        };
        _model.selectedProject = newProject;
        [self performSegueWithIdentifier: @"ProjectsSegue" sender: nil];
    }

}


- (BOOL) isValid {
    return YES;

}

#pragma mark UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
    DPFadeTransition *animator = [DPFadeTransition new];
    return animator;
}


//#pragma mark UIViewControllerTransitioningDelegate
//- (id <UIViewControllerAnimatedTransitioning>) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
//    return nil;
//}
//
//- (id <UIViewControllerAnimatedTransitioning>) animationControllerForDismissedController: (UIViewController *) dismissed {
//    return nil;
//}

@end