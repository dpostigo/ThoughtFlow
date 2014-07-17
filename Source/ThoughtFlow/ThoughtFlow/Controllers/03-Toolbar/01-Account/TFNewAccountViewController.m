//
// Created by Dani Postigo on 7/16/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIViewController+DPKit.h>
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import <PREBorderView/UIView+PREBorderView.h>
#import "TFNewAccountViewController.h"
#import "TFTranslucentView.h"
#import "TFBarButtonItem.h"
#import "UIControl+BlocksKit.h"
#import "TFTableViewCell.h"
#import "APIModel.h"
#import "APIUser.h"
#import "NSString+CJStringValidator.h"
#import "UIView+DPKit.h"
#import "TFNavigationBar.h"
#import "UIColor+TFApp.h"
#import "TWRBorderedView.h"


@interface TFNewAccountViewController ()

@property(nonatomic, strong) NSArray *rows;
@property(nonatomic, strong) UITextField *currentTextField;
@property(nonatomic, strong) TFTableViewController *tableViewController;
@property(nonatomic, strong) UINavigationController *viewNavigationController;
@end


static NSString *const TFAccountCellIdentifier = @"TFAccountCell";


static NSString *const TFAccountUsernameString = @"Username";
static NSString *const TFAccountEmailString = @"Email";
static NSString *const TFAccountPasswordString = @"Password";
static NSString *const TFAccountBlankString = @"Blank";
static NSString *const TFAccountSignOutString = @"Sign Out";


@implementation TFNewAccountViewController

- (id) initWithNibName: (NSString *) nibNameOrNil bundle: (NSBundle *) nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    if (self) {

        _rows = @[
                @{
                        @"title" : TFAccountUsernameString,
                        @"subtitle" : @"."
                },
                @{
                        @"title" : TFAccountEmailString,
                        @"subtitle" : @""
                },
                @{
                        @"title" : TFAccountPasswordString,
                        @"subtitle" : @""
                },
                @{
                        @"title" : TFAccountBlankString,
                        @"subtitle" : @""
                },
                @{
                        @"title" : TFAccountSignOutString,
                        @"subtitle" : @""
                }];

    }

    return self;
}



#pragma mark - View lifecycle

- (void) loadView {
    self.view = [[TFTranslucentView alloc] init];

    UIViewController *container = [[UIViewController alloc] init];

    _tableViewController = [[TFTableViewController alloc] init];
    _tableViewController.cellIdentifier = TFAccountCellIdentifier;
    _tableViewController.delegate = self;
    _tableViewController.tableView.estimatedRowHeight = _rowHeight - 0.5;
    [container embedFullscreenController: _tableViewController withInsets: UIEdgeInsetsMake(0, 0, 0, 0)];

    _viewNavigationController = [[UINavigationController alloc] initWithRootViewController: container];
    if (ALT_STYLING) {
        TFNavigationBar *navigationBar = [[TFNavigationBar alloc] init];
        navigationBar.customHeight = _navigationBarHeight - 20.5;
        [_viewNavigationController setValue: navigationBar forKeyPath: @"navigationBar"];
    }

    _viewNavigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self embedFullscreenController: _viewNavigationController];

    [self _setupNavItems];
}


- (void) _setupNavItems {

    TFBarButtonItem *rightItem = [[TFBarButtonItem alloc] initWithButton: [TFBarButtonItem closeButton]];
    [rightItem.button bk_addEventHandler: ^(id sender) {
        [self _notifyDrawerControllerShouldDismiss];
    } forControlEvents: UIControlEventTouchUpInside];

    _viewNavigationController.visibleViewController.navigationItem.rightBarButtonItem = rightItem;
    _viewNavigationController.visibleViewController.navigationItem.leftBarButtonItem = [[TFBarButtonItem alloc] initWithTitle: @"YOUR ACCOUNT"];
}



#pragma mark - Delegates




#pragma mark - UITextFieldDelegate
#pragma mark - TFNewTextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField {
    _currentTextField = textField;
}


- (void) textFieldDidSave: (TFNewTextField *) textField {

    TFTableViewCell *cell = (TFTableViewCell *) textField.superview.superview.superview;


    NSIndexPath *indexPath = [_tableViewController.tableView indexPathForCell: cell];

    NSLog(@"indexPath = %@", indexPath);
    NSDictionary *dictionary = [_rows objectAtIndex: indexPath.row];


    NSString *title = [dictionary objectForKey: @"title"];

    NSLog(@"title = %@", title);

    void (^failureBlock)(NSString *message) = ^(NSString *message) {
        [UIAlertView showWithTitle: @"Oops"
                message: message
                cancelButtonTitle: @"OK"
                otherButtonTitles: nil
                tapBlock: nil];
    };

    if ([title isEqualToString: TFAccountUsernameString]) {
        textField.editable = NO;
        textField.image = [UIImage imageNamed: @"user-icon"];
        textField.text = [APIModel sharedModel].currentUser.username;

    } else if ([title isEqualToString: TFAccountEmailString]) {

        NSString *email = textField.text;

        if ([email isEmail]) {
            [[APIModel sharedModel] updateCurrentUserWithEmail: email
                    success: nil
                    failure: failureBlock];

        } else {
            [UIAlertView showWithTitle: @"Oops"
                    message: @"Please enter a valid email."
                    cancelButtonTitle: @"OK"
                    otherButtonTitles: nil
                    tapBlock: nil];
        }

    } else if ([title isEqualToString: TFAccountPasswordString]) {
        [[APIModel sharedModel] updateCurrentUserWithPassword: textField.text
                success: nil
                failure: failureBlock];

    }
}

#pragma mark - TFTableViewControllerDelegate

- (void) configureCell: (UITableViewCell *) tableCell atIndexPath: (NSIndexPath *) indexPath {

    NSDictionary *dictionary = [_rows objectAtIndex: indexPath.row];
    NSString *title = [dictionary objectForKey: @"title"];

    TFTableViewCell *cell = (TFTableViewCell *) tableCell;
    TFNewTextField *textField = (TFNewTextField *) cell.textField;

    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.imageInsets = UIEdgeInsetsMake(0, 8, 0, 15);
    [textField setTextColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    [textField setTextColor: [UIColor whiteColor] forState: UIControlStateSelected];

    if ([title isEqualToString: TFAccountUsernameString]) {
        textField.editable = NO;
        textField.image = [UIImage imageNamed: @"user-icon"];
        textField.text = [APIModel sharedModel].currentUser.username;

    } else if ([title isEqualToString: TFAccountEmailString]) {
        textField.image = [UIImage imageNamed: @"email-icon"];
        textField.text = [APIModel sharedModel].currentUser.email;

    } else if ([title isEqualToString: TFAccountPasswordString]) {
        textField.image = [UIImage imageNamed: @"password-icon"];
        textField.text = [APIModel sharedModel].currentUser.password;

    } else if ([title isEqualToString: TFAccountBlankString]) {
        //        cell.contentView.hidden = YES;

    } else if ([title isEqualToString: TFAccountSignOutString]) {
        [self _setupSignOutButton: cell.button];

    }

    if (ALT_STYLING) {
        TWRBorderedView *borderedView = [[TWRBorderedView alloc] initWithFrame: cell.contentView.bounds
                borderWidth: 0.5
                color: [UIColor tfToolbarBorderColor]
                andMask: TWRBorderMaskBottom];
        borderedView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = borderedView;
    }

}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return _rowHeight;
}


- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [_rows count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    NSDictionary *dictionary = [_rows objectAtIndex: indexPath.row];
    NSString *title = [dictionary objectForKey: @"title"];

    TFTableViewCell *ret;

    if ([title isEqualToString: TFAccountSignOutString]) {
        ret = [tableView dequeueReusableCellWithIdentifier: TFButtonTableViewCellIdentifier forIndexPath: indexPath];

    } else if ([title isEqualToString: TFAccountBlankString]) {
        ret = [tableView dequeueReusableCellWithIdentifier: TFTableViewBlankCellIdentifier forIndexPath: indexPath];

    } else {
        ret = [tableView dequeueReusableCellWithIdentifier: _tableViewController.cellIdentifier forIndexPath: indexPath];
    }

    return ret;
}


- (void) _setupSignOutButton: (UIButton *) button {
    CGFloat padding = 10;
    UIImage *image = [button imageForState: UIControlStateNormal];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString: @"SIGN OUT" attributes: [TFBarButtonItem defaultAttributes]];

    CGSize size = string.size;
    [button setAttributedTitle: string forState: UIControlStateNormal];
    [button sizeToFit];
    [button setTitleEdgeInsets: UIEdgeInsetsMake(0, -image.size.width, 0, 0)];
    [button setImageEdgeInsets: UIEdgeInsetsMake(0, (size.width + padding), 0, 0)];

    [button bk_addEventHandler: ^(id sender) {
        [UIAlertView showWithTitle: @"Sign Out"
                message: @"Are you sure you'd like to sign out?"
                cancelButtonTitle: @"No" otherButtonTitles: @[@"Yes"]
                tapBlock: ^(UIAlertView *alertView, NSInteger buttonIndex) {
                    if (buttonIndex != alertView.cancelButtonIndex) {
                        [self _notifyClickedSignOutButton: button];
                    }
                }];
    } forControlEvents: UIControlEventTouchUpInside];
}


#pragma mark - Notify

- (void) _notifyClickedSignOutButton: (UIButton *) button {
    if (_delegate && [_delegate respondsToSelector: @selector(accountViewController:clickedSignOutButton:)]) {
        [_delegate accountViewController: self clickedSignOutButton: button];
    }
}
@end