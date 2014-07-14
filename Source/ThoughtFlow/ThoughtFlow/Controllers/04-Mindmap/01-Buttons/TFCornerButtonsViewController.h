//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFCornerButtonsViewController;


typedef NS_ENUM(NSInteger, TFCornerType) {
    TFCornerTypeNone,
    TFCornerTypeTopLeft,
    TFCornerTypeTopRight,
    TFCornerTypeBottomRight,
    TFCornerTypeBottomLeft
};

@protocol TFCornerButtonsViewControllerDelegate  <NSObject>

- (void) buttonsController: (TFCornerButtonsViewController *) cornerButtonsViewController clickedButtonWithType: (TFCornerType) type;

@end

@interface TFCornerButtonsViewController : UIViewController {

}

@property(nonatomic) UIEdgeInsets edgeInsets;

@property(nonatomic, assign) id <TFCornerButtonsViewControllerDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIButton *topLeftButton;
@property(nonatomic, strong) IBOutlet UIButton *topRightButton;
@property(nonatomic, strong) IBOutlet UIButton *bottomLeftButton;
@property(nonatomic, strong) IBOutlet UIButton *bottomRightButton;
@end