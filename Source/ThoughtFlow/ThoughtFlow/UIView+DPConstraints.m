//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UIView+DPConstraints.h"
#import "NSLayoutConstraint+DPUtils.h"

@implementation UIView (DPConstraints)



#pragma mark Leading

- (NSLayoutConstraint *) updateSuperLeadingConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superLeadingConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self.superview
                                               attribute: NSLayoutAttributeLeading
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self
                                               attribute: NSLayoutAttributeLeading
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];
        }
        ret.constant = constant;
    }

    return ret;
}

- (NSLayoutConstraint *) superLeadingConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeLeading];
}


#pragma mark Trailing

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



#pragma mark Top

- (NSLayoutConstraint *) updateSuperTopConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = nil;
    if (self.superview) {
        ret = [self superTopConstraint];
        if (ret == nil) {
            ret = [NSLayoutConstraint constraintWithItem: self.superview
                                               attribute: NSLayoutAttributeTop
                                               relatedBy: NSLayoutRelationEqual
                                                  toItem: self
                                               attribute: NSLayoutAttributeTop
                                              multiplier: 1
                                                constant: constant];
            [self.superview addConstraint: ret];

        }
        ret.constant = constant;
    }

    return ret;
}


- (NSLayoutConstraint *) superTopConstraint {
    return [self superConstraintForAttribute: NSLayoutAttributeTop];
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


#pragma mark Width

- (NSLayoutConstraint *) updateWidthConstraint: (CGFloat) constant {
    NSLayoutConstraint *ret = [self heightConstraint];
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

- (NSLayoutConstraint *) widthConstraint {
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