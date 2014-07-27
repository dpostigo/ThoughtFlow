//
// Created by Dani Postigo on 7/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFCollectionTransitionLayout.h"
#import "TFCollectionViewFullLayout.h"


@interface TFCollectionTransitionLayout ()

@property(nonatomic) CGSize contentSize;
@property(nonatomic, strong) NSArray *fromAttributes;
@property(nonatomic, strong) NSArray *toAttributes;
@end

@implementation TFCollectionTransitionLayout {

}

//
//- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset withScrollingVelocity: (CGPoint) velocity {
//    return [super targetContentOffsetForProposedContentOffset: proposedContentOffset withScrollingVelocity: velocity];
//}
//
//- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
//
//    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];
//
//    if (!_isAnimating) {
//        return point;
//    }
//
//    if ([self.nextLayout isKindOfClass: [TFCollectionViewFullLayout class]]) {
//        DDLogVerbose(@"%s, proposedContentOffset = %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(proposedContentOffset));
//        DDLogVerbose(@"%s, point = %@", __PRETTY_FUNCTION__, NSStringFromCGPoint(point));
//
//        NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
//        if ([indexPaths count] == 1) {
//            NSIndexPath *indexPath = indexPaths[0];
//            NSLog(@"self.nextLayout = %@", self.nextLayout);
//
//            UICollectionViewLayoutAttributes *attributes = [self.nextLayout layoutAttributesForItemAtIndexPath: indexPath];
//
//            point = attributes.frame.origin;
//
//        }
//    }
//
//    return point;
//}
//
//
//- (void) setTransitionProgress: (CGFloat) transitionProgress {
//    [super setTransitionProgress: transitionProgress];
//    //    NSLog(@"%s, transitionProgress = %f", __PRETTY_FUNCTION__, transitionProgress);
//}
//
//
//#pragma mark - Transitioning
//
//
//- (void) prepareForTransitionFromLayout: (UICollectionViewLayout *) oldLayout {
//    [super prepareForTransitionFromLayout: oldLayout];
//
//    NSLog(@"%s, oldLayout = %@", __PRETTY_FUNCTION__, oldLayout);
//
//    _isAnimating = YES;
//    _fromAttributes = [self layoutAttributesVisibleItemsForLayout: oldLayout];
//
//}

- (void) prepareForTransitionToLayout: (UICollectionViewLayout *) newLayout {
    _isAnimating = YES;
    [super prepareForTransitionToLayout: newLayout];

    NSLog(@"%s, newLayout = %@", __PRETTY_FUNCTION__, newLayout);

    //    _toAttributes = [self layoutAttributesVisibleItemsForLayout: newLayout];
    //
    //    if (self.isAnimatingToFullscreen) {
    //        CGSize size = self.collectionView.bounds.size;
    //        _contentSize.width = size.width;
    //        _contentSize.height = size.height * 3;
    //        NSLog(@"_contentSize = %@", NSStringFromCGSize(_contentSize));
    //    }

}


//#pragma mark - Attributes
//
//- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
//    UICollectionViewLayoutAttributes *ret = [super layoutAttributesForItemAtIndexPath: indexPath];
//
//    if (self.isAnimatingToFullscreen) {
//        ret = _fromAttributes[indexPath.item];
//    }
//    return ret;
//}
//
//- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
//
//    NSArray *ret = [super layoutAttributesForElementsInRect: rect];
//    if (self.isAnimatingToFullscreen) {
//        return _fromAttributes;
//    }
//
//    return ret;
//}
//
//
//- (void) prepareLayout {
//    [super prepareLayout];
//}
//
//- (void) prepareForAnimatedBoundsChange: (CGRect) oldBounds {
//    [super prepareForAnimatedBoundsChange: oldBounds];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}
//
//
//- (void) finalizeLayoutTransition {
//    [super finalizeLayoutTransition];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    _isAnimating = NO;
//    //    self.collectionView.collectionViewLayout = self.nextLayout;
//}
//

- (CGSize) collectionViewContentSize {
    CGSize ret = self.collectionView.bounds.size;
    if (self.isAnimatingToFullscreen) {

        ret.height = ret.height * 3;
    }
    //    if (self.isAnimating) {
    //        //        ret.height = self.collectionView.bounds.size.height * 3;
    //        ret = _contentSize;
    //
    //    }
    return ret;
}

//
//#pragma mark - Utils
//
//- (NSArray *) layoutAttributesVisibleItemsForLayout: (UICollectionViewLayout *) oldLayout {
//    NSMutableArray *ret = [[NSMutableArray alloc] init];
//
//    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
//    for (int k = 0; k < [indexPaths count]; k++) {
//        NSIndexPath *indexPath = indexPaths[k];
//        [ret addObject: [oldLayout layoutAttributesForItemAtIndexPath: indexPath]];
//    }
//    return ret;
//}
//
//
- (BOOL) isAnimatingToFullscreen {
    return _isAnimating && [self.nextLayout isKindOfClass: [TFCollectionViewFullLayout class]];
}
//
//
//- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
//    return [super shouldInvalidateLayoutForBoundsChange: newBounds];
//}

@end