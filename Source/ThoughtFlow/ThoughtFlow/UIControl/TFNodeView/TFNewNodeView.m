//
// Created by Dani Postigo on 7/1/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "TFNewNodeView.h"
#import "TFNode.h"
#import "TFWhiteTranslucentView.h"
#import "TFGradientView.h"
#import "UIGestureRecognizer+BlocksKit.h"
#import "UIColor+TFApp.h"
#import "UIControl+BlocksKit.h"
#import "UIFont+ThoughtFlow.h"
#import "TFSpacedGothamLightLabel.h"
#import "TFKernedGothamLightLabel.h"


@interface TFNewNodeView ()

@property(nonatomic, strong) TFWhiteTranslucentView *bg;
@property(nonatomic, strong) UIView *bgGlowView;
@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *hotView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *centerContentView;
@property(nonatomic, strong) UIView *leftContentView;
@property(nonatomic, strong) UIView *rightContentView;
@property(nonatomic, strong) UIView *topContentView;

@property(nonatomic, strong) UIPanGestureRecognizer *verticalPan;
@property(nonatomic, strong) UIPanGestureRecognizer *horizontalPan;
@property(nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation TFNewNodeView

- (id) initWithFrame: (CGRect) frame {
    frame.size.width = TFNodeViewWidth;
    frame.size.height = TFNodeViewHeight;
    self = [super initWithFrame: frame];
    if (self) {

        [self _setup];
    }

    return self;
}


- (instancetype) initWithNode: (TFNode *) node {
    self = [super initWithNode: node];
    if (self) {

        _textLabel.text = self.node.title;
    }

    return self;
}


#pragma mark - Public

- (void) setSelected: (BOOL) selected {
    [super setSelected: selected];

    if (self.selected) {
        [self _notifyDidChangeSelection];
    }

    [UIView animateWithDuration: 0.4
            delay: 0
            usingSpringWithDamping: 1.0
            initialSpringVelocity: 1.0
            options: UIViewAnimationOptionCurveLinear
            animations: ^{

                _selectionBg.alpha = self.selected ? 0.9 : 0.5;
                //                _bg.translucentAlpha = self.selected ? 0.8 : 0.1;
            }
            completion: ^(BOOL finished) {

            }];
}



#pragma mark - Delegates

#pragma mark - UIGestureRecognizerDelegate

- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer *) gestureRecognizer {

    if (gestureRecognizer == _doubleTapGesture) {
        return self.nodeState == TFNodeViewStateNormal;
    }
    else if (gestureRecognizer == _verticalPan) {

        CGPoint velocity = [_verticalPan velocityInView: _verticalPan.view];
        return fabs(velocity.y) > fabs(velocity.x);
    }
    else if (gestureRecognizer == _horizontalPan) {

        CGPoint velocity = [_horizontalPan velocityInView: _horizontalPan.view];
        return fabs(velocity.x) > fabs(velocity.y);

    }

    return NO;
}


#pragma mark - Refresh

- (void) _refreshNodeState {
    CGPoint offset = _scrollView.contentOffset;
    if (offset.y == 0) {
        self.nodeState = TFNodeViewStateRelated;
    } else {
        CGFloat snapValue = offset.x / TFNodeViewWidth;
        if (snapValue == 0) {
            self.nodeState = TFNodeViewStateCreate;

        } else if (snapValue == 1) {
            self.nodeState = TFNodeViewStateNormal;

        } else if (snapValue == 2) {
            self.nodeState = TFNodeViewStateDelete;
        }
    }
}


#pragma mark - Overrides

- (void) setNodeState: (TFNodeViewState) nodeState {
    [super setNodeState: nodeState];

    //    _scrollView.userInteractionEnabled = self.nodeState != TFNodeViewStateNormal;
}

#pragma mark - Setup

- (void) _setup {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    //    self.layer.borderColor = [UIColor colorWithWhite: 1.0 alpha: 0.2].CGColor;
    //    self.layer.borderWidth = 0.5;
    //    self.layer.cornerRadius = 2.0;

    //    [self _setupBg];
    [self _setupHotView];
    [self _setupScrollView];

    self.clipsToBounds = NO;
    self.nodeState = TFNodeViewStateNormal;
}


- (void) _setupBg {
    _bg = [[TFWhiteTranslucentView alloc] initWithFrame: self.bounds];
    _bg.alpha = 0;
    [self embedView: _bg];
}


- (void) _setupHotView {
    _hotView = [[UIView alloc] initWithFrame: CGRectInset(self.bounds, -10, -10)];
    [self addSubview: _hotView];
    _hotView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _hotView attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _hotView attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _hotView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeWidth multiplier: 1.0 constant: 20.0],
            [NSLayoutConstraint constraintWithItem: _hotView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeHeight multiplier: 1.0 constant: 20.0]
    ]];

    [self _setupGestures];

}

- (void) _setupGestures {

    _doubleTapGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [self _notifyDidDoubleTap];
    }];
    _doubleTapGesture.delegate = self;
    _doubleTapGesture.numberOfTapsRequired = 2;
    [_hotView addGestureRecognizer: _doubleTapGesture];

    _tapGesture = [[UITapGestureRecognizer alloc] bk_initWithHandler: ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (self.nodeState == TFNodeViewStateRelated) {
            [self _notifyDidTriggerRelated];
        } else if (self.nodeState == TFNodeViewStateDelete) {
            [self _notifyDidTriggerDeletion];
        }
    }];
    [_hotView addGestureRecognizer: _tapGesture];

    void (^handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) = ^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *) sender;

        switch (gesture.state) {
            case UIGestureRecognizerStateBegan : {
                _startingOffset = _scrollView.contentOffset;
                break;
            }

            case UIGestureRecognizerStateChanged : {
                CGPoint translation = [gesture translationInView: gesture.view];
                translation.x = fminf(fabsf(translation.x), TFNodeViewWidth) * (translation.x < 0 ? -1 : 1);

                CGPoint offset = CGPointMake(_startingOffset.x - translation.x, _startingOffset.y - translation.y);
                offset = CGPointMake(fmaxf(0, fminf(offset.x, TFNodeViewWidth * 2)), fmaxf(0, fminf(offset.y, TFNodeViewHeight)));
                offset.x = _startingOffset.y == TFNodeViewHeight ? offset.x : _startingOffset.x;
                offset.y = _startingOffset.x == TFNodeViewWidth ? offset.y : _startingOffset.y;

                if (gesture == _horizontalPan) {
                    _scrollView.contentOffset = CGPointMake(offset.x, _startingOffset.y);

                } else if (gesture == _verticalPan) {
                    _scrollView.contentOffset = CGPointMake(_startingOffset.x, offset.y);
                }
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed: {
                CGPoint offset = _scrollView.contentOffset;
                CGPoint remainder = CGPointMake(offset.x / TFNodeViewWidth, offset.y / TFNodeViewHeight);
                CGPoint newOffset = CGPointMake(roundf(remainder.x) * TFNodeViewWidth, roundf(remainder.y) * TFNodeViewHeight);

                CGPoint velocity = [gesture velocityInView: gesture.view];
                //                CGFloat springVelocity = (-0.1f * velocity.x) / (curX - snapX);
                [UIView animateWithDuration: 0.4
                        delay: 0.0
                        usingSpringWithDamping: 0.8
                        initialSpringVelocity: -2.0
                        options: UIViewAnimationOptionCurveLinear
                        animations: ^{
                            _scrollView.contentOffset = newOffset;
                        }
                        completion: ^(BOOL finished) {
                            [self _refreshNodeState];
                        }];

                break;
            }
            case UIGestureRecognizerStatePossible:
                break;
        }
    };

    _verticalPan = [[UIPanGestureRecognizer alloc] bk_initWithHandler: handler];
    _verticalPan.delegate = self;
    [_hotView addGestureRecognizer: _verticalPan];

    _horizontalPan = [[UIPanGestureRecognizer alloc] bk_initWithHandler: handler];
    _horizontalPan.delegate = self;
    [_hotView addGestureRecognizer: _horizontalPan];
}

- (void) _setupScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame: self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = NO;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self embedView: _scrollView];

    _contentView = [[TFGradientView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth * 3, TFNodeViewHeight)];
    _contentView.backgroundColor = [UIColor clearColor];
    [_scrollView embedView: _contentView];
    _scrollView.contentOffset = CGPointMake(TFNodeViewWidth, TFNodeViewHeight);

    [self _setupNodeSubviews];
    [self _setupContentViews];

}


- (void) _setupNodeSubviews {

    _centerContentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight)];
    _centerContentView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview: _centerContentView];
    _centerContentView.translatesAutoresizingMaskIntoConstraints = NO;

    _leftContentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight)];
    _leftContentView.backgroundColor = [UIColor greenColor];
    [_contentView addSubview: _leftContentView];
    _leftContentView.translatesAutoresizingMaskIntoConstraints = NO;

    _rightContentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight)];
    _rightContentView.backgroundColor = [UIColor redColor];
    [_contentView addSubview: _rightContentView];
    _rightContentView.translatesAutoresizingMaskIntoConstraints = NO;

    _topContentView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight)];
    _topContentView.backgroundColor = [UIColor blueColor];
    [_contentView addSubview: _topContentView];
    _topContentView.translatesAutoresizingMaskIntoConstraints = NO;

    [_contentView addConstraints: @[
            [NSLayoutConstraint constraintWithItem: _topContentView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _topContentView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _topContentView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _topContentView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _topContentView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],

            [NSLayoutConstraint constraintWithItem: _centerContentView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _leftContentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _centerContentView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _rightContentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _centerContentView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _topContentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _centerContentView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _centerContentView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: _centerContentView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],

            [NSLayoutConstraint constraintWithItem: _leftContentView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _leftContentView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _leftContentView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _leftContentView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _leftContentView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: _leftContentView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],

            [NSLayoutConstraint constraintWithItem: _rightContentView attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _rightContentView attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: _contentView attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _rightContentView attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeTop multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _rightContentView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: _centerContentView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: _rightContentView attribute: NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewWidth],
            [NSLayoutConstraint constraintWithItem: _rightContentView attribute: NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem: nil attribute: NSLayoutAttributeNotAnAttribute multiplier: 1.0 constant: TFNodeViewHeight],
    ]];

}
#pragma mark - Setup content views


- (void) _setupContentViews {

    _leftContentView.backgroundColor = [UIColor clearColor];
    _leftContentView.opaque = NO;
    _rightContentView.backgroundColor = [UIColor clearColor];
    _rightContentView.opaque = NO;
    _centerContentView.backgroundColor = [UIColor clearColor];
    _centerContentView.opaque = NO;
    _topContentView.backgroundColor = [UIColor clearColor];
    _topContentView.opaque = NO;

    [self _setupLeftContentView];
    [self _setupCenterContentView];
    [self _setupRightContentView];
    [self _setupTopContentView];

    //    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    //    button.frame = _rightContentView.bounds;
    //    button.backgroundColor = [UIColor tfRedColor];
    //    [_rightContentView embedView: button];
}

- (void) _setupCenterContentView {

    BOOL translucent = NO;
    if (translucent) {
        ILTranslucentView *bg = [[ILTranslucentView alloc] initWithFrame: self.bounds];
        bg.backgroundColor = [UIColor clearColor];
        bg.translucentTintColor = [UIColor clearColor];
        bg.translucentAlpha = 0.8;
        bg.translucentStyle = UIBarStyleDefault;
        [_centerContentView embedView: bg];

    } else {
        _selectionBg = [[UIView alloc] initWithFrame: self.bounds];
        _selectionBg.backgroundColor = [UIColor whiteColor];
        _selectionBg.alpha = 0.5;
        [_centerContentView embedView: _selectionBg];
    }



    //    TFWhiteTranslucentView *bg = [[TFWhiteTranslucentView alloc] initWithFrame: self.bounds];
    //    [_centerContentView embedView: bg];

    _textLabel = [[UILabel alloc] init];
    _textLabel.text = self.node.title;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont italicSerif: 14];
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_centerContentView embedView: _textLabel withInsets: UIEdgeInsetsMake(6, 6, 6, 6)];


    //    [_centerContentView addSubview: label];
    //
    //
    //    label.translatesAutoresizingMaskIntoConstraints = NO;
    //    [_centerContentView addConstraints:  @[
    //
    //    [NSLayoutConstraint constraintWithItem: la attribute: <#(NSLayoutAttribute)attr1#> relatedBy: <#(NSLayoutRelation)relation#> toItem: <#(id)view2#> attribute: <#(NSLayoutAttribute)attr2#> multiplier: <#(CGFloat)multiplier#> constant: <#(CGFloat)c#>]
    //    ]];

}

- (void) _setupLeftContentView {

    BOOL translucent = NO;
    if (translucent) {
        ILTranslucentView *bg = [[ILTranslucentView alloc] initWithFrame: _rightContentView.bounds];
        bg.opaque = NO;
        bg.backgroundColor = [UIColor clearColor];
        bg.translucentTintColor = [UIColor tfGreenColor];
        bg.translucentAlpha = 0.8;
        bg.translucentStyle = UIBarStyleDefault;
        [_leftContentView embedView: bg];

    } else {
        //        UIView *bg = [[UIView alloc] initWithFrame: self.bounds];
        //        bg.backgroundColor = [UIColor tfGreenColor];
        //        bg.alpha = 0.5;
        //        [_leftContentView embedView: bg];
        _leftContentView.backgroundColor = [[UIColor tfGreenColor] colorWithAlphaComponent: 0.9];
    }

    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button embedView: [self buttonView: [UIImage imageNamed: @"icon-node-add"] text: @"DRAG\nOUT"]];
    [_leftContentView embedView: button];
}


- (void) _setupRightContentView {

    BOOL translucent = NO;
    if (translucent) {

        ILTranslucentView *bg = [[ILTranslucentView alloc] initWithFrame: _rightContentView.bounds];
        bg.opaque = NO;
        bg.backgroundColor = [UIColor clearColor];
        bg.translucentTintColor = [UIColor tfRedColor];
        bg.translucentAlpha = 0.8;
        bg.translucentStyle = UIBarStyleDefault;
        [_rightContentView embedView: bg];

    } else {
        //        UIView *bg = [[UIView alloc] initWithFrame: self.bounds];
        //        bg.backgroundColor = [UIColor tfRedColor];
        //        bg.alpha = 0.5;
        //        [_centerContentView embedView: bg];


        _rightContentView.backgroundColor = [[UIColor tfRedColor] colorWithAlphaComponent: 0.9];

    }

    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    button.frame = _rightContentView.bounds;
    [button setImage: [UIImage imageNamed: @"cancel-icon"] forState: UIControlStateNormal];
    [button bk_addEventHandler: ^(UIButton *aButton) {

    } forControlEvents: UIControlEventTouchUpInside];
    [_rightContentView embedView: button];

}

- (void) _setupTopContentView {
    BOOL translucent = NO;
    if (translucent) {

        ILTranslucentView *bg = [[ILTranslucentView alloc] initWithFrame: _rightContentView.bounds];
        bg.opaque = NO;
        bg.backgroundColor = [UIColor clearColor];
        bg.translucentTintColor = [UIColor tfPurpleColor];
        bg.translucentAlpha = 0.9;
        bg.translucentStyle = UIBarStyleDefault;
        [_topContentView embedView: bg];

    } else {

        _topContentView.backgroundColor = [[UIColor tfPurpleColor] colorWithAlphaComponent: 0.9];

    }

    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button embedView: [self buttonView: [UIImage imageNamed: @"icon-node-relevant"] text: @"RELATED"]];
    [_topContentView embedView: button];

}


- (UIView *) buttonView: (UIImage *) image text: (NSString *) text {

    UIView *ret = [[UIView alloc] initWithFrame: CGRectMake(0, 0, TFNodeViewWidth, TFNodeViewHeight)];


    UIImageView *imageView = [[UIImageView alloc] initWithImage: image];
    [ret addSubview: imageView];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [ret addConstraints: @[
            [NSLayoutConstraint constraintWithItem: imageView attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: ret attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0.0],
            [NSLayoutConstraint constraintWithItem: imageView attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem: ret attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0.0]
    ]];

    TFKernedGothamLightLabel *textLabel = [[TFKernedGothamLightLabel alloc] init];
    textLabel.text = text;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont fontWithName: textLabel.font.fontName size: 12.0];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [ret addSubview: textLabel];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [ret addConstraints: @[
            [NSLayoutConstraint constraintWithItem: textLabel attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: ret attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0.0],

            //            [NSLayoutConstraint constraintWithItem: textLabel attribute: NSLayoutAttributeLeading relatedBy: NSLayoutRelationEqual toItem: ret attribute: NSLayoutAttributeLeading multiplier: 1.0 constant: 20.0],
            //            [NSLayoutConstraint constraintWithItem: textLabel attribute: NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem: ret attribute: NSLayoutAttributeTrailing multiplier: 1.0 constant: 20.0],
            [NSLayoutConstraint constraintWithItem: textLabel attribute: NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem: imageView attribute: NSLayoutAttributeBottom multiplier: 1.0 constant: 5.0],
    ]];

    return ret;
}
@end