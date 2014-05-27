//
// Created by Dani Postigo on 5/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-UIView/UIView+DPConstraints.h>
#import "TFInfoRightController.h"
#import "UIColor+TFApp.h"
#import "UIView+TFFonts.h"

@implementation TFInfoRightController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    UIView *dividerView = [[UIView alloc] initWithFrame: self.view.bounds];
    dividerView.width = self.view.width + 100;
    dividerView.height = self.view.height + 100;
    dividerView.layer.borderColor = [UIColor tfToolbarBorderColor].CGColor;
    dividerView.layer.borderWidth = 0.5;
    [self.view addSubview: dividerView];
    [self.view sendSubviewToBack: dividerView];

    dividerView.translatesAutoresizingMaskIntoConstraints = NO;
    [dividerView updateSuperCenterYConstraint: 0];
    [dividerView updateSuperHeightConstraint: -100];
    [dividerView updateSuperLeadingConstraint: 0];
    [dividerView updateSuperTrailingConstraint: -100];

    [self.view convertFonts];

    [self setupDescriptionLabel];

}



- (void) setupDescriptionLabel {
    NSMutableDictionary *attributes = [[_descriptionLabel.attributedText attributesAtIndex: 0 effectiveRange: NULL] mutableCopy];

    NSMutableParagraphStyle *paragraphStyle = [[attributes objectForKey: NSParagraphStyleAttributeName] mutableCopy];
    paragraphStyle.lineSpacing = 24 - 18;

    [attributes setObject: paragraphStyle forKey: NSParagraphStyleAttributeName];
    _descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString: _descriptionLabel.text attributes: attributes];
}

- (IBAction) handleCloseButton: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}

@end