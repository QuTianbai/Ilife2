//
//  MSFApplyCollectionViewCell.h
//  Finance
//
//  Created by 赵勇 on 7/28/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

/**
 *	申请状态下的Cell
 */
@interface MSFApplyCollectionViewCell : UICollectionViewCell<MSFReactiveView>

- (void)bindViewModel:(id)viewModel;

@end
