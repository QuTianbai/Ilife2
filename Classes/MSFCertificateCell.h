//
//  MSFCertificateCell.h
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFCertificateCell : UICollectionViewCell

- (void)drawSeparatorAtIndex:(NSIndexPath *)indexPath total:(NSInteger)total;
- (void)bindViewModel:(id)viewModel;

@end
