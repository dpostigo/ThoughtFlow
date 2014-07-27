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

        if ([currentLayout isKindOfClass: [TFMindmapLayout class]]) {
            _fromMindmapLayout = (TFMindmapLayout *) currentLayout;
            NSLog(@"_fromMindmapLayout.itemSize = %@", NSStringFromCGSize(_fromMindmapLayout.itemSize));

        }
        if ([newLayout isKindOfClass: [TFMindmapLayout class]]) {
            _nextMindmapLayout = (TFMindmapLayout *) newLayout;
            NSLog(@"_nextMindmapLayout.itemSize = %@", NSStringFromCGSize(_nextMindmapLayout.itemSize));

        }
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
    [self updateValue: transitionProgress forAnimatedKey: @"progress"];
    //    NSLog(@"self.transitionProgress = %f", self.transitionProgress);
}

- (void) updateValue: (CGFloat) value forAnimatedKey: (NSString *) key {
    [super updateValue: value forAnimatedKey: key];
    //    NSLog(@"%s", __PRETTY_FUNCTION__);
}

//
//- (id) initWithCurrentLayout: (UICollectionViewLayout *) currentLayout nextLayout: (UICollectionViewLayout *) newLayout {
//    self = [super initWithCurrentLayout: currentLayout nextLayout: newLayout];
//    if (self) {
//
//        if ([newLayout isKindOfClass: [TFMindmapLayout class]]) {
//            _mindmapLayout = (TFMindmapLayout *) newLayout;
//        }
//    }
//
//    return self;
//}
//
//
//- (void) prepareForTransitionToLayout: (UICollectionViewLayout *) newLayout {
//    [super prepareForTransitionToLayout: newLayout];
//
//    NSLog(@"%s, newLayout = %@", __PRETTY_FUNCTION__, newLayout);
//    //    TFMindmapLayout *tempLayout = [[TFMindmapLayout alloc] init];
//    //    [tempLayout setIsFullscreen: YES withCollectionView: self.collectionView];
//    //    self.collectionView.collectionViewLayout = tempLayout;
//}
//
//- (void) prepareForTransitionFromLayout: (UICollectionViewLayout *) oldLayout {
//
//    //    if ([self.currentLayout isKindOfClass: [TFMindmapFullscreenLayout class]]) {
//    //        //        UICollectionViewLayout *currentLayout = self.collectionView.collectionViewLayout;
//    //        TFMindmapLayout *tempLayout = [[TFMindmapLayout alloc] init];
//    //        [tempLayout setIsFullscreen: YES withCollectionView: self.collectionView];
//    //        self.collectionView.collectionViewLayout = tempLayout;
//    //    }
//
//    [super prepareForTransitionFromLayout: oldLayout];
//
//
//    //    NSLog(@"%s, oldLayout = %@", __PRETTY_FUNCTION__, oldLayout);
//}
//
//
//- (void) finalizeLayoutTransition {
//    [super finalizeLayoutTransition];
//
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//
//    NSLog(@"self.currentLayout = %@", self.currentLayout);
//    NSLog(@"self.nextLayout = %@", self.nextLayout);
//}
//
////
////- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
////    CGRect visibleRect;
////    visibleRect.origin = self.collectionView.contentOffset;
////    visibleRect.size = self.collectionView.bounds.size;
////
////    if (_mindmapLayout) {
////        visibleRect = CGRectInset(visibleRect, -_mindmapLayout.itemSize.width, -_mindmapLayout.itemSize.height);
////    }
////
////    //    NSLog(@"rect = %@, visibleRect = %@", NSStringFromCGRect(rect), NSStringFromCGRect(visibleRect));
////    return [super layoutAttributesForElementsInRect: visibleRect];
////}




- (CGSize) collectionViewContentSize {

    //    CGSize ret = [super collectionViewContentSize];
    //    CGRect bounds = self.collectionView.bounds;
    //
    //    ret.width += 100;
    //    ret.height += 100;
    //
    //    ret.height = _interpolatedSize.height * _fromMindmapLayout.numberOfRows;
    //
    //    //    NSLog(@"ret = %@", NSStringFromCGSize(ret));
    //    return ret;


    NSInteger numberOfRows = _fromMindmapLayout.numberOfRows;
    CGSize ret;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];
    CGFloat numColumns = ceilf(itemCount / numberOfRows);

    ret.width = numColumns * _interpolatedSize.width;
    ret.height = numberOfRows * _interpolatedSize.height;

    //    NSLog(@"ret = %@", NSStringFromCGSize(ret));
    return ret;

    //    return bounds.size;
    //    return CGSizeMake(fmaxf(ret.width, CGRectGetWidth(frame)), fmaxf(ret.height, CGRectGetHeight(frame)));
}

- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
    NSArray *ret = [super layoutAttributesForElementsInRect: rect];

    //    NSLog(@"[ret count] = %u", [ret count]);
    return ret;
}

- (NSIndexPath *) selectedIndexPath {
    NSIndexPath *ret = nil;

    NSArray *indexPaths = self.collectionView.indexPathsForSelectedItems;
    if ([indexPaths count] == 1) {
        ret = indexPaths[0];
    }
    return ret;
}


- (CGPoint) targetContentOffsetForProposedContentOffset: (CGPoint) proposedContentOffset {
    //            DDLogVerbose(@"newPoint = %@", NSStringFromCGPoint(newPoint));

    CGPoint point = [super targetContentOffsetForProposedContentOffset: proposedContentOffset];

    DDLogVerbose(@"proposedContentOffset = %@", NSStringFromCGPoint(proposedContentOffset));
    DDLogVerbose(@"point = %@", NSStringFromCGPoint(point));
    return point;
}

@end