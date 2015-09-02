//
//  MSFPhotosUploadHeaderView.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFPhotosUploadHeaderView.h"
#import "MSFElementViewModel.h"

@interface MSFPhotosUploadHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (nonatomic, strong) MSFElementViewModel *viewModel;

@end

@implementation MSFPhotosUploadHeaderView

- (void)bindModel:(MSFElementViewModel *)viewModel {
	_viewModel = viewModel;
	
}

@end
