//
// Created by Dani Postigo on 1/11/14.
//

#import "NSMutableAttributedString+DPKit.h"
#import "NSAttributedString+DPKit.h"

@implementation NSMutableAttributedString (DPKit)

- (void) addAttribute: (NSString *) name value: (id) value {
    [self addAttribute: name value: value range: self.range];
}
@end