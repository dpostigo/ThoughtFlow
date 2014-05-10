//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "DPTableView.h"

@implementation DPTableView

@synthesize onReload;
@synthesize data;

@synthesize populateTextLabels;
@synthesize dataDictionary;

NSString *const DPTableViewTextLabelName = @"Text Label";
NSString *const DPTableViewDetailLabelName = @"Detail Label";
NSString *const DPTableViewImageName = @"Image";


- (void) reloadData {
    [super reloadData];

    if (onReload) {
        onReload(self);
    }
}

#pragma mark Do stuff

//- (UITableViewCell *) cellForRowAtIndexPath: (NSIndexPath *) indexPath {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    UITableViewCell *ret = [super cellForRowAtIndexPath: indexPath];
//    return ret;
//}

- (void) populateItem: (id) item atIndexPath: (NSIndexPath *) indexPath {
    if ([item isKindOfClass: [UITableViewCell class]]) {
        UITableViewCell *cell = item;
        NSDictionary *dictionary = [self dataForIndexPath: indexPath];
        cell.textLabel.text = [dictionary objectForKey: DPTableViewTextLabelName];

    }
}


- (id) dataForKey: (NSString *) key atIndexPath: (NSIndexPath *) indexPath {
    NSDictionary *dictionary = [self dataForIndexPath: indexPath];
    return [dictionary objectForKey: key];
}

- (NSDictionary *) dataForIndexPath: (NSIndexPath *) indexPath {
    return self.rowData[indexPath.section][indexPath.row];
}

- (NSInteger) numberOfRowsInSection: (NSInteger) section {
    return [self.rowData[section] count];
}

#pragma mark Getters


- (NSMutableDictionary *) dataDictionary {
    if (dataDictionary == nil) {
        dataDictionary = [[NSMutableDictionary alloc] init];
        [dataDictionary setObject: [NSMutableArray array] forKey: @"sections"];
        [dataDictionary setObject: [NSMutableArray array] forKey: @"rows"];
    }
    return dataDictionary;
}


- (NSMutableArray *) rows {
    if ([self.rowData count] == 0) {
        self.rowData[0] = [[NSMutableArray alloc] init];
    }
    return [self.dataDictionary objectForKey: @"rows"][0];
}

- (NSMutableArray *) rowData {
    return [self.dataDictionary objectForKey: @"rows"];

}

- (NSMutableArray *) sectionData {
    return [self.dataDictionary objectForKey: @"sections"];
}


- (NSMutableArray *) data {
    if (data == nil) {
        data = [[NSMutableArray alloc] init];
    }
    return data;
}


@end