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
#import "MSFProduct.h"
#import "MSFElement.h"
#import "MSFElementViewModel.h"
#import "MSFApplicationResponse.h"
#import "MSFAttachmentViewModel.h"
#import "MSFAttachment.h"
#import "MSFApplicationForms.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFClient+Inventory.h"

@interface MSFInventoryViewModel ()

@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@property (nonatomic, strong) NSString *applicaitonNo;
@property (nonatomic, strong) NSString *productID;

@end

@implementation MSFInventoryViewModel

#pragma mark - Lifecycle

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicaitonViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_applicationViewModel = applicaitonViewModel;
	_services = applicaitonViewModel.services;
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
			return [[[self.services.httpClient
				fetchElementsApplicationNo:self.formsViewModel.appNO amount:self.formsViewModel.appLmt terms:self.formsViewModel.loanTerm]
				map:^id(id value) {
					return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
				}]
				collect];
		} else if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
			return [[[self.services.httpClient
				fetchElementsApplicationNo:self.insuranceViewModel.applicaitonNo productID:self.insuranceViewModel.productID]
				map:^id(id value) {
					return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
				}]
				collect];
		}
		return RACSignal.empty;
	}];
	
	if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
		_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			return [self.formsViewModel submitSignalWithStatus:@"1"];
		}];
	} else if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
		_executeSubmitCommand = self.insuranceViewModel.executeSubmitCommand;
	}
	
	[self initialize];
	
	return self;
}

- (instancetype)initWithInsuranceViewModel:(MSFSocialInsuranceCashViewModel *)insuranceViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_insuranceViewModel = insuranceViewModel;
	_services = self.insuranceViewModel.services;
	
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		return [[[self.services.httpClient
			fetchElementsApplicationNo:self.insuranceViewModel.applicaitonNo productID:self.insuranceViewModel.productID]
			map:^id(id value) {
				return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
			}]
			collect];
	}];
	_executeSubmitCommand = self.insuranceViewModel.executeSubmitCommand;
	
	[self initialize];
	
	return self;
}

- (instancetype)initWithCashViewModel:(MSFApplyCashVIewModel *)cashViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_formsViewModel = cashViewModel;
	_services = self.formsViewModel.services;
	@weakify(self)
	RAC(self, viewModels) = [self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		return [[[self.services.httpClient
			fetchElementsApplicationNo:self.formsViewModel.appNO amount:self.formsViewModel.appLmt terms:self.formsViewModel.loanTerm]
			map:^id(id value) {
				return [[MSFElementViewModel alloc] initWithElement:value services:self.services];
			}]
			collect];
	}];
	
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.formsViewModel submitSignalWithStatus:@"1"];
	}];
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
		return [[[self.services.httpClient
			fetchSupplementalElementsApplicationNo:self.applicaitonNo productID:self.productID]
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
}

- (instancetype)initWithFormsViewModel:(MSFApplyCashVIewModel *)formsViewModel {
	return [self initWithCashViewModel:formsViewModel];
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
		return [RACSignal return:attachments];
	}];
}

@end
