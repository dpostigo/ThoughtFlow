//
// Created by Dani Postigo on 7/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFButtonBox.h"


@implementation TFButtonBox

- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect titleLabelFrame = self.titleLabel.frame;
    //    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    //
    //    CGRect imageFrame = self.imageView.frame;
    //
    //    CGSize fitBoxSize = (CGSize){.height = labelSize.height + kTextTopPadding +  imageFrame.size.height, .width = MAX(imageFrame.size.width, labelSize.width)};
    //
    //    CGRect fitBoxRect = CGRectInset(self.bounds, (self.bounds.size.width - fitBoxSize.width)/2, (self.bounds.size.height - fitBoxSize.height)/2);
    //
    //    imageFrame.origin.y = fitBoxRect.origin.y;
    //    imageFrame.origin.x = CGRectGetMidX(fitBoxRect) - (imageFrame.size.width/2);
    //    self.imageView.frame = imageFrame;
    //
    //    // Adjust the label size to fit the text, and move it below the image
    //
    //    titleLabelFrame.size.width = labelSize.width;
    //    titleLabelFrame.size.height = labelSize.height;
    //    titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2);
    //    titleLabelFrame.origin.y = fitBoxRect.origin.y + imageFrame.size.height + kTextTopPadding;
    //    self.titleLabel.frame = titleLabelFrame;

}

//
//-(void)layoutSubviews {
//    [super layoutSubviews];
//
//    CGRect titleLabelFrame = self.titleLabel.frame;
//    CGSize labelSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//
//    CGRect imageFrame = self.imageView.frame;
//
//    CGSize fitBoxSize = (CGSize){.height = labelSize.height + kTextTopPadding +  imageFrame.size.height, .width = MAX(imageFrame.size.width, labelSize.width)};
//
//    CGRect fitBoxRect = CGRectInset(self.bounds, (self.bounds.size.width - fitBoxSize.width)/2, (self.bounds.size.height - fitBoxSize.height)/2);
//
//    imageFrame.origin.y = fitBoxRect.origin.y;
//    imageFrame.origin.x = CGRectGetMidX(fitBoxRect) - (imageFrame.size.width/2);
//    self.imageView.frame = imageFrame;
//
//    // Adjust the label size to fit the text, and move it below the image
//
//    titleLabelFrame.size.width = labelSize.width;
//    titleLabelFrame.size.height = labelSize.height;
//    titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2);
//    titleLabelFrame.origin.y = fitBoxRect.origin.y + imageFrame.size.height + kTextTopPadding;
//    self.titleLabel.frame = titleLabelFrame;
//}
@end