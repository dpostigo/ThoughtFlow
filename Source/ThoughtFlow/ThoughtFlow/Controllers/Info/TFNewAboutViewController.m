//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-UIView/UIView+DPKitChildren.h>
#import "TFNewAboutViewController.h"
#import "TFTranslucentView.h"
#import "TFTranslucentView.h"
#import "UINavigationController+DPKit.h"
#import "MindmapController.h"
#import "UIView+DPKit.h"


@interface TFNewAboutViewController ()

@property(nonatomic, strong) TFTranslucentView *bg;
@end

@implementation TFNewAboutViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Drawers"];
}

//- (void) loadView {
//    [super loadView];
//    //    self.view.backgroundColor = [UIColor clearColor];
//    //    self.view.opaque = NO;
//    //    //    //    self.view.opaque = NO;
//    //    //
//    //    //    //    _bg = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
//    //    //    //    [self embedFullscreenView: _bg];
//    //    //    //    [self.view sendSubviewToBack: _bg];
//}


- (void) viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;

    _containerView.alpha = 0;

    _bg = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
    [_containerView embedView: _bg];
    [_containerView sendSubviewToBack: _bg];

    _imageSearchLabel.alpha = 0;
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    [UIView animateWithDuration: 1.0 animations: ^{
        _containerView.alpha = 1;
    }];
}


#pragma mark - Setup


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


@end