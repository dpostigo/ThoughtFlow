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

    //    NSLog(@"%s", __PRETTY_FUNCTION__);
    //
    //
    //    //    // Need to overflow our actual visible rect slightly to avoid flickering.
    //    //    CGRect visibleRect = CGRectInset((CGRect) {.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size}, -100, -100);
    //    //
    //    NSArray *items = self.attributesArray;
    //
    //    for (int j = 0; j < [items count]; j++) {
    //        UICollectionViewLayoutAttributes *attributes = items[j];
    //        UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem: attributes snapToPoint: attributes.frame.origin];
    //        snapBehavior.damping = 1.0;
    //        [_dynamicAnimator addBehavior: snapBehavior];
    //
    //    }

}




//- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
//    return [self.dynamicAnimator itemsInRect: rect];
//}

//- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
//    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath: indexPath];
//}

- (void) invalidateLayout {
    [super invalidateLayout];
    //    [_dynamicAnimator removeAllBehaviors];
}


@end