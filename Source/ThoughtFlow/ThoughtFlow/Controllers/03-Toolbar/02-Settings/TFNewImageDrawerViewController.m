//
// Created by Dani Postigo on 7/14/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <DPKit-Utils/NSMutableAttributedString+DPKit.h>
#import <DTCoreText/DTAttributedTextContentView.h>
#import <BlocksKit/NSObject+BKBlockExecution.h>
#import "TFNewImageDrawerViewController.h"
#import "Project.h"
#import "TFPhoto.h"
#import "TFTableViewCell.h"
#import "TFImageDrawerContentViewController.h"
#import "UIControl+BlocksKit.h"
#import "NSAttributedString+HTML.h"
#import "DTCoreTextConstants.h"
#import "NSString+HTML.h"
#import "NSString+Paragraphs.h"
#import "TFAttributedTableViewCell.h"
#import "DTAttributedLabel.h"
#import "NSAttributedString+DDHTML.h"


NSString *const TFImageDrawerImageCredits = @"Image Credits";
NSString *const TFImageDrawerImageDescription = @"Image Description";
NSString *const TFImageDrawerImageTags = @"Tags From Source";


@interface TFNewImageDrawerViewController ()

@property(nonatomic, strong) TFTableViewController *tableViewController;
@end

@implementation TFNewImageDrawerViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    return [self viewControllerFromStoryboard: @"Mindmap"];

}

- (instancetype) initWithProject: (Project *) project image: (TFPhoto *) image {
    self = [super init];
    if (self) {
        _project = project;
        _image = image;
        _rows = @[TFImageDrawerImageCredits, TFImageDrawerImageDescription, TFImageDrawerImageTags];

    }

    return self;
}


#pragma mark - View lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];

    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame);

    _tableViewController = [[TFTableViewController alloc] init];
    _tableViewController.cellIdentifier = TFTableViewDefaultCellIdentifier;
    _tableViewController.delegate = self;

    [self embedController: _tableViewController inView: _containerView];
    [self _setupView];

    self.image = _image;

}

- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    [self.view layoutIfNeeded];
}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [self.view layoutIfNeeded];

}


- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame);
}


#pragma mark - Image


- (void) setImage: (TFPhoto *) image {
    _image = image;

    if (self.isViewLoaded) {
        if (_image == nil) {

        } else {

            _titleLabel.text = [_image.title uppercaseString];

            if (_project) {
                _pinButton.selected = [_project.pinnedImages containsObject: _image];
            }

            [_tableViewController reloadData];
            [self.view layoutIfNeeded];
        }

    }
}


#pragma mark - Setup

- (void) _setupView {

    [_pinButton setTitle: @"PIN TO MOODBOARD" forState: UIControlStateNormal];
    [_pinButton setTitle: @"REMOVE FROM MOODBOARD" forState: UIControlStateSelected];

    [_pinButton bk_addEventHandler: ^(id sender) {
        UIButton *button = sender;
        button.selected = !button.selected;

        if (button.selected) {
            if (![_project.pinnedImages containsObject: _image]) {
                [_project addPin: _image];
                [self _notifyAddedPin: _image];
            }
        } else {
            if ([_project.pinnedImages containsObject: _image]) {
                [_project removePin: _image];
                [self _notifyRemovedPin: _image];
            }
        }
    } forControlEvents: UIControlEventTouchUpInside];
}


#pragma mark - Delegates
#pragma mark - TFTableViewControllerDelegate

- (void) configureCell: (UITableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {

    cell.backgroundColor = [UIColor clearColor];

    NSString *title = [_rows objectAtIndex: indexPath.row];
    cell.textLabel.text = [title uppercaseString];

    if (_image) {
        if ([title isEqualToString: TFImageDrawerImageCredits]) {
            cell.detailTextLabel.text = @"Image credits";

        } else if ([title isEqualToString: TFImageDrawerImageDescription]) {
            [self handleDescriptionLabel: (TFTableViewCell *) cell];

        } else if ([title isEqualToString: TFImageDrawerImageTags]) {
            cell.detailTextLabel.text = _image.tagString;
        }
    }

    cell.detailTextLabel.alpha = 0.7;

}


- (void) handleDescriptionLabel: (TFTableViewCell *) cell {

    NSData *data;
    NSString *description = _image.description;

    if (description != nil) {

        description = [description stringByReplacingHTMLEntities];
        data = [description dataUsingEncoding: NSUTF8StringEncoding];

        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTMLData: data documentAttributes: NULL];

        if (attributedString) {
            NSMutableAttributedString *mutableString = [attributedString mutableCopy];
            [mutableString addAttribute: NSForegroundColorAttributeName value: cell.detailTextLabel.textColor];



            //        [attributedString addAttribute: NSFontAttributeName value: _descriptionLabel.font];


            cell.detailTextLabel.attributedText = mutableString;
        }

    }

    return;

    if (description) {

        NSAttributedString *attrString = nil;
        attrString = [[NSAttributedString alloc] initWithHTMLData: data
                options: @{
                        DTDefaultFontFamily : cell.detailTextLabel.font.fontName,
                        DTDefaultTextColor : [UIColor redColor]
                }
                documentAttributes: NULL];

        if (attrString) {
            //                    NSMutableAttributedString *mutableString = [attrString mutableCopy];
            //                [mutableString addAttribute: NSForegroundColorAttributeName value: cell.detailTextLabel.textColor];

            cell.detailTextLabel.attributedText = attrString;

        }
    }

    return;

    if ([cell isKindOfClass: [TFAttributedTableViewCell class]]) {
        TFAttributedTableViewCell *attributedTableViewCell = (TFAttributedTableViewCell *) cell;


        //

        if (description) {
            NSData *data = [description dataUsingEncoding: NSUTF8StringEncoding];

            NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData: data
                    options: @{
                            DTDefaultFontFamily : cell.detailTextLabel.font.fontName,
                            DTDefaultTextColor : [UIColor redColor]
                    }
                    documentAttributes: NULL];
            attributedTableViewCell.attributedLabel.attributedString = attrString;
        }
    } else {

        //                description = [description stringByReplacingHTMLEntities];
        NSData *data = [description dataUsingEncoding: NSUTF8StringEncoding];

        NSAttributedString *attrString;
        attrString = [[NSAttributedString alloc] initWithHTMLData: data
                options: @{
                        DTDefaultFontFamily : cell.detailTextLabel.font.fontName,
                        DTDefaultTextColor : [UIColor redColor]
                }
                documentAttributes: NULL];

        if (attrString) {
            //                    NSMutableAttributedString *mutableString = [attrString mutableCopy];
            //                [mutableString addAttribute: NSForegroundColorAttributeName value: cell.detailTextLabel.textColor];

            cell.detailTextLabel.attributedText = attrString;

        }

    }

    //
    //            //            description = [description string]
    //
    //            NSLog(@"description = %@", description);
    //


    //
    //            NSLog(@"description.numberOfParagraphs = %u", description.numberOfParagraphs);
    //
    //            attrString = [[NSAttributedString alloc] initWithString: description];
    //
    //            if (attrString) {
    //                NSMutableAttributedString *mutableString = [attrString mutableCopy];
    //                //                [mutableString addAttribute: NSForegroundColorAttributeName value: cell.detailTextLabel.textColor];
    //
    //                cell.detailTextLabel.attributedText = mutableString;
    //
    //            }


    //
    //
    //            [self bk_performBlockInBackground: ^(id obj) {
    //                NSLog(@"description = %@", description);
    //
    //                if (description != nil) {
    //                    NSAttributedString *attributedString = [NSAttributedString attributedStringFromHTML: description boldFont: [UIFont boldSystemFontOfSize: 12.0]];
    //
    //                    if (attributedString) {
    //                        NSMutableAttributedString *mutableString = [attributedString mutableCopy];
    //                        [mutableString addAttribute: NSForegroundColorAttributeName value: cell.detailTextLabel.textColor];
    //
    //                        NSLog(@"mutableString = %@", mutableString);
    //
    //
    //                        //        [attributedString addAttribute: NSFontAttributeName value: _descriptionLabel.font];
    //
    //
    //                        cell.detailTextLabel.attributedText = mutableString;
    //                    }
    //
    //                }
    //
    //            } afterDelay: 0.0];

}

- (NSString *) styledHTMLwithHTML: (NSString *) HTML {
    NSString *style = @"<meta charset=\"UTF-8\"><style> body { font-family: 'HelveticaNeue'; font-size: 20px; } b {font-family: 'MarkerFelt-Wide'; }</style>";

    return [NSString stringWithFormat: @"%@%@", style, HTML];
}

- (NSAttributedString *) attributedStringWithHTML: (NSString *) HTML {
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
    return [[NSAttributedString alloc] initWithData: [HTML dataUsingEncoding: NSUTF8StringEncoding] options: options documentAttributes: NULL error: NULL];
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_rows count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    TFTableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: _tableViewController.cellIdentifier forIndexPath: indexPath];
    return ret;
}



#pragma mark - Notify



- (void) _notifyRemovedPin: (TFPhoto *) image {
    if (_delegate && [_delegate respondsToSelector: @selector(imageDrawerViewController:removedPin:)]) {
        [_delegate imageDrawerViewController: self removedPin: image];
    }
}

- (void) _notifyAddedPin: (TFPhoto *) image {
    if (_delegate && [_delegate respondsToSelector: @selector(imageDrawerViewController:addedPin:)]) {
        [_delegate imageDrawerViewController: self addedPin: image];
    }
}

@end