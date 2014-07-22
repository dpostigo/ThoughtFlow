//
// Created by Dani Postigo on 4/28/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFViewController.h"

@interface ProjectsController : TFViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {

}

@property(weak) IBOutlet UICollectionView *collection;

@property(weak) IBOutlet UIButton *addProjectButton;
@end