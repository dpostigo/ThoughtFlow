//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFInfoViewController.h"
#import "UIView+DPKitChildren.h"
#import "UINavigationController+DPKit.h"
#import "MindmapController.h"

@implementation TFInfoViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    _imageSearchLabel.alpha = 0;
    [self hideLabels];

}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [self showLabels];
}

- (void) hideLabels {
    NSMutableArray *labels = [[self.view childrenOfClass: [UILabel class]] mutableCopy];
    for (int j = 0; j < [labels count]; j++) {
        UILabel *label = [labels objectAtIndex: j];
        label.alpha = 0;
    }
}

- (void) showLabels {
    UIViewController *controller = [self.navigationController controllerBeforeController: self];
    NSMutableArray *labels = [[self.view childrenOfClass: [UILabel class]] mutableCopy];

    [UIView animateWithDuration: 0.4
            delay: 0
            usingSpringWithDamping: 1.0
            initialSpringVelocity: 0.8
            options: UIViewAnimationOptionTransitionNone
            animations: ^{
                for (int j = 0; j < [labels count]; j++) {
                    UILabel *label = [labels objectAtIndex: j];

                    if (label == _notesLabel || label == _moodboardLabel) {
                        label.alpha = [controller isKindOfClass: [MindmapController class]] ? 1 : 0;
                    } else if (label == _imageSearchLabel) {
                        label.alpha = 0;
                    } else {
                        label.alpha = 1;
                    }
                }
            }
            completion: nil];
}

- (UIViewController *) previousController {
    UIViewController *ret = nil;
    NSUInteger index = [self.navigationController.viewControllers indexOfObject: self];

    if (index != -1 && index - 1 > 0) {
        ret = [self.navigationController.viewControllers objectAtIndex: index - 1];
    }
    return ret;

}
@end