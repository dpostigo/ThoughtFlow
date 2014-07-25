//
// Created by Dani Postigo on 5/25/14.
//

#import <Foundation/Foundation.h>
#import "BasicModalAnimator.h"

@interface ModalDrawerAnimator : BasicModalAnimator {

    CGPoint presentationOffset;
    UIRectEdge presentationEdge;
    CGSize modalPresentationSize;
}

@property(nonatomic) CGSize modalPresentationSize;
@property(nonatomic) UIRectEdge presentationEdge;
@property(nonatomic) CGPoint presentationOffset;

- (UIView *) clippingViewForContext: (id <UIViewControllerContextTransitioning>) context;
- (void) positionWithContext: (id <UIViewControllerContextTransitioning>) context;
- (CGPoint) startingPointForContext: (id <UIViewControllerContextTransitioning>) context;
- (CGPoint) finalPointForContext: (id <UIViewControllerContextTransitioning>) context;
- (CGSize) rawModalSizeForContext: (id <UIViewControllerContextTransitioning>) context;
@end