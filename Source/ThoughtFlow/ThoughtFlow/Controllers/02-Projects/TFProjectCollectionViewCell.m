//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFProjectCollectionViewCell.h"
#import "Project.h"
#import "UIColor+TFApp.h"
#import "UIView+TFFonts.h"
#import "UIFont+ThoughtFlow.h"
#import "TFTranslucentView.h"
#import "UIView+DPKit.h"


@implementation TFProjectCollectionViewCell

@synthesize firstWordField;
@synthesize wordsField;
@synthesize connectionsField;

@synthesize project;

- (id) initWithFrame: (CGRect) frame {
    self = [super initWithFrame: frame];
    if (self) {

    }

    return self;
}


- (void) awakeFromNib {
    [super awakeFromNib];
    [self _setup];
}



#pragma mark - Setup
- (void) _setup {

    [self convertFonts];

    _bg = [[TFTranslucentView alloc] initWithFrame: self.contentView.bounds];
    _bg.translucentAlpha = 0.8;
    [self.contentView embedView: _bg];
    [self.contentView sendSubviewToBack: _bg];

}

- (void) setProject: (Project *) project1 {
    project = project1;

    if (project) {
        firstWordField.text = project.word;
        [self _refreshConnectionsField];
        [self updateWordsField];
    }
}


#pragma mark - Refresh

- (void) _refreshConnectionsField {
    connectionsField.text = nil;
    connectionsField.attributedText = self.connectionsFieldString;
}


- (void) updateWordsField {
    if ([project.nodes count] - 1 == 0) {
        wordsField.text = @"";

    } else {
        NSArray *nodeWords = [project.nodes valueForKeyPath: @"@unionOfObjects.title"];
        wordsField.text = [NSString stringWithFormat: @"%@...", [nodeWords componentsJoinedByString: @", "]];
    }
}


- (NSAttributedString *) connectionsFieldString {
    NSMutableDictionary *attributes = [[UIFont attributesForFont: _startedField.font] mutableCopy];
    [attributes setObject: [UIColor tfCellTextColor] forKey: NSForegroundColorAttributeName];
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] init];
    [ret appendAttributedString: [[NSAttributedString alloc] initWithString: @"AND MADE " attributes: attributes]];
    [attributes setObject: [UIColor whiteColor] forKey: NSForegroundColorAttributeName];
    [ret appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%u", [project.flattenedChildren count] - 1] attributes: attributes]];
    [attributes setObject: [UIColor tfCellTextColor] forKey: NSForegroundColorAttributeName];
    [ret appendAttributedString: [[NSAttributedString alloc] initWithString: @" CONNECTIONS " attributes: attributes]];

    return ret;
}


- (NSAttributedString *) numberString {
    NSMutableDictionary *attributes = [[UIFont attributesForFont: _startedField.font] mutableCopy];
    [attributes setObject: [UIColor redColor] forKey: NSForegroundColorAttributeName];

    NSAttributedString *ret = [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"%u", [project.nodes count] - 1] attributes: attributes];
    return ret;
}

@end