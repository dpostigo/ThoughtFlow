//
// Created by Dani Postigo on 7/25/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFDynamicMindmapGridLayout.h"


@interface TFDynamicMindmapGridLayout ()

@property(nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@end

@implementation TFDynamicMindmapGridLayout {

}

- (id) init {
    self = [super init];
    if (self) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout: self];

    }

    return self;
}


- (void) prepareLayout {
    [super prepareLayout];

    NSLog(@"%s", __PRETTY_FUNCTION__);


    //    // Need to overflow our actual visible rect slightly to avoid flickering.
    //    CGRect visibleRect = CGRectInset((CGRect) {.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    //
    NSArray *items = self.attributesArray;

    for (int j = 0; j < [items count]; j++) {
        UICollectionViewLayoutAttributes *attributes = items[j];
        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem: attributes snapToPoint: attributes.frame.origin];
        snapBehavior.damping = 1.0;
        [_dynamicAnimator addBehavior: snapBehavior];
    }

}


- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [self.dynamicAnimator layoutAttributesForCellAtIndexPath: indexPath];
    if (layoutAttributes == nil) {
        layoutAttributes = [super layoutAttributesForItemAtIndexPath: indexPath];
    }
    return layoutAttributes;
}


- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
    return [self.dynamicAnimator itemsInRect: rect];
}

//- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
//    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath: indexPath];
//}

- (void) invalidateLayout {
    [super invalidateLayout];
    [_dynamicAnimator removeAllBehaviors];
}


- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;

    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView: self.collectionView];

    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock: ^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;

        UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta * scrollResistance);
        }
        else {
            center.y += MIN(delta, delta * scrollResistance);
        }
        item.center = center;

        [self.dynamicAnimator updateItemUsingCurrentState: item];
    }];

    return NO;
}
@end