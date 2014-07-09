//
// Created by Dani Postigo on 6/15/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFMindmapButtonsViewController;
@class TFPhoto;
@class Project;

typedef NS_ENUM(NSInteger, TFMindmapButtonType) {
    TFMindmapButtonTypeGrid,
    TFMindmapButtonTypeInfo,
    TFMindmapButtonTypePin,
};

@protocol TFMindmapButtonsViewControllerDelegate <NSObject>

- (void) buttonsController: (TFMindmapButtonsViewController *) controller tappedButtonWithType: (TFMindmapButtonType) type;
@end;

@interface TFMindmapButtonsViewController : UIViewController

@property(weak) IBOutlet UIButton *gridButton;
@property(weak) IBOutlet UIButton *infoButton;
@property(weak) IBOutlet UIButton *pinButton;

@property(nonatomic, assign) id <TFMindmapButtonsViewControllerDelegate> delegate;
- (void) updatePinButtonForImage: (TFPhoto *) image inProject: (Project *) project;
- (UIButton *) buttonForType: (TFMindmapButtonType) type;
@end