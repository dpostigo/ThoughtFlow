//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFBaseToolbarViewController.h"


typedef NS_ENUM(NSInteger, TFToolbarButtonType) {
    TFToolbarButtonTypeHome,
    TFToolbarButtonTypeProjects,
    TFToolbarButtonTypeNotes,
    TFToolbarButtonTypeMoodboard,
    TFToolbarButtonTypeImageSettings,
    TFToolbarButtonTypeAccount,
    TFToolbarButtonTypeInfo
};


@protocol TFToolbarViewControllerDelegate <NSObject>

@optional
- (void) toolbarControllerClickedButtonWithType: (TFToolbarButtonType) type;
@end


extern CGFloat const TFToolbarButtonWidth;
extern CGFloat const TFToolbarButtonHeight;

@interface TFToolbarViewController : TFBaseToolbarViewController

@property(nonatomic) NSInteger selectedIndex;
@property(nonatomic, assign) id <TFToolbarViewControllerDelegate> delegate;
- (UIButton *) buttonForType: (TFToolbarButtonType) type;
@end