//
// Created by Dani Postigo on 5/16/14.
//

#import <Foundation/Foundation.h>


@interface DPCollectionViewCell : UICollectionViewCell {


    void (^selectionState)(DPCollectionViewCell *aCell);
    void (^deselectionState)(DPCollectionViewCell *);
}
@property(nonatomic, strong) UILabel *textLabel;
@property(weak) IBOutlet UIImageView *imageView;
@property(nonatomic, copy) void (^selectionState)(DPCollectionViewCell *aCell);
@property(nonatomic, copy) void (^deselectionState)(DPCollectionViewCell *);
- (void)updateSelectionState;
@end