//
// Created by Dani Postigo on 7/9/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <Foundation/Foundation.h>


@class TFNodeScrollViewContainer;
@class TFNodeScrollView;


@interface ViewController : UIViewController <UIScrollViewDelegate> {
    TFNodeScrollViewContainer *_container;
}

@property(weak) IBOutlet TFNodeScrollView *scrollView;
@property(nonatomic, strong) UIView *innerView;
@end