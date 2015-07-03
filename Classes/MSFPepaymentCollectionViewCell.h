//
// MSFPepaymentCollectionViewCell.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

/**
 *  还款中Cell
 */
@interface MSFPepaymentCollectionViewCell : UICollectionViewCell <MSFReactiveView>

- (void)bindViewModel:(id)viewModel;

@end
