//
// MSFInventoryViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventoryViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClient+Elements.h"
#import "MSFClient+Inventory.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFProduct.h"
#import "MSFElement.h"
#import "MSFElementViewModel.h"
#import "MSFInventory.h"
#import "MSFApplicationResponse.h"
#import "MSFAttachmentViewModel.h"
#import "MSFAttachment.h"
#import "MSFApplicationForms.h"

#import "MSFApplyCashVIewModel.h"

@interface MSFInventoryViewModel ()

@property (nonatomic, strong, readwrite) NSArray *viewModels;

@end

@implementation MSFInventoryViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFApplyCashVIewModel *)formsViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_cashViewModel = formsViewModel;
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[[[self.cashViewModel.services httpClient]
			fetchElementsWithProduct:nil amount:self.cashViewModel.appLmt term:self.cashViewModel.loanTerm]
			map:^id(MSFElement *element) {
				return [[MSFElementViewModel alloc] initWithElement:element viewModel:self.cashViewModel];
			}]
			collect]
			subscribeNext:^(id x) {
				self.viewModels = x;
			}];
	}];
	
	_executeUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.updateSignal;
	}];
	
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
	
	_executeSubmit = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.cashViewModel submitSignalWithStatus:@"1"];
	}];
	
  return self;
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
	@weakify(self)
	return [self.updateValidSignal flattenMap:^RACStream *(id value) {
		@strongify(self)
		self.model.attachments = value;
		NSMutableArray *attachments = [[NSMutableArray alloc] init];
		[self.model.attachments enumerateObjectsUsingBlock:^(MSFAttachment *obj, NSUInteger idx, BOOL *_Nonnull stop) {
			[attachments addObject:@{
				@"accessoryType": obj.type,
				@"fileId": obj.fileID
			}];
		}];
		return [RACSignal return:attachments];
	}];
}

@end
