//
// Created by Dani Postigo on 5/25/14.
//

#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "NavigationFadeAnimator.h"
#import "NSArray+BlocksKit.h"


static const NSInteger snapshotTag = 100004;

@implementation NavigationFadeAnimator

- (void) presentWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super presentWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    NSArray *snapshots = [self snapshotsInContainerView: containerView];

    if (!_opaque) {
        _snapshot = [sourceView snapshotViewAfterScreenUpdates: YES];
        _snapshot.frame = sourceView.frame;
        _snapshot.tag = snapshotTag;
        [containerView addSubview: _snapshot];
        //        NSLog(@"Added _snapshot.");
    }

    containerView.backgroundColor = [UIColor clearColor];
    containerView.opaque = NO;

    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    [self removeSnapshots: snapshots];

    destinationView.alpha = 0;
    sourceView.userInteractionEnabled = NO;
    destinationView.userInteractionEnabled = NO;

    [UIView animateWithDuration: [self transitionDuration: context]
            animations: ^{
                destinationView.alpha = 1;
                sourceView.alpha = 0;

            }
            completion: ^(BOOL finished) {
                [sourceView removeFromSuperview];
                sourceView.alpha = 1;

                sourceView.userInteractionEnabled = YES;
                destinationView.userInteractionEnabled = YES;

                [context completeTransition: YES];

            }];
}

- (void) dismissWithContext: (id <UIViewControllerContextTransitioning>) context {
    [super dismissWithContext: context];

    UIView *containerView = context.containerView;
    UIView *sourceView = [self fromViewController: context].view;
    UIView *destinationView = [self toViewController: context].view;

    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview: sourceView];
    [containerView addSubview: destinationView];

    sourceView.alpha = 0;

    UIView *snapshot = [containerView viewWithTag: snapshotTag];
    if (snapshot == nil) {
        //        NSLog(@"_snapshot = %@", _snapshot);
    }

    [UIView animateWithDuration: [self transitionDuration: context] animations: ^{
        destinationView.alpha = 0;
        sourceView.alpha = 1;

    } completion: ^(BOOL finished) {
        if (snapshot) {
            [snapshot removeFromSuperview];
        }
        [destinationView removeFromSuperview];
        destinationView.alpha = 1;
        [context completeTransition: YES];

        //        if (releasesAnimator) {
        //            //            UIViewController *fromController = [self fromViewController: context];
        //            //fromController.navigationController.delegate = nil;
        //        }

    }];
}


- (NSArray *) snapshotsInContainerView: (UIView *) containerView {
    NSMutableArray *ret = [[NSMutableArray alloc] init];

    NSArray *subviews = containerView.subviews;
    for (int j = 0; j < [subviews count]; j++) {
        UIView *subview = subviews[j];
        NSString *classString = NSStringFromClass([subview class]);
        if ([classString isEqualToString: @"_UIReplicantView"]) {
            [ret addObject: subview];
        }
    }

    return ret;
    //
    //    NSArray *snapshots = [subviews bk_select: ^(id obj) {
    //        NSString *classString = NSStringFromClass([obj class]);
    //        return [classString isEqualToString: @"_UIReplicantView"];
    //    }];
    //
    //    return [NSArray arrayWithArray: snapshots];
}

- (void) removeSnapshots: (NSArray *) snapshots {

    for (int j = 0; j < [snapshots count]; j++) {

        UIView *subview = snapshots[j];
        [subview removeFromSuperview];

    }
    //
    //    [snapshots bk_each: ^(id obj) {
    //        [obj removeFromSuperview];
    //    }];
}

@end