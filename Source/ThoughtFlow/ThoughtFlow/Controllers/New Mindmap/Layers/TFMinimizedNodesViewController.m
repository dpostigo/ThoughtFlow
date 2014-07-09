//
// Created by Dani Postigo on 7/7/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/DPPassThroughView.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import "TFMinimizedNodesViewController.h"
#import "TFNode.h"
#import "Project.h"
#import "TFMinimizedNodeButton.h"
#import "TFNodesViewController.h"
#import "TFNodeView.h"
#import "UIView+DPKitDebug.h"


CGFloat const TFMindmapMinimizedX = 10;
CGFloat const TFMindmapMinimizedOffsetY = 10;

@interface TFMinimizedNodesViewController ()

@property(nonatomic, strong) TFMinimizedNodeButton *nodeButton;
@end

@implementation TFMinimizedNodesViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {
        self.view = [[DPPassThroughView alloc] init];
        [self _setup];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    NSLog(@"%s", __PRETTY_FUNCTION__);
}


#pragma mark - View lifecycle
- (void) viewDidLoad {
    [super viewDidLoad];
    [self _setup];
}


- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [_nodeButton animateIn: nil];

}


- (void) animateOut: (void (^)()) completion {
    [_nodeButton animateOut: ^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - IBActions


- (void) handleNodeButton: (UIButton *) button {
    [self _notifyDidUnpinch];
}



#pragma mark - Setup

- (void) _setup {

    _nodeButton = [TFMinimizedNodeButton buttonWithType: UIButtonTypeCustom];
    _nodeButton.frame = CGRectMake(TFMindmapMinimizedX, self.view.height - TFNodeViewHeight, TFNodeViewWidth, TFNodeViewHeight);
    [self.view addSubview: _nodeButton];
    [_nodeButton addTarget: self action: @selector(handleNodeButton:) forControlEvents: UIControlEventTouchUpInside];
    _nodeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _nodeButton attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: self.view attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: TFMindmapMinimizedX],
            [NSLayoutConstraint constraintWithItem: _nodeButton attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: self.bottomLayoutGuide attribute: NSLayoutAttributeTop multiplier: 1.0 constant: -TFMindmapMinimizedOffsetY]

    ]];

}
#pragma mark - Private

- (void) _notifyDidUnpinch {
    if (self.delegate && [self.delegate respondsToSelector: @selector(nodesControllerDidUnpinchWithNodeView:forNode:)]) {
        [self.delegate nodesControllerDidUnpinchWithNodeView: nil forNode: _node];
    }
}
@end