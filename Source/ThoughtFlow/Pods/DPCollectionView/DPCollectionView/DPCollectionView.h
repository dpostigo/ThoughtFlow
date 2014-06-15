//
// Created by Dani Postigo on 5/16/14.
//

#import <Foundation/Foundation.h>


@interface DPCollectionView : UICollectionView {


    void (^onReload)(DPCollectionView *collectionView);
}
@property(nonatomic, copy) void (^onReload)(DPCollectionView *);
@end