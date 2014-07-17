//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project;
@class TFTranslucentView;

@interface TFProjectCollectionViewCell : UICollectionViewCell {

    __unsafe_unretained Project *project;
}

@property(weak) IBOutlet UIButton *button;
@property(weak) IBOutlet UILabel *startedField;
@property(weak) IBOutlet UILabel *firstWordField;
@property(weak) IBOutlet UILabel *wordsField;
@property(weak) IBOutlet UILabel *connectionsField;
@property(nonatomic, assign) Project *project;
@property(nonatomic, strong) TFTranslucentView *bg;
@end