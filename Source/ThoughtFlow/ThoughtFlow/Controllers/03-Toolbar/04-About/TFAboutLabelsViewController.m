//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <sys/ucred.h>
#import "TFAboutLabelsViewController.h"
#import "TFToolbarViewController.h"
#import "TFNewKernedGothamLightLabel.h"
#import "UIView+DPKitDebug.h"


@implementation TFAboutLabelsViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.insets = UIEdgeInsetsMake(0, 15, 0, 10);
    }

    return self;
}

- (void) loadView {

    self.view = [[UIView alloc] init];

    NSArray *strings = @[
            @"",
            @"All Projects",
            @"View / edit project notes",
            @"View / edit moodboard",
            @"Account",
            @"Settings",
            @"Info / Help"
    ];

    NSMutableArray *labels = [[NSMutableArray alloc] init];
    for (int j = 0; j < [strings count]; j++) {
        NSString *string = strings[j];
        //        UILabel *label = [[UILabel alloc] init];
        TFNewKernedGothamLightLabel *label = [[TFNewKernedGothamLightLabel alloc] init];
        label.pointSize = 10.0;
        label.textColor = [UIColor whiteColor];
        label.text = [string uppercaseString];
        [labels addObject: label];

    }

    self.items = labels;
}

@end