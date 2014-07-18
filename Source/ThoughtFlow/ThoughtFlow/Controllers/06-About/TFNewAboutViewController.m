//
// Created by Dani Postigo on 7/12/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFNewAboutViewController.h"
#import "TFTranslucentView.h"
#import "UIView+DPKit.h"
#import "UIControl+BlocksKit.h"
#import "TFAboutLabelsViewController.h"


@interface TFNewAboutViewController ()

@property(nonatomic, strong) TFTranslucentView *bg;
@end

@implementation TFNewAboutViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Drawers"];
}


- (void) viewDidLoad {
    [super viewDidLoad];

    //    _labelContainerView.alpha = 0;
    //    _tutorialContainerView.alpha = 0;

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    self.view.layer.allowsGroupOpacity = NO;

    _bg = [[TFTranslucentView alloc] initWithFrame: self.view.bounds];
    [self.view embedView: _bg];
    [self.view sendSubviewToBack: _bg];

    TFAboutLabelsViewController *controller = [[TFAboutLabelsViewController alloc] init];
    [self embedController: controller inView: _labelContainerView];

    [self _setupButtons];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    //
    //    [UIView animateWithDuration: 1.0 animations: ^{
    //        //        _bg.alpha = 1;
    //        //        _tutorialContainerView.alpha = 1;
    //        //        _labelContainerView.alpha = 1;
    //    }];

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

}


#pragma mark - Setup

- (void) _setupButtons {
    [_closeButton bk_addEventHandler: ^(id sender) {
        [self _notifyDrawerControllerShouldDismiss];
    } forControlEvents: UIControlEventTouchUpInside];

}


@end