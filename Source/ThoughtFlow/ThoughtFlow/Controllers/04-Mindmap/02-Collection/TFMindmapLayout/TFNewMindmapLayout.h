//
// Created by Dani Postigo on 7/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFNewMindmapLayout : UICollectionViewLayout {

}

@property(nonatomic) BOOL updatesTargetedOffset;
@property(nonatomic) BOOL updatesContentOffset;
@property(nonatomic) CGSize itemSize;
@property(nonatomic) NSInteger numberOfRows;
- (void) startDynamicTransition;
@end