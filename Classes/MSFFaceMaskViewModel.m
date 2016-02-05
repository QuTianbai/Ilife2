//
//  MSFFaceMask.m
//  Finance
//
//  Created by xbm on 15/12/28.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFFaceMaskViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <NSString-Hashes/NSString+Hashes.h>
#import "UIImage+Resize.h"
#import "MSFAttachment.h"
#import "MSFClient+Elements.h"
#import "MSFElement.h"
#import "MSFElement+Private.h"
#import "MSFApplyCashViewModel.h"
#import "MSFClient+Attachment.h"
#import "MSFSocialInsuranceCashViewModel.h"

@interface MSFFaceMaskViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices> services;
@property (nonatomic, strong) MSFElement *model;

@end

@implementation MSFFaceMaskViewModel

- (instancetype)initWithApplicationViewModel:(id<MSFApplicationViewModel>)applicaitonViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_applicationViewModel = applicaitonViewModel;
	_services = applicaitonViewModel.services;
	@weakify(self)
	_takeFaceMaskPhotoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		
		return [self takePhotoSignalWith:[UIImage imageNamed:@"faceMask_bg"]];
	}];
	
	[[self.services.httpClient fetchFaceMaskElements]
	subscribeNext:^(id x) {
		if ([self.applicationViewModel isKindOfClass:MSFApplyCashViewModel.class]) {
			MSFApplyCashViewModel *viewModel = (MSFApplyCashViewModel *)self.applicationViewModel;
			self.model.applicationNo = viewModel.appNO;
		} else if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
			self.model.applicationNo = self.applicationViewModel.applicationNo;
		}
		
		self.model = x;
		
	}];
	
	[self.takeFaceMaskPhotoCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(MSFAttachment *attachment) {
			self.attachment = attachment;
		}];
	}];
	
	_updateImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self fetchFacePhotoSignal];
	}];
	
	return self;
}

#pragma mark - Private

- (RACSignal *)getFaceMaskPhotoSignal {
	return [self.services.httpClient fetchFaceMaskElements];
}

- (RACSignal *)takePhotoSignalWith:(id)img {
	return [[self.services msf_takePictureSignal:YES] map:^id(UIImage *image) {
		NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
		NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
		CGSize size = image.size;
		if (size.width > 800 || size.height > 800) {
			CGFloat scale = size.width > size.height ? 800.0 / size.width : 800.0 / size.height;
			size = size.width > size.height ? CGSizeMake(800, size.height * scale) : CGSizeMake(size.width * scale, 800);
		}
		UIImage *x = [image resizedImage:size interpolationQuality:kCGInterpolationDefault];
		[[NSFileManager defaultManager] createFileAtPath:path contents:UIImageJPEGRepresentation(x, .7) attributes:nil];
		NSURL *fileURL = [NSURL fileURLWithPath:path];
		self.imgFilePath = path;
		return [[MSFAttachment alloc] initWithFileURL:fileURL
																		applicationNo:self.model.applicationNo?:@""
																			elementType:self.model.type
																			elementName:self.model.name];
	}];
}

- (RACSignal *)fetchFacePhotoSignal {
	 return [[self.services.httpClient uploadAttachment:self.attachment] doNext:^(id x) {
		[self.attachment mergeAttachment:x];
	}];
}

@end
