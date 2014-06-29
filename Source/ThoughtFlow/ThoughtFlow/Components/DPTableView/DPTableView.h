//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const DPTableViewTextLabelName;
NSString *const DPTableViewDetailLabelName;
NSString *const DPTableViewImageName;


@interface DPTableView : UITableView {

    BOOL populateTextLabels;
    void (^onReload)(DPTableView *);

    NSMutableDictionary *dataDictionary;

}

@property(nonatomic, copy) void (^onReload)(DPTableView *);
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic) BOOL populateTextLabels;
@property(nonatomic, strong) NSMutableDictionary *dataDictionary;
- (void) populateItem: (id) item atIndexPath: (NSIndexPath *) indexPath;
- (id) dataForKey: (NSString *) key atIndexPath: (NSIndexPath *) indexPath;
- (NSDictionary *) dataForIndexPath: (NSIndexPath *) indexPath;
- (NSInteger) numOfRowsInSection: (NSInteger) section;
- (NSInteger) numOfSections;
- (NSMutableArray *) rows;
- (NSMutableArray *) rowData;
- (NSMutableArray *) sectionData;
@end