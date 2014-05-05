//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFProjectCollectionViewCell : UICollectionViewCell {

    //    IBOutlet UILabel *firstWordField;
    IBOutlet UILabel *connectionsField;
    IBOutlet UILabel *wordsField;
}

@property(weak) IBOutlet UILabel *firstWordField;
@property(weak) IBOutlet UIButton *button;
@property(nonatomic, strong) UILabel *wordsField;
@property(nonatomic, strong) UILabel *connectionsField;
@end