//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFImageGridViewCell;
@class TFImageGridViewController;
@class TFPhoto;

@protocol TFImageGridViewControllerDelegate <NSObject, UICollectionViewDelegateFlowLayout>

@optional
- (void) imageGridViewController: (TFImageGridViewController *) controller dequeuedCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath;
- (void) imageGridViewController: (TFImageGridViewController *) controller didClickButton: (UIButton *) button inCell: (TFImageGridViewCell *) cell atIndexPath: (NSIndexPath *) indexPath;
- (void) imageGridViewController: (TFImageGridViewController *) controller didSelectImage: (TFPhoto *) image atIndexPath: (NSIndexPath *) indexPath;
- (void) imageGridViewController: (TFImageGridViewController *) controller didScrollToImage: (TFPhoto *) image;
@end

@interface TFImageGridViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) UICollectionView *collection;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) TFPhoto *selectedImage;
@property(nonatomic, assign) id <TFImageGridViewControllerDelegate> delegate;
- (void) addTargetToButton: (UIButton *) button;
@end