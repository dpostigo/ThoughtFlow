//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIView+DPConstraints.h"
#import "NSLayoutConstraint+DPUtils.h"
#import "UIView+DPKit.h"

@implementation UIView (DPConstraints)



#pragma mark Super Insets


- (NSArray *) updateSuperConstraintsWithInsets: (UIEdgeInsets) insets {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [ret addObject: [self updateSuperTopConstraint: insets.top]];
    [ret addObject: [self updateSuperBottomConstraint: -insets.bottom]];
    [ret addObject: [self updateSuperLeadingConstraint: insets.left]];
    [ret addObject: [self updateSuperTrailingConstraint: insets.right]];
    return ret;
}


- (NSArray *) updateSuperEdgeConstraints: (CGFloat) constant {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    [ret addObject: [self updateSuperTopConstraint: constant]];
    [ret addObject: [self updateSuperBottomConstraint: constant]];
    [ret addObject: [self updateSuperLeadingConstraint: constant]];
    [ret addObject: [self updateSuperTrailingConstraint: constant]];
    return ret;
}


#pragma mark Super CenterX

- (NSLayoutConstraint *) superCenterXConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint *) updateSuperXConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superCenterXConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self
                                               attribute: NSLayoutAttributeCenterX
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self.superview
                                               attribute: NSLayoutAttributeCenterX
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
        ret.constant = constant;
    }

    return ret;
}


#pragma mark Super CenterX

- (NSLayoutConstraint *) superCenterYConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeCenterY];
}

- (NSLayoutConstraint *) updateSuperCenterYConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superCenterYConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self
                                               attribute: NSLayoutAttributeCenterY
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self.superview
                                               attribute: NSLayoutAttributeCenterY
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
        ret.constant = constant;
    }

    return ret;
}



#pragma mark Super Leading

- (NSLayoutConstraint *) superLeadingConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeLeading];
}

- (NSLayoutConstraint *) updateSuperLeadingConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superLeadingConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self
                                               attribute: NSLayoutAttributeLeading
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self.superview
                                               attribute: NSLayoutAttributeLeading
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
        ret.constant = constant;
    }

    return ret;
}


#pragma mark Super Trailing

- (NSLayoutConstraint *) superTrailingConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint *) updateSuperTrailingConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superTrailingConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self.superview
                                               attribute: NSLayoutAttributeTrailing
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self
                                               attribute: NSLayoutAttributeTrailing
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
        ret.constant = constant;
    }

    return ret;
}



#pragma mark SuperTop

- (NSLayoutConstraint *) superTopConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeTop];
}


- (NSLayoutConstraint *) updateSuperTopConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superTopConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self
                                               attribute: NSLayoutAttributeTop
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self.superview
                                               attribute: NSLayoutAttributeTop
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];

        }
        ret.constant = constant;
    }

    return ret;
}



#pragma mark SuperBottom

- (NSLayoutConstraint *) superBottomConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeBottom];
}


- (NSLayoutConstraint *) updateSuperBottomConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superBottomConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self.superview
                                               attribute: NSLayoutAttributeBottom
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self
                                               attribute: NSLayoutAttributeBottom
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];

        }
        ret.constant = constant;
    }

    return ret;
}




#pragma mark SuperHeight


- (NSLayoutConstraint *) superHeightConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *) updateSuperHeightConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;

    if (self.superview) {
        ret = [self superHeightConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self.superview
                                               attribute: NSLayoutAttributeHeight
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self
                                               attribute: NSLayoutAttributeHeight
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
        ret.constant = constant;
    }

    return ret;
}


- (NSLayoutConstraint *) createSuperConstraintForAttribute: (NSLayoutAttribute) attribute {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [NSLayoutConstraint constraintWithItem: self.superview
                                           attribute: attribute
                                           relatedBy: NSLayoutRelationEqual
                                              toItem: self
                                           attribute: attribute
                                          multiplier: 1
                                            constant: 0];
        [self.superview addConstraint: ret];
    }

    return ret;
}


#pragma mark Height

- (NSLayoutConstraint *) heightConstraint {
    NSArray *constraints = [NSArray arrayWithArray: self.constraints];

    NSLayoutConstraint *ret = nil;
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeHeight &&
                constraint.secondAttribute == NSLayoutAttributeNotAnAttribute &&
                constraint.firstItem == self) {
            ret = constraint;
            break;

        }
    }

    return ret;
}

- (NSLayoutConstraint *) updateHeightConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = [self heightConstraint];
    if (ret == nil) {
        ret = [NSLayoutConstraint constraintWithItem: self
                                           attribute: NSLayoutAttributeHeight
                                           relatedBy: NSLayoutRelationEqual
                                              toItem: nil
                                           attribute: NSLayoutAttributeNotAnAttribute
                                          multiplier: 1
                                            constant: constant];
        [self addConstraint: ret];
    }

    ret.constant = constant;

    return ret;
}


#pragma mark Static Width


- (NSLayoutConstraint *) updateWidthConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = [self staticWidthConstraint];
    if (ret == nil) {
        ret = [NSLayoutConstraint constraintWithItem: self
                                           attribute: NSLayoutAttributeWidth
                                           relatedBy: NSLayoutRelationEqual
                                              toItem: nil
                                           attribute: NSLayoutAttributeNotAnAttribute
                                          multiplier: 1
                                            constant: constant];
        [self addConstraint: ret];
    }

    ret.constant = constant;

    return ret;
}

- (NSLayoutConstraint *) staticWidthConstraint {
    NSArray *constraints = [NSArray arrayWithArray: self.constraints];

    NSLayoutConstraint *ret = nil;
    for (NSLayoutConstraint *constraint in constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth &&
                constraint.secondAttribute == NSLayoutAttributeNotAnAttribute &&
                constraint.firstItem == self) {
            ret = constraint;
            break;

        }
    }

    return ret;
}




#pragma mark Super Width

- (NSLayoutConstraint *) superWidthConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *) updateSuperWidthConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superWidthConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self
                                               attribute: NSLayoutAttributeWidth
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self.superview
                                               attribute: NSLayoutAttributeWidth
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];

        }
        ret.constant = constant;
    }

    return ret;
}





#pragma mark Equal widths

- (NSLayoutConstraint *) equalWidthConstraintForSibling: (UIView *) item {
    NSLayoutConstraint *ret = nil;

    if (self.superview && item.superview && self.superview == item.superview) {
        NSArray *constraints = [NSArray arrayWithArray: self.superview.constraints];
        for (NSLayoutConstraint *constraint in constraints) {
            if (constraint.relation == NSLayoutRelationEqual) {
                if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.firstItem == self) {
                    if (constraint.secondAttribute == NSLayoutAttributeWidth && constraint.secondItem == item) {
                        ret = constraint;
                        break;
                    }
                }

                if (constraint.secondAttribute == NSLayoutAttributeWidth && constraint.secondItem == self) {
                    if (constraint.firstAttribute == NSLayoutAttributeWidth && constraint.firstItem == item) {
                        ret = constraint;
                        break;
                    }
                }
            }
        }
    }
    return ret;
}


- (NSLayoutConstraint *) updateEqualWidthConstraint: (CGFloat) constant sibling: (UIView *) item {
    NSLayoutConstraint *ret = nil;

    if (self.superview && item.superview && self.superview == item.superview) {
        ret = [self equalWidthConstraintForSibling: item];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self
                                               attribute: NSLayoutAttributeWidth
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: item
                                               attribute: NSLayoutAttributeWidth
                                              multiplier: 1.0
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
    }
    return ret;
}


- (NSLayoutConstraint *) anyWidthConstraint {
    NSLayoutConstraint *ret = nil;

    if (self.staticWidthConstraint) {
        ret = self.staticWidthConstraint;
    } else if (self.superWidthConstraint) {
        ret = self.superWidthConstraint;
    } else if (self.superview) {
        NSArray *constraints = [NSArray arrayWithArray: self.superview.constraints];
        for (NSLayoutConstraint *constraint in constraints) {
            if ((constraint.firstAttribute == NSLayoutAttributeWidth && constraint.firstItem == self) ||
                    (constraint.secondAttribute == NSLayoutAttributeWidth && constraint.secondItem == self)) {
                ret = constraint;
                break;

            }
        }
    }
    return ret;
}


//- (NSLayoutConstraint *) superviewConstraintForAttribute: (NSLayoutAttribute) attribute {
//
//}
//
//- (NSLayoutConstraint *) getConstraintForItem: (id) item attribute: {
//
//    NSArray *constraints = [NSArray arrayWithArray: self.constraints];
//    for (NSLayoutConstraint *constraint in constraints) {
//        if (constraint.firstAttribute == NSLayoutAttributeWidth &&  constraint.firstI
//            constraint.secondAttribute == NSLayoutAttributeNotAnAttribute &&
//                    constraint.firstItem == self) {
//            ret = constraint;
//            break;
//
//        }
//    }
//
//}

#pragma mark Sibling constraints

- (NSLayoutConstraint *) updateTrailingConstraint: (CGFloat) constant toSibling: (id) sibling {
    return [self updateTrailingConstraint: constant toSibling: sibling attribute: NSLayoutAttributeTrailing];
}


- (NSLayoutConstraint *) updateTrailingConstraint: (CGFloat) constant toSibling: (id) sibling attribute: (NSLayoutAttribute) attribute {
    NSLayoutConstraint *ret = nil;

    if (self.superview) {
        ret = [NSLayoutConstraint constraintWithItem: self
                                           attribute: NSLayoutAttributeTrailing
                                           relatedBy: NSLayoutRelationEqual
                                              toItem: sibling
                                           attribute: attribute
                                          multiplier: 1.0
                                            constant: 0];
        [self.superview addConstraint: ret];
    }
    return ret;
}


#pragma mark General


- (NSLayoutConstraint *) superConstraintForAttribute: (NSLayoutAttribute) attribute {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        NSArray *constraints = [NSArray arrayWithArray: self.superview.constraints];

        for (NSLayoutConstraint *constraint in constraints) {
            if (constraint.firstItem == self && constraint.firstAttribute == attribute) {
                if (constraint.secondItem == self.superview && constraint.secondAttribute == attribute) {
                    ret = constraint;
                    break;
                }

                if (attribute == NSLayoutAttributeTop || attribute == NSLayoutAttributeBottom) {
                    if ([NSStringFromClass(
                            [constraint.secondItem class]) isEqualToString: @"_UILayoutGuide"] && constraint.secondAttribute == attribute) {
                        ret = constraint;
                        break;
                    }

                }
            } else if (constraint.secondItem == self && constraint.secondAttribute == attribute) {
                if (constraint.firstItem == self.superview && constraint.firstAttribute == attribute) {
                    ret = constraint;
                    break;
                }
            }
        }
    }

    return ret;

}
@end