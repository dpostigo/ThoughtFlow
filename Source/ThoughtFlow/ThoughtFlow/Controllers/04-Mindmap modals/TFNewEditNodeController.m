//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFNewEditNodeController.h"
#import "MVPopupTransition.h"
#import "UIViewController+DPKit.h"
#import "TFNode.h"
#import "UIFont+ThoughtFlow.h"
#import "UIColor+TFApp.h"
#import "NSNotification+DPKit.h"
#import "UIView+DPKit.h"
#import "UIView+DPConstraints.h"
#import "UIControl+BlocksKit.h"


const NSInteger TFNewEditNodeControllerCharacterLimit = 40;

@interface TFNewEditNodeController ()

@property(nonatomic, strong) MVPopupTransition *animator;
@property(nonatomic) CGFloat startingValue;
@end

@implementation TFNewEditNodeController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Modals"];
}

- (id) init {
    return [self initWithNode: nil];
}


- (instancetype) initWithNode: (TFNode *) node {
    self = [super init];
    if (self) {
        _node = node;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        _animator = [MVPopupTransition createWithSize: [UIScreen mainScreen].bounds.size dimBackground: YES shouldDismissOnBackgroundViewTap: YES delegate: nil];

    }

    return self;
}


#pragma mark - View lifecycle




- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    _textView.text = _node.title;
    _textView.delegate = self;
    _textView.keyboardAppearance = UIKeyboardAppearanceDark;

    [self registerKeyboardWillShow: @selector(handleKeyboard:)];
    [self registerKeyboardWillHide: @selector(handleKeyboard:)];
    //    [self.view layoutIfNeeded];

    [self _refreshCharacterCount];

    [self _setupButtons];

}


- (void) _setupButtons {
    [_doneButton bk_addEventHandler: ^(id sender) {
        [self _notifyEditNodeControllerDismissedWithName: _textView.text];
        [self.presentingViewController dismissViewControllerAnimated: YES  completion: nil];
    } forControlEvents: UIControlEventTouchUpInside];

    [_trashButton bk_addEventHandler: ^(id sender) {

    } forControlEvents: UIControlEventTouchUpInside];

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [_textView becomeFirstResponder];

}



#pragma mark - Keyboard

- (void) handleKeyboard: (NSNotification *) notification {

    NSLayoutConstraint *centerConstraint = [_containerView superCenterYConstraint];
    CGFloat keyboardHeight = [notification keyboardHeight];
    if ([notification.name isEqualToString: UIKeyboardWillShowNotification]) {
        _startingValue = centerConstraint.constant;
        CGFloat newHeight = self.view.height - keyboardHeight;
        //        centerConstraint.constant = (newHeight - _containerView.height) / 2;
        //        centerConstraint.constant = newHeight / 2;
        //        centerConstraint.constant = (keyboardHeight - _containerView.height) / 2;
        centerConstraint.constant = keyboardHeight - (_containerView.height / 2);

    } else if ([notification.name isEqualToString: UIKeyboardWillHideNotification]) {
        centerConstraint.constant = _startingValue;
    }

    [UIView animateWithDuration: 0.4 animations: ^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions


- (IBAction) handleSave: (id) sender {
    [self _notifyEditNodeControllerDismissedWithName: _textView.text];
    [self.presentingViewController dismissViewControllerAnimated: YES  completion: nil];
}

- (IBAction) handleTrashButton: (UIButton *) button {

}



#pragma mark - Delegates
#pragma mark - UITextViewDelegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    return NO;
}

- (BOOL) textView: (UITextView *) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString *) text {
    if ([text isEqualToString: @"\n"]) {
        [self.view endEditing: YES];
        return NO;
    }
    return YES;
}


- (void) textViewDidChange: (UITextView *) textView {
    [self _refreshDoneButton];
    [self _refreshCharacterCount];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id) animationControllerForPresentedController: (UIViewController *) presented presentingController: (UIViewController *) presenting sourceController: (UIViewController *) source {
    return self.animator;
}

- (id) animationControllerForDismissedController: (UIViewController *) dismissed {
    return self.animator;
}


#pragma mark - Refresh

- (void) _refreshDoneButton {
    NSInteger characterCount = self.characterCount;
    _doneButton.enabled = (characterCount >= 0) && ([_textView.text length] > 0);
}

- (void) _refreshCharacterCount {
    NSInteger characterCount = self.characterCount;
    NSString *string = [NSString stringWithFormat: @"%i %@ LEFT", characterCount, fabsf(characterCount) == 1 ? @"CHARACTER" : @"CHARACTERS"];

    NSMutableDictionary *attributes = [[UIFont attributesForFont: [UIFont fontWithName: @"GothamRounded-Light" size: _charactersLabel.font.pointSize]] mutableCopy];
    if (characterCount < 0) {
        [attributes setObject: [UIColor tfRedColor] forKey: NSForegroundColorAttributeName];
    }

    _charactersLabel.attributedText = [[NSMutableAttributedString alloc] initWithString: string attributes: attributes];
}


- (NSInteger) characterCount {
    return TFNewEditNodeControllerCharacterLimit - [_textView.text length];

}

#pragma mark - Setup

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

#pragma mark - Private

- (void) _notifyEditNodeControllerDismissedWithName: (NSString *) name {
    if (_delegate && [_delegate respondsToSelector: @selector(editNodeController:didEditNode:withName:)]) {
        [_delegate editNodeController: self didEditNode: _node withName: name];
    }
}

@end