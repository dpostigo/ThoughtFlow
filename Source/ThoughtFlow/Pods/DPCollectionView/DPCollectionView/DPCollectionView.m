//
// Created by Dani Postigo on 5/16/14.
//

#import "DPCollectionView.h"


@implementation DPCollectionView


@synthesize onReload;

- (void)reloadData {
    [super reloadData];

    if (onReload) {
        onReload(self);
    }
}

@end