//
//  MSFPhotosUploadHeaderView.h
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFPhotosUploadHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *browserButton;
@property (weak, nonatomic) IBOutlet UIButton *foldButton;

- (void)bindModel:(id)viewModel shouldFold:(BOOL)sFold folded:(BOOL)folded;

@end
