//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-UIView/UIView+DPKitChildren.h>
#import "TFNewAboutViewController.h"
#import "TFTranslucentView.h"
#import "UINavigationController+DPKit.h"
#import "UIView+DPKit.h"
#import "UIControl+BlocksKit.h"


@interface TFNewAboutViewController ()

@property(nonatomic, strong) TFTranslucentView *bg;
@end

@implementation TFNewAboutViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Drawers"];
}


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    _bg = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
    [self.view embedView: _bg];
    [self.view sendSubviewToBack: _bg];

    _containerView.alpha = 0;
    _bg.alpha = 0;
    _imageSearchLabel.alpha = 0;

    [self _setupButtons];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    [UIView animateWithDuration: 1.0 animations: ^{
        _bg.alpha = 1;
        _containerView.alpha = 1;
    }];
}


#pragma mark - Setup

- (void) _setupButtons {
    [_closeButton bk_addEventHandler: ^(id sender) {
        [self _notifyDrawerControllerShouldDismiss];
    } forControlEvents: UIControlEventTouchUpInside];

}

- (void) hideLabels {
    NSMutableArray *labels = [[self.view childrenOfClass: [UILabel class]] mutableCopy];
    for (int j = 0; j < [labels count]; j++) {
        UILabel *label = [labels objectAtIndex: j];
        label.alpha = 0;
    }
}

- (void) showLabels {
    NSMutableArray *labels = [[self.view childrenOfClass: [UILabel class]] mutableCopy];

    [UIView animateWithDuration: 0.4
            delay: 0
            usingSpringWithDamping: 1.0
            initialSpringVelocity: 0.8
            options: UIViewAnimationOptionTransitionNone
            animations: ^{
                for (int j = 0; j < [labels count]; j++) {
                    UILabel *label = [labels objectAtIndex: j];

                    //                    if (label == _notesLabel || label == _moodboardLabel) {
                    //                        label.alpha = [controller isKindOfClass: [TFMindmapViewController class]] ? 1 : 0;
                    //                    } else if (label == _imageSearchLabel) {
                    //                        label.alpha = 0;
                    //                    } else {
                    //                        label.alpha = 1;
                    //                    }

                    if (label == _imageSearchLabel) {
                        label.alpha = 0;
                    } else {
                        label.alpha = 1;
                    }
                }
            }
            completion: nil];
}


@end