//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "CreateProjectController.h"
#import "DPFadeTransition.h"
#import "Model.h"
#import "Project.h"
#import "ProjectsController.h"


@implementation CreateProjectController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Storyboard"];
}


#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    [self _setup];

    //    if (DEBUG) {
    //        Project *project = [[Project alloc] initWithWord: @"test"];
    //
    //        //        TFNode *node = [[TFNode alloc] initWithTitle: @"node1"];
    //        //        [node.children addObject: [[TFNode alloc] initWithTitle: @"node1 child1"]];
    //        //        [node.children addObject: [[TFNode alloc] initWithTitle: @"node1 child2"]];
    //        //        [node.children addObject: [[TFNode alloc] initWithTitle: @"node1 child2"]];
    //        //
    //        //        [project.firstNode.children addObject: node];
    //
    //        _model.selectedProject = project;
    //        [_model addProject: project];
    //        [self performSegueWithIdentifier: @"ProjectsSegue" sender: nil];
    //    }

    if ([_model.projects count] > 0) {
        //        [self performSegueWithIdentifier: @"ProjectsSegue" sender: nil];
    }
}

- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];
    _textField.text = @"";
}



#pragma mark - Actions
- (void) createProject {

    Project *project = [[Project alloc] initWithWord: _textField.text];
    _model.selectedProject = project;
    [_model addProject: project];

    ProjectsController *controller = [[ProjectsController alloc] init];
    [self.navigationController setViewControllers: @[controller] animated: YES];

}


#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *) textField {
    if (self.isValid) {
        [self createProject];
    }

}


#pragma mark Validate

- (BOOL) isValid {
    if ([_textField.text length] == 0) {
        return NO;
    }
    return YES;
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];
    [_textField resignFirstResponder];
}


#pragma mark UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>) navigationController: (UINavigationController *) navigationController animationControllerForOperation: (UINavigationControllerOperation) operation fromViewController: (UIViewController *) fromVC toViewController: (UIViewController *) toVC {
    return (id <UIViewControllerAnimatedTransitioning>) ([toVC isKindOfClass: [ProjectsController class]] ? [DPFadeTransition new] : nil);
}



#pragma mark - Private

- (void) _setup {
    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];

    self.navigationController.view.opaque = NO;
    self.navigationController.view.backgroundColor = [UIColor clearColor];

    NSAttributedString *string = [[NSAttributedString alloc] initWithString: _textField.placeholder
            attributes: @{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    _textField.attributedPlaceholder = string;
    _textField.delegate = self;
    _textField.layer.cornerRadius = 2.0;
}


@end