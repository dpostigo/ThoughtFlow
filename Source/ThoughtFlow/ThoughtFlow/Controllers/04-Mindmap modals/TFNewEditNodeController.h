//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MVPopupTransition;
@class TFNewEditNodeController;
@class TFNode;


@protocol TFNewEditNodeControllerDelegate <NSObject>

- (void) editNodeController: (TFNewEditNodeController *) controller didEditNode: (TFNode *) node withName: (NSString *) name;
@end


extern const NSInteger TFNewEditNodeControllerCharacterLimit;

@interface TFNewEditNodeController : UIViewController <UITextViewDelegate, UIViewControllerTransitioningDelegate> {
}

@property(weak) IBOutlet UIView *containerView;
@property(weak) IBOutlet UIButton *doneButton;
@property(weak) IBOutlet UIButton *trashButton;
@property(weak) IBOutlet UITextView *textView;
@property(weak) IBOutlet UILabel *charactersLabel;

@property(nonatomic, assign) id <TFNewEditNodeControllerDelegate> delegate;
@property(nonatomic, strong) TFNode *node;
- (instancetype) initWithNode: (TFNode *) node;

@end