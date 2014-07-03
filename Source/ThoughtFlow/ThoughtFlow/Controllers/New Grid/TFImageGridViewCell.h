//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFImageGridViewCell : UICollectionViewCell

@property(nonatomic) UIEdgeInsets edgeInsets;

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UIButton *topLeftButton;
@property(nonatomic, strong) IBOutlet UIButton *topRightButton;
@property(nonatomic, strong) IBOutlet UIButton *bottomLeftButton;
@property(nonatomic, strong) IBOutlet UIButton *bottomRightButton;
@property(nonatomic, strong) IBOutlet UIView *overlayView;

@property(weak) IBOutlet UIView *buttonsView;
@property(weak) IBOutlet UIButton *button;
@property(weak) IBOutlet UIButton *infoButton;
@property(weak) IBOutlet UIButton *deleteButton;
@end