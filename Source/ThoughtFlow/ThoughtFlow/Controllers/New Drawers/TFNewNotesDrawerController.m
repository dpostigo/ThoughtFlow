//
// Created by Dani Postigo on 7/8/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewNotesDrawerController.h"
#import "Project.h"
#import "TFDrawerNavigationController.h"
#import "TFCustomBarButtonItem.h"
#import "TFTranslucentView.h"
#import "UIView+DPKit.h"
#import "UIColor+TFApp.h"
#import "TFString.h"
#import "UIFont+DPKitFonts.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "TFBarButtonItem.h"


static NSString *TFNotesPlaceholderString = @"Add your project notes here...";

@interface TFNewNotesDrawerController ()

@property(nonatomic, strong) TFDrawerNavigationController *viewNavigationController;
@end

@implementation TFNewNotesDrawerController

- (instancetype) initWithProject: (Project *) project {
    self = [super init];
    if (self) {
        _project = project;
    }

    return self;
}


#pragma mark - View lifecycle

- (void) loadView {

    self.view = [[TFTranslucentView alloc] init];

    _innerController = [[UIViewController alloc] init];
    _innerController.navigationItem.leftBarButtonItem = [[TFCustomBarButtonItem alloc] initWithTitle: @"PROJECT NOTES" image: nil];

    _textView = [[UITextView alloc] init];
    _textView.textColor = [UIColor whiteColor];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
    _textView.editable = NO;
    [_innerController.view embedView: _textView withInsets: UIEdgeInsetsMake(10, 10, 10, 10)];

    _viewNavigationController = [[TFDrawerNavigationController alloc] initWithRootViewController: _innerController];
    _viewNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self embedFullscreenController: _viewNavigationController];

    [self _setupButton];
    [self _setupTextView];
    [self _setupProject];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    _recognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *) sender;
        if (sender.state == UIGestureRecognizerStateEnded) {
            if (![self.view pointInside: [self.view convertPoint: location fromView: self.view.window]
                    withEvent: nil]) {
                [_textView resignFirstResponder];
            }
        }
    }];
    self.recognizer.numberOfTapsRequired = 1;
    self.recognizer.cancelsTouchesInView = NO;
    [self.view.window addGestureRecognizer: self.recognizer];
}


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];
    [self.view.window removeGestureRecognizer: _recognizer];
}


#pragma mark - Delegates
#pragma mark - UITextViewDelegate


- (void) textViewDidBeginEditing: (UITextView *) textView {
    if ([textView.text isEqualToString: TFNotesPlaceholderString]) {
        textView.text = @"";
        textView.textColor = [UIColor tfOffWhiteColor];
    }

    [textView becomeFirstResponder];

}

- (void) textViewDidEndEditing: (UITextView *) textView {
    if ([textView.text isEqualToString: @""]) {
        textView.text = TFNotesPlaceholderString;
        textView.textColor = [UIColor darkGrayColor]; //optional
    }
    [textView resignFirstResponder];
}



#pragma mark - Setup


- (void) _setupProject {

    if (_project) {
        if (_project.notes == nil) {
            _textView.text = TFNotesPlaceholderString;
            _textView.textColor = [UIColor darkGrayColor];
        } else {
            _textView.text = _project.notes;
            _textView.textColor = [UIColor tfOffWhiteColor];
        }
    }
}

- (void) _setupTextView {

    NSDictionary *attributes = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 12.0]
            color: [UIColor whiteColor]
            kerning: 50
            lineSpacing: 1
            textAlignment: NSTextAlignmentLeft];

    [_textView setTypingAttributes: attributes];
}

- (void) _setupButton {

    //    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    //    [button setAttributedTitle: normalString forState: UIControlStateNormal];
    //    [button setAttributedTitle: selectedString forState: UIControlStateSelected];
    //    [button addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];
    //    button.width = 320;
    //    button.height = 44;
    //    [button sizeToFit];

    NSDictionary *normalAttributes = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 10.0]
            color: [UIColor whiteColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentLeft];

    NSDictionary *selectedAttributes = [TFString attributesWithAttributes: nil
            font: [UIFont gothamRoundedLightFontOfSize: 10.0]
            color: [UIColor tfGreenColor]
            kerning: 100
            lineSpacing: 1
            textAlignment: NSTextAlignmentRight];

    _innerController.navigationItem.leftBarButtonItem = [[TFBarButtonItem alloc] initWithTitle: @"PROJECT NOTES"];

    TFBarButtonItem *rightItem = [[TFBarButtonItem alloc] initWithButton: nil];
    [rightItem.button setAttributedTitle: [[NSAttributedString alloc] initWithString: @"EDIT" attributes: [TFBarButtonItem defaultAttributes]] forState: UIControlStateNormal];
    [rightItem.button setAttributedTitle: [[NSAttributedString alloc] initWithString: @"SAVE" attributes: selectedAttributes] forState: UIControlStateSelected];
    [rightItem.button sizeToFit];
    [rightItem.button addTarget: self action: @selector(handleButton:) forControlEvents: UIControlEventTouchUpInside];
    _innerController.navigationItem.rightBarButtonItem = rightItem;
}


- (IBAction) handleButton: (UIButton *) button {

    button.selected = !button.selected;

    if (button.selected) {

        if ([_textView.text isEqualToString: TFNotesPlaceholderString]) {
            _textView.text = @"";
        }
        _textView.editable = YES;
        [_textView becomeFirstResponder];
        _textView.textColor = [UIColor tfOffWhiteColor];

    } else {

        _textView.editable = NO;
        if ([_textView.text isEqualToString: @""]) {
            _textView.text = TFNotesPlaceholderString;
            _textView.textColor = [UIColor darkGrayColor];
        }

        _project.notes = _textView.text;
        [_project save];
    }
}


@end