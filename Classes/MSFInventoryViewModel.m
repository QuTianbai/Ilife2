//
// MSFInventoryViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventoryViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFClient+Elements.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFElement.h"
#import "MSFElementViewModel.h"
#import "MSFApplicationResponse.h"
#import "MSFAttachmentViewModel.h"
#import "MSFAttachment.h"
#import "MSFApplicationForms.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFClient+Inventory.h"
#import "MSFLoanType.h"
#import "NSFileManager+Temporary.h"

@interface MSFInventoryViewModel ()

@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@property (nonatomic, strong) NSString *applicaitonNo;
@property (nonatomic, strong) NSString *productID;

@property (nonatomic, strong) MSFAttachment *attachment;

@end

@implementation MSFInventoryViewModel

#pragma mark - Lifecycle

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicaitonViewModel AndAttachment:(MSFAttachment *)attachment {
  self = [super init];
  if (!self) {
    return nil;
  }
	_applicationViewModel = applicaitonViewModel;
	_services = applicaitonViewModel.services;
	_attachment = attachment;
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
			MSFApplyCashVIewModel *viewModel = (MSFApplyCashVIewModel *)self.applicationViewModel;
			return [[[[self.services.httpClient
				fetchElementsApplicationNo:viewModel.appNO amount:viewModel.appLmt terms:viewModel.loanTerm productGroupID:self.applicationViewModel.loanType.typeID]
				catch:^RACSignal *(NSError *error) {
					return RACSignal.empty;
				}]
				map:^id(id value) {
					return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
				}]
				collect];
		} else if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
			return [[[[self.services.httpClient
				fetchElementsApplicationNo:self.applicationViewModel.applicationNo productID:self.applicationViewModel.loanType.typeID]
				catch:^RACSignal *(NSError *error) {
					return RACSignal.empty;
				}]
				map:^id(id value) {
					return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
				}]
				collect];
		}
		return RACSignal.empty;
	}];
	
	if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
		_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			return [(MSFApplyCashVIewModel *)self.applicationViewModel submitSignalWithStatus:@"1"];
		}];
	} else if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
		_executeSubmitCommand = ((MSFSocialInsuranceCashViewModel *)self.applicationViewModel).executeSubmitCommand;
	}
	//TODO: 增加商品贷提交申请
	
	[self initialize];
	
	return self;
}

- (instancetype)initWithApplicaitonNo:(NSString *)applicaitonNo productID:(NSString *)productID services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_applicaitonNo = applicaitonNo;
	_productID = productID;
	_services = services;
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		return [[[[self.services.httpClient
			fetchSupplementalElementsApplicationNo:self.applicaitonNo productID:self.productID]
			catch:^RACSignal *(NSError *error) {
				return RACSignal.empty;
			}]
			map:^id(id value) {
				return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
			}]
			collect];
	}];
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self.updateSignal flattenMap:^RACStream *(id value) {
			return [self.services.httpClient submitInventoryWithApplicaitonNo:self.applicaitonNo accessories:value];
		}];
	}];
	[self initialize];
	
  return self;
}

- (void)initialize {
	RAC(self, requiredViewModels) = [RACObserve(self, viewModels) map:^id(NSArray *viewModels) {
		return [[[viewModels.rac_sequence filter:^BOOL(MSFElementViewModel *value) {
			return value.isRequired;
		}] array] sortedArrayUsingComparator:^NSComparisonResult(MSFElementViewModel *obj1, MSFElementViewModel *obj2) {
			if (obj1.element.sort > obj2.element.sort) return NSOrderedDescending;
			if (obj1.element.sort < obj1.element.sort) return NSOrderedAscending;
			return NSOrderedSame;
		}];
	}];
	RAC(self, optionalViewModels) = [RACObserve(self, viewModels) map:^id(NSArray *viewModels) {
		return [[[viewModels.rac_sequence filter:^BOOL(MSFElementViewModel *value) {
			return !value.isRequired;
		}] array] sortedArrayUsingComparator:^NSComparisonResult(MSFElementViewModel *obj1, MSFElementViewModel *obj2) {
			if (obj1.element.sort > obj2.element.sort) return NSOrderedDescending;
			if (obj1.element.sort < obj1.element.sort) return NSOrderedAscending;
			return NSOrderedSame;
		}];
	}];
	
	@weakify(self)
	_executeUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return self.updateSignal;
	}];
	
	[self.executeSubmitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[signal subscribeNext:^(id x) {
			[NSFileManager.defaultManager cleanupTemporaryFiles];
		}];
	}];
}

#pragma mark - Custom Accessors

- (RACSignal *)updateValidSignal {
	return [RACSignal defer:^RACSignal *{
		NSArray *attachments = [[self.viewModels.rac_sequence
			flattenMap:^RACStream *(MSFElementViewModel *elemntViewModel) {
				return [[elemntViewModel.viewModels.rac_sequence
					filter:^BOOL(MSFAttachmentViewModel *attachmentViewModel) {
						return attachmentViewModel.isUploaded;
					}]
					map:^id(MSFAttachmentViewModel *value) {
						return value.attachment;
					}];
				}]
			array];
		
		__block NSError *error = nil;
		[self.requiredViewModels enumerateObjectsUsingBlock:^(MSFElementViewModel *obj, NSUInteger idx, BOOL *stop) {
			if (!obj.isCompleted) {
				error = [NSError errorWithDomain:@"MSFInventoryViewModel" code:1 userInfo:@{
					NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"请添加“%@”", obj.name]
				}];
				*stop = YES;
			}
		}];
		if (error) return [RACSignal error:error];
		return [RACSignal return:attachments];
	}];
}

#pragma mark - Private

- (RACSignal *)updateSignal {
	return [self.updateValidSignal flattenMap:^RACStream *(NSArray *objects) {
		NSMutableArray *attachments = [[NSMutableArray alloc] init];
		[objects enumerateObjectsUsingBlock:^(MSFAttachment *obj, NSUInteger idx, BOOL *_Nonnull stop) {
			[attachments addObject:@{
				@"accessoryType": obj.type,
				@"fileId": obj.fileID,
				@"name": obj.name,
			}];
		}];
		[attachments addObject:@{
														@"accessoryType": self.attachment.type,
														@"fileId": self.attachment.fileID,
														@"name": self.attachment.name,
														}];
		return [RACSignal return:attachments];
	}];
}

@end
