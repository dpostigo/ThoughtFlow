//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MVPopupTransition;
@protocol TFEditNodeControllerDelegate;
@class TFNewEditNodeController;
@class TFNode;


@protocol TFNewEditNodeControllerDelegate <NSObject>

- (void) editNodeController: (TFNewEditNodeController *) controller didEditNode: (TFNode *) node withName: (NSString *) name;

@end


@interface TFNewEditNodeController : UIViewController <UIViewControllerTransitioningDelegate, UITextViewDelegate> {
    CGFloat _startingValue;
}

@property(weak) IBOutlet UIView *containerView;
@property(weak) IBOutlet UIButton *doneButton;
@property(weak) IBOutlet UITextView *textView;
@property(weak) IBOutlet UILabel *charactersLabel;

@property(nonatomic, assign) id <TFNewEditNodeControllerDelegate> delegate;
@property(nonatomic, strong) TFNode *node;
@property(nonatomic) CGFloat startingValue;
- (instancetype) initWithNode: (TFNode *) node;

@end