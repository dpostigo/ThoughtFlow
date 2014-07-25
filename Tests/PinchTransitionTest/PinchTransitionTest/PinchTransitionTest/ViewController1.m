//
// Created by Dani Postigo on 7/22/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ViewController1.h"
#import "UIControl+BlocksKit.h"
#import "ViewController2.h"
#import "UIView+DPKit.h"


@implementation ViewController1

- (void) loadView {
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blueColor];

    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.view embedView: button];

    [button bk_addEventHandler: ^(id sender) {
        [self.navigationController pushViewController: [[ViewController2 alloc] init] animated: YES];

    } forControlEvents: UIControlEventTouchUpInside];
}

@end