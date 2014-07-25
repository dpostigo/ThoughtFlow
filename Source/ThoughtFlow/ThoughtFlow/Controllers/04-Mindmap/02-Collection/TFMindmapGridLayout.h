//
// Created by Dani Postigo on 7/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFMindmapGridLayout : UICollectionViewLayout

//@property(nonatomic) BOOL isFakeGrid;

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic) BOOL isFullscreen;

@property(nonatomic) NSInteger numberOfRows;
@property(nonatomic) CGSize itemSize;
@property(nonatomic) UIEdgeInsets sectionInset;
@property(nonatomic, strong) NSMutableArray *attributesArray;
- (instancetype) initWithCollection: (UICollectionView *) collection;

- (void) setIsFullscreen: (BOOL) isFullscreen withCollectionView: (UICollectionView *) collectionView;
@end