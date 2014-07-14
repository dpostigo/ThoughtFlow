//
// Created by Dani Postigo on 7/4/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKitDebug.h>
#import "TFImageDrawerContentViewController.h"
#import "DPTableViewCell.h"
#import "TFPhoto.h"
#import "NSAttributedString+DDHTML.h"
#import "UIColor+TFApp.h"
#import "NSMutableAttributedString+DPKit.h"


#define IMAGE_CREDITS  @"Image Credits"
#define IMAGE_DESCRIPTION  @"Image Description"
#define IMAGE_TAGS  @"Tags From Source"

@interface TFImageDrawerContentViewController ()

@property(nonatomic, strong) DPTableViewCell *prototype;
@property(nonatomic, strong) NSArray *rows;
@end

@implementation TFImageDrawerContentViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    _rows = @[IMAGE_CREDITS, IMAGE_DESCRIPTION, IMAGE_TAGS];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque = NO;
    //    self.tableView.estimatedRowHeight = 40;
    //    [self.tableView reloadData];
}

- (void) setImage: (TFPhoto *) image {
    _image = image;
    [self.tableView reloadData];
    [self.view layoutIfNeeded];
}


- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

    DPTableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: @"TableCell" forIndexPath: indexPath];

    [self configureCell: ret atIndexPath: indexPath];
    return ret;
}

- (void) configureCell: (DPTableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    cell.backgroundColor = [UIColor clearColor];

    NSString *title = [_rows objectAtIndex: indexPath.row];
    cell.textLabel.text = [title uppercaseString];

    if (_image) {
        if ([title isEqualToString: IMAGE_CREDITS]) {
            cell.detailTextLabel.text = @"Image credits";

        } else if ([title isEqualToString: IMAGE_DESCRIPTION]) {

            NSMutableAttributedString *attributedString;
            attributedString = [[NSAttributedString attributedStringFromHTML: _image.description boldFont: [UIFont boldSystemFontOfSize: 12.0]] mutableCopy];
            [attributedString addAttribute: NSForegroundColorAttributeName value: cell.detailTextLabel.textColor];
            //        [attributedString addAttribute: NSFontAttributeName value: _descriptionLabel.font];
            cell.detailTextLabel.attributedText = attributedString;


            //        cell.detailTextLabel.text = _image.description;
            //        cell.detailTextLabel.text = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";

        } else if ([title isEqualToString: IMAGE_TAGS]) {
            cell.detailTextLabel.text = _image.tagString;
        }
    }

    cell._detailTextLabel.alpha = 0.9;
    //    [cell.detailTextLabel sizeToFit];

}

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_rows count];
}


- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

    [self configureCell: self.prototype atIndexPath: indexPath];

    //    [self.prototype setNeedsUpdateConstraints];
    //    [self.prototype updateConstraintsIfNeeded];
    //
    ////    [_prototype.contentView setNeedsLayout];
    ////    [_prototype.contentView layoutIfNeeded];

    //    [_prototype layoutIfNeeded];


    self.prototype.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 44);
    [self.prototype layoutIfNeeded];

    CGFloat height = [self.prototype.contentView systemLayoutSizeFittingSize: UILayoutFittingCompressedSize].height;

    return height + 1;
}


- (CGFloat) tableView: (UITableView *) tableView estimatedHeightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 44;
}


- (DPTableViewCell *) prototype {
    if (_prototype == nil) {
        _prototype = [self.tableView dequeueReusableCellWithIdentifier: @"TableCell"];

    }
    return _prototype;
}

@end