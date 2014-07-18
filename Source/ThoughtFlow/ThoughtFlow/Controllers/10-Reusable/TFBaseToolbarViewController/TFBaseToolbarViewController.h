//
// Created by Dani Postigo on 7/17/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


extern CGFloat const TFToolbarButtonWidth;
extern CGFloat const TFToolbarButtonHeight;

@interface TFBaseToolbarViewController : UIViewController {

}

@property(nonatomic) UIEdgeInsets insets;
@property(nonatomic) CGFloat homeButtonHeight;
@property(nonatomic) CGFloat interitemSpacing;
@property(nonatomic, strong) NSArray *items;


- (UIView *) itemAtIndex: (NSUInteger) index1;
@end