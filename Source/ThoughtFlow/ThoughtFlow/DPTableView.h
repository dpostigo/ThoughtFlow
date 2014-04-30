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
    NSMutableArray *data;

    NSMutableDictionary *dataDictionary;

}

@property(nonatomic, copy) void (^onReload)(DPTableView *);
@property(nonatomic, strong) NSMutableArray *data;
@property(nonatomic) BOOL populateTextLabels;
@property(nonatomic, strong) NSMutableDictionary *dataDictionary;
- (void) populateItem: (id) item atIndexPath: (NSIndexPath *) indexPath;
- (NSString *) textLabelForIndexPath: (NSIndexPath *) indexPath;
- (NSDictionary *) dataForIndexPath: (NSIndexPath *) indexPath;
- (NSMutableArray *) rows;
- (NSMutableArray *) sectionData;
@end