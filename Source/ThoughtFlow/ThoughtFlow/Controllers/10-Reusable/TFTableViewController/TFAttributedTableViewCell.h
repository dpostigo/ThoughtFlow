//
// Created by Dani Postigo on 7/18/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFTableViewCell.h"


@class DTAttributedLabel;


@interface TFAttributedTableViewCell : TFTableViewCell {

}

@property (weak) IBOutlet DTAttributedLabel *attributedLabel;
@end