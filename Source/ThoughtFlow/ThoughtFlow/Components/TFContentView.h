//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFNewDrawerController.h"

@class TFContentView;


@protocol TFContentViewDelegate <NSObject>

@optional
- (void) contentView: (TFContentView *) contentView didOpenLeftController: (TFNewDrawerController *) leftController;
- (void) contentView: (TFContentView *) contentView didOpenRightController: (TFNewDrawerController *) rightController;
- (void) contentView: (TFContentView *) contentView didCloseLeftController: (TFNewDrawerController *) leftController;
- (void) contentView: (TFContentView *) contentView didCloseRightController: (TFNewDrawerController *) rightController;
@end

@interface TFContentView : UIView <TFNewDrawerControllerDelegate> {
}

@property(nonatomic, strong) TFNewDrawerController *leftDrawerController;
@property(nonatomic, strong) TFNewDrawerController *rightDrawerController;
@property(nonatomic, strong) UIView *leftContainerView;
@property(nonatomic, strong) UIView *rightContainerView;
@property(nonatomic, assign) id <TFContentViewDelegate> delegate;
- (void) openLeftContainer;
- (void) openLeftContainer: (void (^)()) completion;
- (void) openRightContainer;
- (void) openRightContainer: (void (^)()) completion;
@end