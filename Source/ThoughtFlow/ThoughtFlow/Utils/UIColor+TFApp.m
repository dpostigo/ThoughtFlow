//
// Created by Dani Postigo on 4/30/14.
// Copyright (c) 2014 Daniela Postigo. All rights reserved.
//

#import <DPKit-Utils/UIColor+DPKit.h>
#import "UIColor+TFApp.h"

@implementation UIColor (TFApp)

+ (UIColor *) tfBackgroundColor {
    return [UIColor colorWithString: @"29292E"];
}

+ (UIColor *) tfInputTextColor {
    return [UIColor colorWithString: @"AAABB2"];
}

+ (UIColor *) tfCellTextColor {
    return [UIColor colorWithString: @"8A8B94"];
}

+ (UIColor *) tfGreenColor {
    return [UIColor colorWithString: @"90BF86"];
}

+ (UIColor *) tfRedColor {
    return [UIColor colorWithString: @"F26F61"];
}


+ (UIColor *) tfPurpleColor {
    return [UIColor colorWithString: @"3A3A66"];
}

+ (UIColor *) tfOffWhiteColor {
    return [UIColor colorWithString: @"E8E9EF"];
}

+ (UIColor *) tfToolbarBorderColor {
    return [UIColor colorWithString: @"54555D"];
}
@end