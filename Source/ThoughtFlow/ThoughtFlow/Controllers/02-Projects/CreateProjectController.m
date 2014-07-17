//
// Created by Dani Postigo on 4/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-UIFont/UIFont+DPKitFonts.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "CreateProjectController.h"
#import "DPFadeTransition.h"
#import "Model.h"
#import "Project.h"
#import "ProjectsController.h"
#import "TFCharacterCountTextField.h"
#import "TFNewEditNodeController.h"
#import "TFString.h"
#import "APIModel.h"
#import "UIView+DPKit.h"


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
    if ([_textField.text length] == 0) {
        [UIAlertView showWithTitle: @"Enter a word or phrase"
                message: @"Please enter a phrase to get started."
                cancelButtonTitle: @"OK" otherButtonTitles: nil
                tapBlock: nil];

        return;

    } else if (_textField.charactersLeft <= 0) {
        [UIAlertView showWithTitle: @"Too many characters"
                message: @"Please choose a shorter phrase."
                cancelButtonTitle: @"OK" otherButtonTitles: nil
                tapBlock: nil];

        return;
    }

    UIView *currentRightView = _textField.rightView;
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    NSLog(@"activityView.frame = %@", NSStringFromCGRect(activityView.frame));
    activityView.frame = CGRectMake(0, 0, _textField.height, _textField.height);
    [activityView startAnimating];
    _textField.rightView = activityView;

    NSString *string = _textField.text;
    [[APIModel sharedModel] hasImages: string completion: ^(BOOL hasImages) {

        if (hasImages) {
            Project *project = [[Project alloc] initWithWord: _textField.text];
            _model.selectedProject = project;
            [_model addProject: project];

            ProjectsController *controller = [[ProjectsController alloc] init];
            [self.navigationController setViewControllers: @[controller] animated: YES];

        } else {
            [activityView stopAnimating];
            [UIAlertView showWithTitle: @"No images found"
                    message: @"Sorry, we couldn't find any images for this particular phrase. Try another word or phrase."
                    cancelButtonTitle: @"OK" otherButtonTitles: nil
                    tapBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
                        _textField.rightView = currentRightView;
                        [_textField becomeFirstResponder];
                    }];

        }
    }];

}


#pragma mark UITextFieldDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    [self createProject];
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *) textField {

}


#pragma mark Validate


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    //    [super touchesBegan: touches withEvent: event];
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

    _textField.characterLabelSize = CGSizeMake(35, 0);
    _textField.characterLimit = TFNewEditNodeControllerCharacterLimit;
    _textField.characterCountInsets = UIEdgeInsetsMake(10, 10, 10, 0);

    _textField.updateBlock = ^(NSInteger charactersLeft) {
        NSDictionary *attributes = [TFString attributesWithAttributes: nil
                font: [UIFont gothamRoundedLightFontOfSize: 12.0]
                color: [UIColor colorWithWhite: 1.0 alpha: 0.3]
                kerning: 100
                lineSpacing: 0
                textAlignment: NSTextAlignmentLeft];

        NSString *characterString = [NSString stringWithFormat: @"%i", charactersLeft];
        _textField.textLabel.attributedText = [[NSAttributedString alloc] initWithString: characterString attributes: attributes];
    };

    _textField.leftView = [[UIView alloc] initWithFrame: _textField.rightView.bounds];
}


@end