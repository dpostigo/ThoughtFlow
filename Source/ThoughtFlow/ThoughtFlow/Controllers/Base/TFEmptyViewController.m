//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFEmptyViewController.h"


@implementation TFEmptyViewController

- (instancetype) initWithTitle: (NSString *) title {
    return [self initWithTitle: title subtitle: @""];
}


- (instancetype) initWithTitle: (NSString *) title subtitle: (NSString *) subtitle {
    TFEmptyViewController *ret = [[UIStoryboard storyboardWithName: @"Moodboard" bundle: nil] instantiateViewControllerWithIdentifier: @"TFEmptyViewController"];
    ret.textLabel.text = title;
    ret.detailTextLabel.text = @"";
    return ret;

}


- (void) viewDidLoad {
    [super viewDidLoad];

    [self _setupView];

}

- (void) _setupView {

    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}

@end