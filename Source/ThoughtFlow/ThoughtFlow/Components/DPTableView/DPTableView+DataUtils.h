//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DPTableView.h"

@interface DPTableView (DataUtils)

- (NSString *) textLabelForIndexPath: (NSIndexPath *) indexPath;
- (UIImage *) imageForIndexPath: (NSIndexPath *) indexPath;
@end