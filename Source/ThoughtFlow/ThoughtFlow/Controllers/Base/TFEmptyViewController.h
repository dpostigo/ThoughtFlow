//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TFEmptyViewController : UIViewController

@property(weak) IBOutlet UILabel *textLabel;
@property(weak) IBOutlet UILabel *detailTextLabel;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
- (instancetype) initWithTitle: (NSString *) title subtitle: (NSString *) subtitle;
- (instancetype) initWithTitle: (NSString *) title;


@end