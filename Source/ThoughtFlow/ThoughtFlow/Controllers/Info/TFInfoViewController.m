//
// Created by Dani Postigo on 5/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFInfoViewController.h"
#import "UIView+DPKitChildren.h"
#import "UINavigationController+DPKit.h"
#import "MindmapController.h"
#import "TFTranslucentView.h"
#import "UIView+DPKit.h"


@implementation TFInfoViewController



#pragma mark - View lifecycle


//- (void) loadView {
//    [super loadView];
//    //
//
//    //    TFTranslucentView *bg = [[TFTranslucentView alloc] init];
//    //    [self.view embedView: bg];
//    //    [self.view sendSubviewToBack: bg];
//}

- (void) viewDidLoad {
    [super viewDidLoad];
    _imageSearchLabel.alpha = 0;
    [self hideLabels];

    //    [self _setup];


}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [self showLabels];
}


#pragma mark - Labels

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


#pragma mark - Setup


- (void) _setup {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

@end