//
// Created by Dani Postigo on 4/24/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "UITableView+DPTableView.h"
#import "UIView+DPKitChildren.h"

@implementation UITableView (DPTableView)

- (void) sizeTableToFit {

}


#pragma mark TextFields

- (NSArray *) cellTextFields {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    int numSections = [self numberOfSections];
    for (int j = 0; j < numSections; j++) {
        int numRows = [self numberOfRowsInSection: j];
        for (int k = 0; k < numRows; k++) {
            UITableViewCell *cell = [self cellForRowAtIndexPath: [NSIndexPath indexPathForRow: k
                                                                                    inSection: j]];

            NSArray *textfields = [cell childrenOfClass: [UITextField class]];
            [ret addObjectsFromArray: textfields];

        }
    }
    return ret;
}

- (UITextField *) nextTableTextField: (UITextField *) textField {
    UITextField *ret = nil;
    NSArray *textFields = self.cellTextFields;
    NSUInteger index = [textFields indexOfObject: textField];
    if (index != -1 && index < [textFields count] - 1) {
        ret = [textFields objectAtIndex: index + 1];
    }
    return ret;
}

- (void) forwardTextFieldResponder: (UITextField *) textField {
    UITextField *nextTextField = [self nextTableTextField: textField];
    [textField resignFirstResponder];
    if (nextTextField) [nextTextField becomeFirstResponder];
}

#pragma mark Table height

- (CGFloat) calculatedTableHeight {
    CGFloat ret = 0;
    int numSections = [self numberOfSections];
    for (int j = 0; j < numSections; j++) {

        ret += [self estimatedSectionHeaderHeight];
        int numRows = self.dataSource ? [self.dataSource tableView: self numberOfRowsInSection: j] : [self numberOfRowsInSection: j];

        for (int k = 0; k < numRows; k++) {
            if (self.delegate && [self.delegate respondsToSelector: @selector(tableView:heightForRowAtIndexPath:)]) {
                ret += [self.delegate tableView: self heightForRowAtIndexPath: [NSIndexPath indexPathForRow: k inSection: j]];
            } else {
                ret += [self rowHeight];
            }
        }
    }
    return ret;
}

@end