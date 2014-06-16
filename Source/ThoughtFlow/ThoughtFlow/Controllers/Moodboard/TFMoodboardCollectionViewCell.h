//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPCollectionViewCell.h"

@interface TFMoodboardCollectionViewCell : DPCollectionViewCell {

}

@property (weak) IBOutlet UIView *buttonsView;
@property (weak) IBOutlet UIButton *button;
@property (weak) IBOutlet UIButton *infoButton;
@property (weak) IBOutlet UIButton *deleteButton;
@end