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

@property (nonatomic, strong, readwrite) RACSubject *updatedContentSignal;
@property (nonatomic, strong, readwrite) MSFInventory *model;
@property (nonatomic, strong, readwrite) NSArray *elements;
@property (nonatomic, strong) MSFProduct *product;
@property (nonatomic, strong) MSFApplicationResponse *response;

@end

@implementation MSFInventoryViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = formsViewModel.services;
	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFInventoryViewModel `-updatedContentSignal`"];
	
	self.product = [[MSFProduct alloc] initWithDictionary:@{
		@"productId": formsViewModel.model.productId ?: @"",
	} error:nil];
	
	self.model = [[MSFInventory alloc] initWithDictionary:@{
		@"objectID": formsViewModel.model.loanId ?: @"",
		@"applyNo": formsViewModel.model.applyNo ?: @"",
		@"attachments": @[],
	} error:nil];
	
	self.response = [[MSFApplicationResponse alloc] initWithDictionary:@{
		@"applyID": formsViewModel.model.applyNo ?: @"",
		@"applyNo": formsViewModel.model.loanId ?: @"",
		@"personId": formsViewModel.model.personId ?: @"",
	} error:nil];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[self.services.httpClient fetchInventoryWithApplicaitonResponse:self.response]
			collect]
			subscribeNext:^(id x) {
				self.model.attachments = x;
			}];
	}];
	
	_executeUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.updateSignal;
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)updateSignal {
	return [self.services.httpClient updateInventory:self.model];
}

@end
