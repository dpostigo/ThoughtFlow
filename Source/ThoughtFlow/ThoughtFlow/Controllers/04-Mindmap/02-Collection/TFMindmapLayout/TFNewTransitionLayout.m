//
// Created by Dani Postigo on 7/27/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <TLLayoutTransitioning/UICollectionView+TLTransitioning.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import "TFNewTransitionLayout.h"
#import "TFNewMindmapLayout.h"


@interface TFNewTransitionLayout ()

@property(nonatomic, strong) CALayer *layer;
@property(nonatomic) BOOL isTransitioning;
@property(nonatomic) NSInteger numberOfRows;
@property(nonatomic) CGSize interpolatedSize;
@property(nonatomic) CGSize toItemSize;
@property(nonatomic) CGSize fromItemSize;

@property(nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation TFNewTransitionLayout

- (id) initWithCurrentLayout: (UICollectionViewLayout *) currentLayout nextLayout: (UICollectionViewLayout *) newLayout {
    self = [super initWithCurrentLayout: currentLayout nextLayout: newLayout];
    if (self) {

        _numberOfRows = 3;
        TFNewMindmapLayout *layout;
        if ([newLayout isKindOfClass: [TFNewMindmapLayout class]]) {
            layout = (TFNewMindmapLayout *) newLayout;
            _toItemSize = layout.itemSize;
        }

        if ([currentLayout isKindOfClass: [TFNewMindmapLayout class]]) {
            layout = (TFNewMindmapLayout *) currentLayout;
            _fromItemSize = layout.itemSize;
        }

        _layer = [CALayer layer];
        _layer.delegate = self;
        _layer.borderWidth = 1;
        _layer.borderColor = [UIColor redColor].CGColor;
    }

    return self;
}

- (void) setTransitionProgress: (CGFloat) transitionProgress {
    self.progress = transitionProgress;
    CGFloat heightDifference = _toItemSize.height - _fromItemSize.height;
    CGFloat interpolatedHeight = _fromItemSize.height + (heightDifference * self.progress);

    CGFloat widthDifference = _toItemSize.width - _fromItemSize.width;
    CGFloat interpolatedWidth = _fromItemSize.width + (widthDifference * self.progress);

    _interpolatedSize = CGSizeMake(interpolatedWidth, interpolatedHeight);
    [super setTransitionProgress: transitionProgress];


    //    CGFloat minHeight = self.collectionView.height / 3;
    //    CGFloat maxHeight = self.collectionView.height;
    //    CGFloat heightRange = maxHeight - minHeight;
    //
    //    CGFloat currentHeight = maxHeight - (heightRange * transitionProgress);
    //    currentHeight = fmaxf(currentHeight, minHeight);
    //    currentHeight = fminf(currentHeight, maxHeight);
    //
    //    CGFloat minWidth = minHeight;
    //    CGFloat maxWidth = self.collectionView.width;
    //    CGFloat widthRange = maxWidth - minWidth;
    //
    //    CGFloat currentWidth = maxWidth - (widthRange * transitionProgress);
    //    currentWidth = fmaxf(currentWidth, minWidth);
    //    currentWidth = fminf(currentWidth, maxWidth);
    //
    //
    //    tempLayout.itemSize = CGSizeMake(currentWidth, currentHeight);

}


- (void) prepareLayout {
    [super prepareLayout];
    //    NSLog(@"%s", __PRETTY_FUNCTION__);




    CGPoint contentOffset = self.collectionView.contentOffset;
    //    NSLog(@"contentOffset = %@", NSStringFromCGPoint(contentOffset));
}


- (void) invalidateLayout {
    [super invalidateLayout];
    //    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        _selectedIndexPath = indexPaths[0];
    } else {
        _selectedIndexPath = nil;
    }
}


- (CGSize) collectionViewContentSize {

    CGSize ret;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    CGFloat numColumns = ceilf(itemCount / _numberOfRows);
    ret.width = numColumns * _interpolatedSize.width;
    ret.height = _numberOfRows * _interpolatedSize.height;
    return ret;

}

- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
    //    NSLog(@"%s, newBounds = %@", __PRETTY_FUNCTION__, NSStringFromCGRect(newBounds));
    CGRect bounds = self.collectionView.bounds;
    return NO;
    return !CGRectEqualToRect(bounds, newBounds);
}

- (void) dealloc {
    _layer.delegate = nil;

}


- (id <CAAction>) actionForLayer: (CALayer *) layer forKey: (NSString *) event {
    return (id) [NSNull null]; // disable all implicit animations
}

#pragma mark - Layout Attributes

- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;

    //    visibleRect = CGRectInset(visibleRect, -_interpolatedSize.width, -_interpolatedSize.height);
    //    visibleRect = CGRectInset(visibleRect, 10, 10);
    visibleRect.size.width += 10;
    visibleRect.size.height += 10;
    //    NSLog(@"visibleRect = %@", NSStringFromCGRect(visibleRect));

    [self.collectionView.layer addSublayer: _layer];
    _layer.frame = visibleRect;

    NSArray *ret = [self _layoutAttributesForElementsInRect: visibleRect];


    //    CGAffineTransform transform = CGAffineTransformMakeScale(1, self.transitionProgress);
    //    for (UICollectionViewLayoutAttributes *attributes in ret) {
    //        if ([attributes.indexPath isEqual: selectedIndexPath]) {
    //            attributes.alpha = 1;
    //            //            attributes.transform = CGAffineTransformIdentity;
    //
    //        } else {
    //            //            attributes.alpha = self.transitionProgress;
    //            //            attributes.transform = transform;
    //        }
    //    }

    //    NSLog(@"%s, [ret count] = %u, visibleRect = %@",
    //            __PRETTY_FUNCTION__,
    //            [ret count],
    //            NSStringFromCGRect(visibleRect)
    //    );

    //    NSLog(@"ret = %@", ret);

    //    NSLog(@"%s, rect = %@", __PRETTY_FUNCTION__, NSStringFromCGRect(rect));
    //    NSLog(@"%s, [ret count] = %u", __PRETTY_FUNCTION__, [ret count]);

    return ret;
}


- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath: indexPath];

    if ([indexPath isEqual: _selectedIndexPath]) {
        attributes.alpha = 1;
    } else {
        attributes.alpha = 0.5;

    }

    if (![indexPath isEqual: attributes.indexPath]) {
        NSLog(@"indexPath = %@, attributes.indexPath = %@", indexPath, attributes.indexPath);
    }
    //    NSLog(@"%s, indexPath = %@", __PRETTY_FUNCTION__, indexPath);
    //    NSLog(@"%s, attributes = %@", __PRETTY_FUNCTION__, attributes);
    return attributes;
}

- (NSArray *) _layoutAttributesForElementsInRect: (CGRect) rect {

    NSArray *attributesArray = [super layoutAttributesForElementsInRect: rect];

    NSLog(@"[attributesArray count] = %u", [attributesArray count]);

    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (int j = 0; j < [attributesArray count]; j++) {
        UICollectionViewLayoutAttributes *attributes = attributesArray[j];
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [ret addObject: attributes];
        }
    }

    return ret;
}


//
//
//- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
//    NSArray *ret = [super layoutAttributesForElementsInRect: rect];
//    NSLog(@"%s, [ret count] = %u", __PRETTY_FUNCTION__, [ret count]);
//    return ret;
//}


//
//- (void) prepareLayout {
//    [super prepareLayout];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//}

//
//- (CGSize) collectionViewContentSize {
//    CGSize ret = [super collectionViewContentSize];
//    NSLog(@"%s, ret = %@", __PRETTY_FUNCTION__, NSStringFromCGSize(ret));
//    return ret;
//}





//
//
//- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
//
//    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];
//
//    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
//    if ([indexPaths count] == 1) {
//        NSIndexPath *indexPath = indexPaths[0];
//        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath: indexPath];
//
//        CGPoint newPoint = attributes.frame.origin;
//
//        NSLog(@"%s", __PRETTY_FUNCTION__);
//        NSLog(@"proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
//        NSLog(@"point = %@", NSStringFromCGPoint(point));
//        NSLog(@"newPoint = %@", NSStringFromCGPoint(newPoint));
//
//        //        point = newPoint;
//    }
//
//    return point;
//}


- (void) finalizeLayoutTransition {
    [super finalizeLayoutTransition];

    CGPoint contentOffset = self.collectionView.contentOffset;
    //    NSLog(@"contentOffset = %@", NSStringFromCGPoint(contentOffset));


}


- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {

    CGPoint ret = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];

    NSLog(@"ret = %@", NSStringFromCGPoint(ret));
    return ret;
}


#pragma mark - Prepare for transition

- (void) prepareForTransitionFromLayout: (UICollectionViewLayout *) oldLayout {
    [super prepareForTransitionFromLayout: oldLayout];
}

- (void) prepareForTransitionToLayout: (UICollectionViewLayout *) newLayout {
    [super prepareForTransitionToLayout: newLayout];
    self.isTransitioning = YES;

}

@end