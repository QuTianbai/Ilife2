//
//  MSFPhotosUploadCell.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFPhotosUploadCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFAttachmentViewModel.h"
#import "MSFAttachment.h"

@interface MSFPhotosUploadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;

@property (nonatomic, strong) MSFAttachmentViewModel *viewModel;

@end

@implementation MSFPhotosUploadCell

- (void)awakeFromNib {
	_uploadImageView.layer.cornerRadius = 5;
}

- (void)bindViewModel:(MSFAttachmentViewModel *)viewModel {
	_viewModel = viewModel;
	[_uploadImageView setImageWithURL:viewModel.thumbURL];
	_deleteButton.hidden = !viewModel.removeEnabled;
	_deleteButton.rac_command = viewModel.removeCommand;
}

@end
