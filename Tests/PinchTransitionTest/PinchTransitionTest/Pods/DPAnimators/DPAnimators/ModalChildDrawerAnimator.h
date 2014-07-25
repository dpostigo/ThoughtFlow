//
// Created by Dani Postigo on 5/26/14.
//

#import <Foundation/Foundation.h>
#import <DPAnimators/BasicModalAnimator.h>

@interface ModalChildDrawerAnimator : BasicModalAnimator {

    CGPoint presentationOffset;
    UIRectEdge presentationEdge;
    CGSize modalPresentationSize;
}

@property(nonatomic) CGPoint presentationOffset;
@property(nonatomic) UIRectEdge presentationEdge;
@property(nonatomic) CGSize modalPresentationSize;
@end