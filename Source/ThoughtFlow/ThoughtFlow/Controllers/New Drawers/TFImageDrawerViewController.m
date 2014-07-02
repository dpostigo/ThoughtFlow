//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/NSMutableAttributedString+DPKit.h>
#import <NSAttributedString-DDHTML/NSAttributedString+DDHTML.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import <DPKit-Utils/UIView+DPKit.h>
#import "TFImageDrawerViewController.h"
#import "TFPhoto.h"
#import "UIColor+TFApp.h"


@implementation TFImageDrawerViewController

- (instancetype) initWithImage: (TFPhoto *) image {
    TFImageDrawerViewController *ret = [[UIStoryboard storyboardWithName: @"Mindmap" bundle: nil] instantiateViewControllerWithIdentifier: @"TFImageDrawerViewController"];
    ret.image = image;
    return ret;
}


#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    _tagLabel.preferredMaxLayoutWidth = _tagLabel.width;
    [_tagLabel addDebugBorder: [UIColor redColor]];
    //    [_descriptionLabel addDebugBorder: [UIColor redColor]];

    self.image = _image;
}


- (void) setImage: (TFPhoto *) image {
    _image = image;
    if (_image && self.isViewLoaded) {

        _titleLabel.text = [_image.title uppercaseString];
        //
        //        NSMutableAttributedString *attributedString;
        //        attributedString = [[NSAttributedString attributedStringFromHTML: _image.description boldFont: [UIFont boldSystemFontOfSize: 12.0]] mutableCopy];
        //        [attributedString addAttribute: NSForegroundColorAttributeName value: [UIColor tfDetailTextColor]];
        //        [attributedString addAttribute: NSFontAttributeName value: _descriptionLabel.font];
        //        _descriptionLabel.attributedText = attributedString;
        //        _descriptionLabel.textContainerInset = UIEdgeInsetsMake(0, -3, 0, 0);

        _sourceLabel.text = @"Author from Source";
        _tagLabel.text = _image.tagString;
        _tagLabel.text = @"tag tag tag tag\ntag tag tag tag";
    }
}


@end