//
// Created by Dani Postigo on 7/2/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIView+DPKit.h>
#import <DPKit-Utils/UIView+DPKitDebug.h>
#import <DPKit-Utils/UIViewController+DPKit.h>
#import "TFImageDrawerViewController.h"
#import "TFPhoto.h"
#import "Project.h"
#import "TFImageDrawerContentViewController.h"


@interface TFImageDrawerViewController ()

@property(nonatomic, strong) TFImageDrawerContentViewController *contentViewController;
@end

@implementation TFImageDrawerViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    TFImageDrawerViewController *ret = [[UIStoryboard storyboardWithName: @"Mindmap" bundle: nil] instantiateViewControllerWithIdentifier: @"TFImageDrawerViewController"];
    return ret;
    //    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    //    if (self) {
    //
    //    }
    //
    //    return self;
}

- (instancetype) initWithProject: (Project *) project image: (TFPhoto *) image {
    self = [super init];
    if (self) {
        _project = project;
        _image = image;
    }

    return self;
}


#pragma mark - View lifecycle


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


- (void) viewDidLoad {
    [super viewDidLoad];

    _contentViewController = [[TFImageDrawerContentViewController alloc] init];
    [self embedController: _contentViewController inView: _containerView];
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(_titleLabel.frame);

    [_pinButton setTitle: @"PIN TO MOODBOARD" forState: UIControlStateNormal];
    [_pinButton setTitle: @"REMOVE FROM MOODBOARD" forState: UIControlStateSelected];

    self.image = _image;
}

#pragma mark - Set image

- (void) setImage: (TFPhoto *) image {
    _image = image;

    if (self.isViewLoaded) {
        if (_image) {

            _titleLabel.text = [_image.title uppercaseString];

            NSLog(@"_titleLabel.text = %@", _titleLabel.text);
            _contentViewController.image = _image;

            if (_project) {
                _pinButton.selected = [_project.pinnedImages containsObject: _image];
            } else {
                NSLog(@"no project");

            }

            [self.view layoutIfNeeded];

        } else {

        }
    } else {

    }
}

#pragma mark - Remove


- (IBAction) handlePinButton: (UIButton *) button {
    button.selected = !button.selected;

    if (button.selected) {

        if (![_project.pinnedImages containsObject: _image]) {
            //            [_project.pinnedImages addObject: _image];
            [_project addPin: _image];
            [self _notifyAddedPin: _image];
        }
    } else {
        if ([_project.pinnedImages containsObject: _image]) {
            //            [_project.pinnedImages removeObject: _image];
            [_project removePin: _image];
            [self _notifyRemovedPin: _image];
        }
    }
}


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



#pragma mark - Setup

- (void) _setupView {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
}


- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender {
    [super prepareForSegue: segue sender: sender];

    //    if ([segue.identifier isEqualToString: @"ContentEmbedSegue"]) {
    //        _contentViewController = segue.destinationViewController;
    //        _contentViewController.image = _image;
    //    }
}

@end