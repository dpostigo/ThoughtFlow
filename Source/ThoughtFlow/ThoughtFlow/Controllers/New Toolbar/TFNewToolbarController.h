//
// Created by Dani Postigo on 6/29/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

typedef NS_ENUM(NSInteger, TFNewToolbarButtonType) {
    TFNewToolbarButtonTypeHome,
    TFNewToolbarButtonTypeProjects,
    TFNewToolbarButtonTypeNotes,
    TFNewToolbarButtonTypeMoodboard,
    TFNewToolbarButtonTypeImageSettings,
    TFNewToolbarButtonTypeAccount,
    TFNewToolbarButtonTypeInfo
};


@protocol TFNewToolbarControllerDelegate <NSObject>

@optional

- (void) toolbarControllerClickedButtonWithType: (TFNewToolbarButtonType) type;

@end


@interface TFNewToolbarController : TFViewController {

    __unsafe_unretained id <TFNewToolbarControllerDelegate> delegate;
}

@property(nonatomic) NSInteger selectedIndex;
@property(weak) IBOutlet UIView *buttonsView;
@property(nonatomic, assign) id <TFNewToolbarControllerDelegate> delegate;
@property(nonatomic, strong) NSArray *buttons;
- (UIButton *) buttonForType: (TFNewToolbarButtonType) type;
@end