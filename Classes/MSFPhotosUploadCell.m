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

@interface MSFPhotosUploadCell ()<UIAlertViewDelegate>

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
	
	[[[_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		takeUntil:self.rac_prepareForReuseSignal]
	 subscribeNext:^(id x) {
		 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除该图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		 [alert show];
	}];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[_viewModel.removeCommand execute:nil];
	}
}

@end
