//
// Created by Dani Postigo on 5/16/14.
//

#import "DPCollectionView.h"
#import "DPCollectionViewCell.h"
#import "DPCollectionView+Utils.h"
#import "NSArray+IndexPath.h"
#import "UICollectionView+DPKit.h"


@implementation DPCollectionView


@synthesize onReload;
@synthesize preservesSelection;

@synthesize defaultScrollPosition;
@synthesize usesDefaultScrollPosition;

@synthesize autoselectsFirstItem;

@synthesize notifiesDelegateOnSelection;
@synthesize selectedIndexPaths;
@synthesize beforeReload;

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
    }

    return self;
}


- (void)saveSelectedIndexPaths {
//    selectedIndexPaths = [NSMutableArray arrayWithArray:[self indexPathsForSelectedItems]];
}

- (void)reloadData {
    [super reloadData];

//    if (selectedIndexPaths) {
//        [self selectItemsAtIndexPaths:selectedIndexPaths animated:NO scrollPosition:UICollectionViewScrollPositionNone];
//
//    }

    if (onReload) {
        onReload(self);
    }


    if (autoselectsFirstItem) {
        NSInteger count = [self getNumberOfItemsInSection:0];
        if ([[self indexPathsForSelectedItems] count] == 0 && count > 0) {
            [self selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                               animated:YES
                         scrollPosition:UICollectionViewScrollPositionNone];

        }
    }
}


- (NSInteger)getNumberOfItemsInSection:(NSInteger)section {
    NSInteger ret = -1;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        ret = [self.dataSource collectionView:self numberOfItemsInSection:section];
    }
    return ret;
}


//- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    UICollectionViewCell *ret = [super cellForItemAtIndexPath:indexPath];
//
////
////    DPCollectionViewCell *cell = (DPCollectionViewCell *) ([ret isKindOfClass:[DPCollectionViewCell class]] ? ret : nil);
////    if (cell) {
////        NSArray *indexPaths = [self indexPathsForSelectedItems];
////        if ([indexPaths containsIndexPath:indexPath]) {
////            if (cell.selectionState) {
////                cell.selectionState(cell);
////            }
////        } else {
////
////        }
////
////    }
//    return ret;
//}

- (void)selectItemAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
//
//    if (usesDefaultScrollPosition) {
//        scrollPosition = defaultScrollPosition;
//    }
    [super selectItemAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];

    DPCollectionViewCell *cell = [self dpCellAtIndexPath:indexPath];
    if (cell && cell.selectionState) {
        cell.selectionState(cell);
    }

    if (notifiesDelegateOnSelection) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)]) {
            [self.delegate collectionView:self didSelectItemAtIndexPath:indexPath];
        }
    }

}


- (void)setDefaultScrollPosition:(UICollectionViewScrollPosition)defaultScrollPosition1 {
    usesDefaultScrollPosition = YES;
    defaultScrollPosition = defaultScrollPosition1;
}


- (NSMutableArray *)selectedIndexPaths {
    if (selectedIndexPaths == nil) {
        selectedIndexPaths = [[NSMutableArray alloc] init];
    }
    return selectedIndexPaths;
}


@end