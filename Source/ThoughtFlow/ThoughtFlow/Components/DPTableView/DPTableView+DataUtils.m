//
// Created by Dani Postigo on 5/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "DPTableView+DataUtils.h"

@implementation DPTableView (DataUtils)

- (NSString *) textLabelForIndexPath: (NSIndexPath *) indexPath {
    return [self dataForKey: DPTableViewTextLabelName atIndexPath: indexPath];
}

- (UIImage *) imageForIndexPath: (NSIndexPath *) indexPath {
    return [self dataForKey: DPTableViewImageName atIndexPath: indexPath];
}

@end