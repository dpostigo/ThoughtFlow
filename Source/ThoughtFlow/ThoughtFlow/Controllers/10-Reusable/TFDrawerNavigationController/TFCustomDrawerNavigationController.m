//
// Created by Dani Postigo on 7/18/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCustomDrawerNavigationController.h"
#import "TFNavigationBar.h"


@interface TFCustomDrawerNavigationController ()

@property(nonatomic, strong) TFNavigationBar *customNavigationBar;
@end

@implementation TFCustomDrawerNavigationController

- (id) initWithRootViewController: (UIViewController *) rootViewController {
    self = [super initWithRootViewController: rootViewController];
    if (self) {

        _customNavigationBar = [[TFNavigationBar alloc] init];

        if (ALT_STYLING) {
            [self setValue: _customNavigationBar forKeyPath: @"navigationBar"];
        }

        self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }

    return self;
}

- (void) setNavigationBarHeight: (CGFloat) navigationBarHeight {
    _navigationBarHeight = navigationBarHeight;
    _customNavigationBar.customHeight = navigationBarHeight;
}


@end