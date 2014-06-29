//
// Created by Dani Postigo on 5/16/14.
//

#import <Foundation/Foundation.h>


@interface DPCollectionView : UICollectionView {
    BOOL autoselectsFirstItem;
    BOOL usesDefaultScrollPosition;
    UICollectionViewScrollPosition defaultScrollPosition;

    BOOL notifiesDelegateOnSelection;
    BOOL preservesSelection;

    void (^beforeReload)(DPCollectionView *collectionView);
    void (^onReload)(DPCollectionView *collectionView);

    NSMutableArray *selectedIndexPaths;
}
@property(nonatomic, copy) void (^onReload)(DPCollectionView *);
@property(nonatomic) BOOL preservesSelection;
@property(nonatomic) UICollectionViewScrollPosition defaultScrollPosition;
@property(nonatomic) BOOL usesDefaultScrollPosition;
@property(nonatomic) BOOL autoselectsFirstItem;
@property(nonatomic) BOOL notifiesDelegateOnSelection;
@property(nonatomic, strong) NSMutableArray *selectedIndexPaths;
@property(nonatomic, copy) void (^beforeReload)(DPCollectionView *);
- (void)saveSelectedIndexPaths;
@end