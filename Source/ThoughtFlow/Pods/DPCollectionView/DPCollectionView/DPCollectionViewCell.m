//
// Created by Dani Postigo on 5/16/14.
//

#import "DPCollectionViewCell.h"

@implementation DPCollectionViewCell

@synthesize imageView;

- (void) prepareForReuse {
    [super prepareForReuse];
    if (imageView) {
        imageView.image = nil;
    }
}

- (void) awakeFromNib {
    [super awakeFromNib];

}


@end