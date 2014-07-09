//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import "TFUserButton.h"
#import "UIImage+DPKit.h"
#import "UIFont+ThoughtFlow.h"


@implementation TFUserButton

- (void) awakeFromNib {
    [super awakeFromNib];

    self.layer.cornerRadius = 2;

    [self setTitleColor: [UIColor lightGrayColor] forState: UIControlStateDisabled];
//    [self setBackgroundImage: [UIImage imageWithColor: [UIColor colorWithWhite: 0.8 alpha: 0.5]] forState: UIControlStateDisabled];
}

- (void) setTitle: (NSString *) title forState: (UIControlState) state {
    [super setTitle: title forState: state];

    CGFloat pointSize = 12.0;
    CGFloat kerningSize = 60 * (pointSize / 1000);
    NSDictionary *attributes = @{
            NSFontAttributeName : [UIFont gothamLight: pointSize],
            NSKernAttributeName : @(kerningSize)
    };

    NSAttributedString *string = [[NSAttributedString alloc] initWithString: title attributes: attributes];
    [self setAttributedTitle: string forState: state];

}

- (void) setEnabled: (BOOL) enabled {
    [super setEnabled: enabled];
    self.alpha = self.enabled ? 1 : 0.5;
}


@end