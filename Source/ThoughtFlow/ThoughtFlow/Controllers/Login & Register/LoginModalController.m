//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "LoginModalController.h"
#import "DPTableView.h"
#import "UIView+DPKit.h"
#import "UITableView+DPTableView.h"
#import "UIView+DPConstraints.h"
#import "FieldTableViewCell.h"
#import "UIView+DPKitKeyboard.h"
#import "TFLoginOperation.h"
#import "DPTableView+DataUtils.h"
#import "TFCustomTextField.h"
#import "UIView+TFFonts.h"

@implementation LoginModalController

@synthesize table;

- (void) viewDidLoad {
    [super viewDidLoad];

    [self.view convertFonts];
    table.delegate = self;
    table.dataSource = self;
    table.populateTextLabels = YES;

    [self prepareDatasource];

    __weak UIViewController *weakSelf = self;
    table.onReload = ^(DPTableView *theTable) {

        __strong UIViewController *strongSelf = weakSelf;
        if (strongSelf) {
            CGFloat newheight = theTable.calculatedTableHeight;
            theTable.height = newheight;
            [theTable updateHeightConstraint: newheight];
            [strongSelf.view setNeedsUpdateConstraints];
        }
    };

    [table reloadData];
    table.layer.cornerRadius = 3;

}

- (void) prepareDatasource {
    [table.rows addObject: @{DPTableViewTextLabelName : @"Username or email", DPTableViewImageName : [UIImage imageNamed: @"user-icon"]}];
    [table.rows addObject: @{DPTableViewTextLabelName : @"Password", DPTableViewImageName : [UIImage imageNamed: @"password-icon"]}];
}


#pragma mark IBActions

- (IBAction) signInInstead: (id) sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction) handleLogin: (id) sender {
    TFLoginOperation *operation = [[TFLoginOperation alloc] initWithSuccess: ^{

        [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
        //        __block UIViewController *controller = self.presentingViewController;
        //        __block UINavigationController *navController = (UINavigationController *) ([controller isKindOfClass: [UINavigationController class]] ? controller : nil);
        //
        //        [controller
        //                dismissViewControllerAnimated: YES
        //                                   completion: ^{
        //                                       [self performSegueWithIdentifier: @"MenuSegue2"
        //                                                                 sender: nil];
        //                                       //
        //                                       //                                       if (navController) {
        //                                       //                                           [navController pushViewController: [self.storyboard instantiateViewControllerWithIdentifier: @"MainController"]
        //                                       //                                                                    animated: YES];
        //                                       //                                       }
        //                                   }];

    }];

    operation.failure = ^{

    };

    [_queue addOperation: operation];

}

#pragma mark TLFreeformModalProtocol
- (CGSize) freeformSizeForViewController {
    return CGSizeMake(300, 380);
}


#pragma mark UITableViewDelegate


#pragma mark UITableViewDatasource

- (NSInteger) tableView: (UITableView *) tableView numberOfRowsInSection: (NSInteger) section {
    return [table numberOfRowsInSection: section];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {
    UITableViewCell *ret = [tableView dequeueReusableCellWithIdentifier: @"TableCell"];


    NSDictionary *dictionary = [table dataForIndexPath: indexPath];
    if ([ret isKindOfClass: [FieldTableViewCell class]]) {
        FieldTableViewCell *cell = (FieldTableViewCell *) ret;
        cell.textField.delegate = self;
        cell.textField.placeholder = [table textLabelForIndexPath: indexPath];
        cell.imageView.image = [table imageForIndexPath: indexPath];
        cell.textField.rightView = nil;
    }

    return ret;
}




#pragma mark UITextFieldDelegate


- (void) textFieldDidBeginEditing: (UITextField *) textField {
    [self.view adjustViewForKeyboard: 20];

}

- (BOOL) textFieldShouldReturn: (UITextField *) textField {
    UITextField *nextTextField = [table nextTableTextField: textField];
    [textField resignFirstResponder];
    if (nextTextField) {
        [nextTextField becomeFirstResponder];
    } else {
        [self.view unadjustViewForKeyboard: 20];
    }
    return YES;
}


@end