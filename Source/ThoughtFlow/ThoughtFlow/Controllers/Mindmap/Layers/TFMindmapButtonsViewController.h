//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFMindmapButtonsViewController;

typedef NS_ENUM(NSInteger, TFMindmapButtonType) {
    TFMindmapButtonTypeGrid,
    TFMindmapButtonTypeInfo,
    TFMindmapButtonTypePin,
};

@protocol TFMindmapButtonsViewControllerDelegate <NSObject>

- (void) buttonsController: (TFMindmapButtonsViewController *) controller tappedButtonWithType: (TFMindmapButtonType) type;
@end;

@interface TFMindmapButtonsViewController : UIViewController

@property(nonatomic, assign) id <TFMindmapButtonsViewControllerDelegate> delegate;
@end