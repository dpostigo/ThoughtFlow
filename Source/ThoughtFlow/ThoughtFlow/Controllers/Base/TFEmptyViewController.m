//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFEmptyViewController.h"


@implementation TFEmptyViewController

- (instancetype) initWithTitle: (NSString *) title {
    return [self initWithTitle: title subtitle: @""];
}

- (instancetype) initWithTitle: (NSString *) title subtitle: (NSString *) subtitle {
    self = [super init];
    if (self) {
        self.title = title;
        _subtitle = subtitle;

    }

    return self;
}

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Misc"];
}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupView];

    _textLabel.text = self.title;
    _detailTextLabel.text = _subtitle;

}

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

@end