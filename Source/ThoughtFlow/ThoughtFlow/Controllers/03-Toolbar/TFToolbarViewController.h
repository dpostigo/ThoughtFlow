//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"


typedef NS_ENUM(NSInteger, TFToolbarButtonType) {
    TFNewToolbarButtonTypeHome,
    TFNewToolbarButtonTypeProjects,
    TFNewToolbarButtonTypeNotes,
    TFNewToolbarButtonTypeMoodboard,
    TFNewToolbarButtonTypeImageSettings,
    TFNewToolbarButtonTypeAccount,
    TFNewToolbarButtonTypeInfo
};


@protocol TFToolbarViewControllerDelegate <NSObject>

@optional
- (void) toolbarControllerClickedButtonWithType: (TFToolbarButtonType) type;
@end


@interface TFToolbarViewController : TFViewController {
}

@property(nonatomic) NSInteger selectedIndex;
@property(weak) IBOutlet UIView *buttonsView;
@property(nonatomic, assign) id <TFToolbarViewControllerDelegate> delegate;
@property(nonatomic, strong) NSArray *buttons;

- (UIButton *) buttonForType: (TFToolbarButtonType) type;
@end