//
// Created by Dani Postigo on 7/26/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <TLLayoutTransitioning/UICollectionView+TLTransitioning.h>
#import "TFMindmapTransitionLayout.h"
#import "TFMindmapLayout.h"
#import "TFMindmapFullscreenLayout.h"


@interface TFMindmapTransitionLayout ()

@property(nonatomic) CGSize interpolatedSize;
@property(nonatomic, strong) TFMindmapLayout *fromMindmapLayout;
@property(nonatomic, strong) TFMindmapLayout *nextMindmapLayout;
@end

@implementation TFMindmapTransitionLayout {

}

- (id) initWithCurrentLayout: (UICollectionViewLayout *) currentLayout nextLayout: (UICollectionViewLayout *) newLayout {
    self = [super initWithCurrentLayout: currentLayout nextLayout: newLayout];
    if (self) {
        //
        //        if ([currentLayout isKindOfClass: [TFMindmapLayout class]]) {
        //            _fromMindmapLayout = (TFMindmapLayout *) currentLayout;
        //
        //        }
        //        if ([newLayout isKindOfClass: [TFMindmapLayout class]]) {
        //            _nextMindmapLayout = (TFMindmapLayout *) newLayout;
        //        }
    }

    return self;
}

- (void) setTransitionProgress: (CGFloat) transitionProgress {
    [super setTransitionProgress: transitionProgress];

    CGFloat heightDifference = _nextMindmapLayout.itemSize.height - _fromMindmapLayout.itemSize.height;
    CGFloat interpolatedHeight = _fromMindmapLayout.itemSize.height + (heightDifference * transitionProgress);

    CGFloat widthDifference = _nextMindmapLayout.itemSize.width - _fromMindmapLayout.itemSize.width;
    CGFloat interpolatedWidth = _fromMindmapLayout.itemSize.width + (widthDifference * transitionProgress);

    _interpolatedSize = CGSizeMake(interpolatedWidth, interpolatedHeight);
    //    [self updateValue: transitionProgress forAnimatedKey: @"progress"];
    //    NSLog(@"self.transitionProgress = %f", self.transitionProgress);
}

- (void) updateValue: (CGFloat) value forAnimatedKey: (NSString *) key {
    [super updateValue: value forAnimatedKey: key];
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}







//- (CGSize) collectionViewContentSize {
//    NSInteger numberOfRows = _fromMindmapLayout.numberOfRows;
//    CGSize ret;
//    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
//    CGFloat numColumns = ceilf(itemCount / numberOfRows);
//
//    ret.width = numColumns * _interpolatedSize.width;
//    ret.height = numberOfRows * _interpolatedSize.height;
//    return ret;
//}




- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath: indexPath];

    return attributes;

}


- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {

    CGPoint offset = self.collectionView.contentOffset;
    CGRect bounds = self.collectionView.bounds;
    //    NSLog(@"height = %f", height);

    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = bounds.size;

    //    visibleRect = CGRectInset(visibleRect, -_interpolatedSize.width, -_interpolatedSize.height);
    visibleRect = CGRectInset(visibleRect, -_interpolatedSize.width, -_interpolatedSize.height);

    //    NSLog(@"visibleRect = %@", NSStringFromCGRect(visibleRect));
    NSArray *array = [super layoutAttributesForElementsInRect: visibleRect];

    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (int j = 0; j < [array count]; j++) {
        UICollectionViewLayoutAttributes *attributes = array[j];

        if (CGRectIntersectsRect(visibleRect, attributes.frame)) {
            //            NSLog(@"attributes.frame = %@", NSStringFromCGRect(attributes.frame));

            [ret addObject: attributes];
        }
    }

    //    NSLog(@"[ret count] = %u", [ret count]);
    NSLog(@"ret (%u) = %@", [ret count], ret);
    if ([array count] > 10) {
        //        NSLog(@"visibleRect = %@, [ret count] = %u", NSStringFromCGRect(rect), [ret count]);

    } else {

    }
    return ret;
}




//
//- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
//    //            DDLogVerbose(@"newPoint = %@", NSStringFromCGPoint(newPoint));
//
//    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];
//
//    DDLogVerbose(@"proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
//    DDLogVerbose(@"point = %@", NSStringFromCGPoint(point));
//    return point;
//}

- (NSIndexPath *) selectedIndexPath {
    NSIndexPath *ret = nil;

    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        ret = indexPaths[0];
    }
    return ret;
}


@end