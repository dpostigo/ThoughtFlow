//
// Created by Dani Postigo on 7/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

@interface TFMindmapLayout : UICollectionViewLayout

//@property(nonatomic) BOOL isFakeGrid;

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic) BOOL isFullscreen;

@property(nonatomic) NSInteger numberOfRows;
@property(nonatomic) CGSize itemSize;
@property(nonatomic) CGFloat spacing;
@property(nonatomic) UIEdgeInsets sectionInset;
@property(nonatomic, strong) NSMutableArray *attributesArray;

- (void) setIsFullscreen: (BOOL) isFullscreen withCollectionView: (UICollectionView *) collectionView;
@end