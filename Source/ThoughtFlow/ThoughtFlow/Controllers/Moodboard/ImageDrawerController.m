//
// Created by Dani Postigo on 5/10/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "ImageDrawerController.h"
#import "Model.h"
#import "TFPhoto.h"
#import "NSAttributedString+DDHTML.h"
#import "NSMutableAttributedString+DPKit.h"
#import "UIColor+TFApp.h"


@implementation ImageDrawerController

- (void) viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(selectedPhotoDidChange:) name: TFSelectedPhotoDidChange object: nil];

    _tagLabel.preferredMaxLayoutWidth = _tagLabel.width;
    [_tagLabel addDebugBorder: [UIColor redColor]];
    [_descriptionLabel addDebugBorder: [UIColor redColor]];
    [self selectedPhotoDidChange: nil];

    //    [self.view convertFonts];

}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];

}



#pragma mark Actions

- (void) selectedPhotoDidChange: (NSNotification *) notification {

    if (_model.selectedPhoto) {
        TFPhoto *photo = _model.selectedPhoto;

        _titleLabel.text = [photo.title uppercaseString];

        NSMutableAttributedString *attributedString;
        attributedString = [[NSAttributedString attributedStringFromHTML: photo.description boldFont: [UIFont boldSystemFontOfSize: 12.0]] mutableCopy];
        [attributedString addAttribute: NSForegroundColorAttributeName value: [UIColor tfDetailTextColor]];
        [attributedString addAttribute: NSFontAttributeName value: _descriptionLabel.font];
        _descriptionLabel.attributedText = attributedString;
        _descriptionLabel.textContainerInset = UIEdgeInsetsMake(0, -3, 0, 0);

        NSLog(@"photo.description = %@", photo.description);

        _sourceLabel.text = @"Author from Source";
        _tagLabel.text = photo.tagString;
        [_tagLabel sizeToFit];

    }
}

@end