//
// Created by Dani Postigo on 6/21/14.
//

#import "DPCollectionView+Utils.h"
#import "DPCollectionViewCell.h"


@implementation DPCollectionView (Utils)


- (DPCollectionViewCell *)dpCellAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    return (DPCollectionViewCell *) ([cell isKindOfClass:[DPCollectionViewCell class]] ? cell : nil);
}

@end