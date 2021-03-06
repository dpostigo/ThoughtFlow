//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "CreateProjectController.h"
#import "DPFadeTransition.h"
#import "Model.h"
#import "Project.h"
#import "ProjectsController.h"

@implementation CreateProjectController

- (void) loadView {
    [super loadView];

    NSAttributedString *string = [[NSAttributedString alloc] initWithString: textField.placeholder
            attributes: @{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    textField.attributedPlaceholder = string;
    textField.delegate = self;

}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;

    if ([_model.projects count] > 0) {
        [self performSegueWithIdentifier: @"ProjectsSegue" sender: nil];
    }
}

- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];
    textField.text = @"";
}


- (void) createProject {
    NSDictionary *newProject = @{
            TFProjectName : textField.text
    };

    Project *project = [[Project alloc] initWithWord: textField.text];
    _model.selectedProject = project;
    [_model addProject: project];

    [self performSegueWithIdentifier: @"ProjectsSegue" sender: nil];
}


#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField1 {
    [textField1 resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *) textField1 {
    if (self.isValid) {
        [self createProject];
    }

}


#pragma mark Validate

- (BOOL) isValid {
    if ([textField.text length] == 0) {
        return NO;
    }
    return YES;
}

#pragma mark UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
    return (id <UIViewControllerAnimatedTransitioning>) ([toVC isKindOfClass: [ProjectsController class]] ? [DPFadeTransition new] : nil);
}


@end