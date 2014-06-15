//
// Created by Dani Postigo on 5/3/14.
//

#import <Foundation/Foundation.h>
#import <DPAnimators/ModalDrawerAnimator.h>

@interface TFDrawerModalAnimator : BasicModalAnimator {
    void (^dismissCompletionBlock)();
    CGPoint presentationOffset;
    UIRectEdge presentationEdge;
    CGSize viewSize;
    UIView *snapshot;
}

@property(nonatomic, copy) void (^dismissCompletionBlock)();
@property(nonatomic) CGPoint presentationOffset;
@property(nonatomic) UIRectEdge presentationEdge;
@property(nonatomic) CGSize viewSize;
@end