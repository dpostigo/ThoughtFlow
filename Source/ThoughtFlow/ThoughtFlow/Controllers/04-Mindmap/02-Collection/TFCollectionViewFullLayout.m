//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCollectionViewFullLayout.h"


@interface TFCollectionViewFullLayout ()

@property(nonatomic, strong) NSMutableArray *attributesArray;
@property(nonatomic) BOOL isTransitioning;
@end

@implementation TFCollectionViewFullLayout {

}

//- (void) _setup {
//
//    self.numberOfItemsPerLine = 1;
//    self.aspectRatio = self.collectionView.bounds.size.width / self.collectionView.bounds.size.height;
//    self.sectionInset = UIEdgeInsetsZero;
//    self.interitemSpacing = 0;
//    self.lineSpacing = 0;
//    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//
//}




- (void) _setup {

    self.itemSize = self.collectionView.bounds.size;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsZero;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

}


#pragma mark - Transition
- (void) prepareForTransitionToLayout: (UICollectionViewLayout *) newLayout {
    [super prepareForTransitionToLayout: newLayout];
    NSLog(@"%s, newLayout = %@", __PRETTY_FUNCTION__, newLayout);
}

- (void) prepareForTransitionFromLayout: (UICollectionViewLayout *) oldLayout {
    [super prepareForTransitionFromLayout: oldLayout];
    NSLog(@"%s, oldLayout = %@", __PRETTY_FUNCTION__, oldLayout);

    _isTransitioning = YES;

    if ([oldLayout isKindOfClass: [UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *) oldLayout;
    }

    [self invalidateLayout];

    //    [self _prepareAttributesArray];
    //    [self _setup];

}

- (void) finalizeLayoutTransition {
    [super finalizeLayoutTransition];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _isTransitioning = NO;
}



#pragma mark - Content offset

- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {

    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];


    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        NSIndexPath *indexPath = indexPaths[0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath: indexPath];

        point = attributes.frame.origin;
        DDLogVerbose(@"%s, proposedContentOffset = %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(proposedContentOffset));
        DDLogVerbose(@"%s, point = %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));

    }

    return point;
}

- (void) _prepareAttributesArray {
    if (_attributesArray == nil) {
        _attributesArray = [[NSMutableArray alloc] init];
    }
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    for (int j = 0; j < [indexPaths count]; j++) {
        NSIndexPath *indexPath = indexPaths[j];
        [_attributesArray addObject: [self layoutAttributesForItemAtIndexPath: indexPath]];
    }

    NSLog(@"_attributesArray = %@", _attributesArray);

}

- (void) prepareLayout {
    [super prepareLayout];

    if (!self.isTransitioning) {
        [self _setup];
    }

}


#pragma mark - Invalidate

- (void) invalidateLayout {
    [super invalidateLayout];
    [self _setup];
}


- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
    CGRect bounds = self.collectionView.bounds;
    return ((CGRectGetWidth(newBounds) != CGRectGetWidth(bounds) ||
            (CGRectGetHeight(newBounds) != CGRectGetHeight(bounds))));
}

//- (CGSize) collectionViewContentSize {
//    CGSize ret = [super collectionViewContentSize];
//    if (_isTransitioning) {
//        ret.height = self.itemSize.height * 3;
//    }
//    return ret;
//}


@end