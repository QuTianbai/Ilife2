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

@interface MSFInventoryViewModel ()

@property (nonatomic, weak, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readwrite) NSArray *viewModels;

@end

@implementation MSFInventoryViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_formsViewModel = formsViewModel;
	
	RAC(self, model) = [RACObserve(self, formsViewModel.model.applyNo) map:^id(id value) {
		return [[MSFInventory alloc] initWithDictionary:@{
			@"objectID": formsViewModel.model.loanId ?: @"",
			@"applyNo": formsViewModel.model.applyNo ?: @"",
			@"attachments": @[],
		} error:nil];
	}];
	
	RAC(self, product) = [RACObserve(self, formsViewModel.model.productId) map:^id(id value) {
		return [[MSFProduct alloc] initWithDictionary:@{
			@"productId": formsViewModel.model.productId ?: @"",
		} error:nil];
	}];
	
	RAC(self, credit) = [RACObserve(self, formsViewModel.model.applyNo) map:^id(id value) {
		return [[MSFApplicationResponse alloc] initWithDictionary:@{
			@"applyID": formsViewModel.model.applyNo ?: @"",
			@"applyNo": formsViewModel.model.loanId ?: @"",
			@"personId": formsViewModel.model.personId ?: @"",
		} error:nil];
	}];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[[[self.formsViewModel.services httpClient]
			fetchElementsWithProduct:self.product]
			map:^id(MSFElement *element) {
				return [[MSFElementViewModel alloc] initWithElement:element services:self.formsViewModel.services];
			}]
			collect]
			subscribeNext:^(id x) {
				self.viewModels = x;
				[[[self.formsViewModel.services httpClient] fetchAttachmentsWithCredit:self.credit] subscribeNext:^(id x) {
					[self.viewModels enumerateObjectsUsingBlock:^(MSFElementViewModel *obj, NSUInteger idx, BOOL *stop) {
						[obj addAttachment:x];
					}];
				}];
			}];
	}];
	
	_executeUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.updateSignal;
	}];
	
	RAC(self, requiredViewModels) = [RACObserve(self, viewModels) map:^id(NSArray *viewModels) {
		return [[viewModels.rac_sequence filter:^BOOL(MSFElementViewModel *value) {
			return value.isRequired;
		}] array];
	}];
	RAC(self, optionalViewModels) = [RACObserve(self, viewModels) map:^id(NSArray *viewModels) {
		return [[viewModels.rac_sequence filter:^BOOL(MSFElementViewModel *value) {
			return !value.isRequired;
		}] array];
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)updateSignal {
	NSArray *attachemnts = [[self.viewModels.rac_sequence
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
	self.model.attachments = attachemnts;
	return [[self.formsViewModel.services.httpClient updateInventory:self.model]
		zipWith:[self.formsViewModel submitSignalWithPage:5]];
}

@end
