//
// Created by Dani Postigo on 5/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "EditNodeController.h"
#import "UIView+TFFonts.h"
#import "Model.h"
#import "TFNode.h"
#import "UIFont+ThoughtFlow.h"
#import "UIColor+TFApp.h"

#define CHARACTER_LIMIT 20.0f

@implementation EditNodeController

- (void) viewDidLoad {
    [super viewDidLoad];

    dismisses = YES;

    _textView.text = _model.selectedNode.title;
    _textView.delegate = self;

    [self.view convertFonts];
    [self updateDoneButton];
}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    self.view.userInteractionEnabled = NO;
    [self updateCharactersLabel];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self performSelector: @selector(activateTextView) withObject: nil afterDelay: 0.1];
}

- (void) activateTextView {
    self.view.userInteractionEnabled = YES;
    [_textView becomeFirstResponder];

}

- (void) updateDoneButton {
    _doneButton.enabled = [_textView.text length] > 0;
}

- (void) updateCharactersLabel {
    CGFloat characterCount = CHARACTER_LIMIT - [_textView.text length];
    NSString *string = [NSString stringWithFormat: @"%.0f %@ LEFT", characterCount, fabsf(characterCount) == 1 ? @"CHARACTER" : @"CHARACTERS"];
    NSMutableDictionary *attributes = [[UIFont attributesForFont: [UIFont fontWithName: @"GothamRounded-Light" size: _charactersLabel.font.pointSize]] mutableCopy];
    if (characterCount < 0) {
        [attributes setObject: [UIColor tfRedColor] forKey: NSForegroundColorAttributeName];
    }
    _charactersLabel.attributedText = [[NSMutableAttributedString alloc] initWithString: string attributes: attributes];
}

#pragma mark IBActions


- (IBAction) handleSave: (id) sender {
    _model.selectedNode.title = _textView.text;
    [self.view removeGestureRecognizer: dismissRecognizer];
    [self.presentingViewController dismissViewControllerAnimated: YES  completion: nil];
}

#pragma mark UITextView delegate

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
    [self updateDoneButton];
    [self updateCharactersLabel];
}

@end