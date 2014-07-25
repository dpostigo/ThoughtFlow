//
// Created by Dani Postigo on 7/23/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFFullLayout.h"


@implementation TFFullLayout {

}

- (id) init {
    self = [super init];
    if (self) {
        _attributesArray = [[NSMutableArray alloc] init];

    }

    return self;
}


- (void) prepareLayout {

    if (_attributesArray == nil) {
        _attributesArray = [[NSMutableArray alloc] init];
    }

    NSInteger itemCount = [self.collectionView numberOfItemsInSection: 0];

    // generate the new attributes array for each photo in the stack
    for (NSInteger i = 0; i < itemCount; i++) {

        UICollectionViewLayoutAttributes *attributes;
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: [NSIndexPath indexPathForItem: i inSection: 0]];

        CGSize size = self.collectionView.bounds.size;
        //        CGPoint center = CGPointMake(size.width / 2.0, size.height / 2.0);
        //        attributes.size = size;
        //        attributes.bounds = CGRectMake(0, 0, size.width, size.height);

        CGPoint origin = CGPointMake(i * size.width, 0);
        CGRect frame = CGRectMake(origin.x, origin.y, size.width, size.height);
        attributes.frame = frame;

        [_attributesArray addObject: attributes];
    }
}


- (UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath: (NSIndexPath *) indexPath {
    return _attributesArray[indexPath.item];

}


- (NSArray *) layoutAttributesForElementsInRect: (CGRect) rect {
    return self.attributesArray;
}

- (CGSize) collectionViewContentSize {
    return self.collectionView.bounds.size;
}

#pragma mark - Collection

- (void) invalidateLayout {
    [super invalidateLayout];
    _attributesArray = nil;
}


//- (CGSize) collectionViewContentSize {
//    return self.collectionView.bounds.size;
//}

- (BOOL) shouldInvalidateLayoutForBoundsChange: (CGRect) newBounds {
    CGRect bounds = self.collectionView.bounds;
    return ((CGRectGetWidth(newBounds) != CGRectGetWidth(bounds) ||
            (CGRectGetHeight(newBounds) != CGRectGetHeight(bounds))));
}
@end