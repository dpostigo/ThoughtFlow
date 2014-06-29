//
// Created by Dani Postigo on 6/21/14.
//

#import <Foundation/Foundation.h>
#import "DPCollectionView.h"

@class DPCollectionViewCell;

@interface DPCollectionView (Utils)
- (DPCollectionViewCell *)dpCellAtIndexPath:(NSIndexPath *)indexPath;
@end