//
// Created by Dani Postigo on 5/16/14.
//

#import "DPCollectionViewCell.h"


@implementation DPCollectionViewCell

@synthesize imageView;

@synthesize selectionState;
@synthesize deselectionState;
@synthesize textLabel;

- (void)awakeFromNib {
    [super awakeFromNib];

}


- (void)prepareForReuse {
    [super prepareForReuse];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self updateSelectionState];
    }

    return self;
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateSelectionState];
}

//
//- (void)setSelectionState:(void (^)(DPCollectionViewCell *aCell))selectionState1 {
//    selectionState = [selectionState1 mutableCopy];
//}
//
//- (void)setDeselectionState:(void (^)(DPCollectionViewCell *aCell))deselectionState1 {
//    deselectionState = [deselectionState1 mutableCopy];
//    [self updateSelectionState];
//}

- (void)updateSelectionState {
    if (self.selected) {
        if (selectionState) {
            selectionState(self);
        }
    } else {
        if (deselectionState) {
            deselectionState(self);
        }
    }
}


@end