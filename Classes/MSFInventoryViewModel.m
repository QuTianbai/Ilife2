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

@interface MSFInventoryViewModel ()

//@property (nonatomic, strong, readwrite) RACSubject *updatedContentSignal;
@property (nonatomic, strong, readwrite) MSFInventory *model;
@property (nonatomic, weak, readonly) MSFFormsViewModel *formsViewModel;

@end

@implementation MSFInventoryViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_formsViewModel = formsViewModel;
//	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFInventoryViewModel `-updatedContentSignal`"];
	
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
	
	RAC(self, viewModels) = [[[[self.formsViewModel.services httpClient]
		fetchElementsWithProduct:self.product]
		map:^id(MSFElement *element) {
			return [[MSFElementViewModel alloc] initWithModel:element services:self.formsViewModel.services];
		}]
		collect];
	RAC(self, attachments) = [[[self.formsViewModel.services httpClient] fetchAttachmentsWithCredit:self.credit] collect];
	
	_executeUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.updateSignal;
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)updateSignal {
	return [self.formsViewModel.services.httpClient updateInventory:self.model];
}

@end
