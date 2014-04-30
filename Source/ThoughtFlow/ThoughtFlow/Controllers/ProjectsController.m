//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "ProjectsController.h"
#import "Model.h"
#import "UIView+TFFonts.h"

@implementation ProjectsController

- (void) loadView {
    [super loadView];

}


- (void) viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    collection.delegate = self;
    collection.dataSource = self;

    [collection reloadData];
}


- (NSInteger) collectionView: (UICollectionView *) collectionView numberOfItemsInSection: (NSInteger) section {
    return [_model.projects count];
}

- (UICollectionViewCell *) collectionView: (UICollectionView *) collectionView cellForItemAtIndexPath: (NSIndexPath *) indexPath {
    UICollectionViewCell *ret = [collection dequeueReusableCellWithReuseIdentifier: @"CollectionCell"
                                                                      forIndexPath: indexPath];


    [ret convertFonts];
    return ret;
}


@end