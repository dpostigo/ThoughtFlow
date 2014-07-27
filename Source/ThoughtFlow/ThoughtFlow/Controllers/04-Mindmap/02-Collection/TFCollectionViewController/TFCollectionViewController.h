//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFCollectionViewFullLayout;
@class TFCollectionViewGridLayout;

extern NSString *const TFCollectionViewAnimationDataKey;

@interface TFCollectionViewController : UICollectionViewController

@property(nonatomic) BOOL isFullscreen;
@property(nonatomic, strong) Class cellClass;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) TFCollectionViewFullLayout *fullLayout;
@property(nonatomic, strong) TFCollectionViewGridLayout *gridLayout;
- (void) transitionToLayout: (UICollectionViewLayout *) layout duration: (CGFloat) duration completion: (void (^)(BOOL completed, BOOL finished)) completion;
@end