//
// Created by Dani Postigo on 5/3/14.
//

#import <Foundation/Foundation.h>

@interface TFDrawerModalAnimator : NSObject <UIViewControllerAnimatedTransitioning> {

    CGFloat duration;
    BOOL debug;
    BOOL presenting;

    CGSize modalSize;
    CGPoint sourceModalOrigin;
    CGPoint destinationModalOrigin;

    UIViewController *sourceController;
}

@property(nonatomic) BOOL debug;
@property(nonatomic) BOOL presenting;
@property(nonatomic) CGSize modalSize;
@property(nonatomic) CGPoint sourceModalOrigin;
@property(nonatomic) CGPoint destinationModalOrigin;
@property(nonatomic, strong) UIViewController *sourceController;
@property(nonatomic) CGFloat duration;
@end