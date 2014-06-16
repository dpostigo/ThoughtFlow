//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import "ImageDrawerController.h"
#import "UIView+TFFonts.h"
#import "Model.h"
#import "TFPhoto.h"
#import "NSAttributedString+DDHTML.h"
#import "NSMutableAttributedString+DPKit.h"

@implementation ImageDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    //    [self.view convertFonts];


    NSLog(@"_tagLabel.width = %f", _tagLabel.width);
    _tagLabel.preferredMaxLayoutWidth = _tagLabel.width;

    if (_model.selectedPhoto) {
        TFPhoto *photo = _model.selectedPhoto;

        _titleLabel.text = [photo.title uppercaseString];

        NSMutableAttributedString *attributedString;
        attributedString = [[NSAttributedString attributedStringFromHTML: photo.description boldFont: [UIFont boldSystemFontOfSize: 12.0]] mutableCopy];
        [attributedString addAttribute: NSForegroundColorAttributeName value: _descriptionLabel.textColor];
        [attributedString addAttribute: NSFontAttributeName value: _descriptionLabel.font];
        _descriptionLabel.attributedText = attributedString;
        _descriptionLabel.textContainerInset = UIEdgeInsetsMake(0, -3, 0, 0);

        _sourceLabel.text = @"Author from Source";
        _tagLabel.text = photo.tagString;

    }

    //    [self.view convertFonts];

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

    [_tagLabel sizeToFit];
}


@end