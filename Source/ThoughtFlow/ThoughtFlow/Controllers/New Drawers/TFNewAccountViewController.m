//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "TFNewAccountViewController.h"
#import "TFDrawerNavigationController.h"
#import "TFCustomBarButtonItem.h"
#import "TFTableViewController.h"
#import "TFTranslucentView.h"
#import "TFAccountDrawerController.h"
#import "TFBarButtonItem.h"


@interface TFNewAccountViewController ()

@property(nonatomic, strong) TFDrawerNavigationController *viewNavigationController;
@end

@implementation TFNewAccountViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        //        [self _setup];
    }

    return self;
}




#pragma mark - View lifecycle

- (void) loadView {
    self.view = [[TFTranslucentView alloc] init];

    _containerController = [[UIViewController alloc] init];
    _containerController.view.backgroundColor = [UIColor redColor];

    TFAccountDrawerController *controller = [[TFAccountDrawerController alloc] init];
    controller.view.backgroundColor = [UIColor clearColor];
    controller.view.opaque = NO;
    [controller.signOutButton addTarget: self action: @selector(handleSignOutButton:) forControlEvents: UIControlEventTouchUpInside];

    BOOL embed = NO;
    if (embed) {

        [_containerController embedFullscreenController: controller withInsets: UIEdgeInsetsMake(10, 0, 0, 0)];
        _viewNavigationController = [[TFDrawerNavigationController alloc] initWithRootViewController: _containerController];

    } else {
        _viewNavigationController = [[TFDrawerNavigationController alloc] initWithRootViewController: controller];

    }

    _viewNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self embedFullscreenController: _viewNavigationController];

    [self _setupNavItems];

}

- (void) viewDidLoad {
    [super viewDidLoad];

}


#pragma mark - Actions

- (IBAction) handleSignOutButton: (UIButton *) button {

    [UIAlertView showWithTitle: @"Sign Out"
            message: @"Are you sure you'd like to sign out?"
            cancelButtonTitle: @"No" otherButtonTitles: @[@"Yes"]
            tapBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != alertView.cancelButtonIndex) {
                    [self _notifyClickedSignOutButton: button];
                }
            }];

}

#pragma mark - Setup

- (void) _setup {

}

- (void) _setupNavItems {
    UIViewController *controller = _viewNavigationController.visibleViewController;
    controller.navigationItem.leftBarButtonItem = [[TFBarButtonItem alloc] initWithTitle: @"YOUR ACCOUNT"];

    TFBarButtonItem *rightItem = [[TFBarButtonItem alloc] initWithButton: [TFBarButtonItem closeButton]];
    [rightItem.button addTarget: self action: @selector(closeDrawer:) forControlEvents: UIControlEventTouchUpInside];
    controller.navigationItem.rightBarButtonItem = rightItem;

}


- (void) _notifyClickedSignOutButton: (UIButton *) button {

    if (_delegate && [_delegate respondsToSelector: @selector(accountViewController:clickedSignOutButton:)]) {
        [_delegate accountViewController: self clickedSignOutButton: button];
    }
}
@end