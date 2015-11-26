//
// MSFCashHomePageViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCashHomePageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFClient+MSFCheckAllowApply.h"
#import "MSFClient+MSFProductType.h"
#import "MSFClient+MSFCirculateCash.h"
#import "MSFCirculateCashModel.h"
#import "MSFFormsViewModel.h"

@implementation MSFCashHomePageViewModel

- (instancetype)initWithFormViewModel:(MSFFormsViewModel *)formViewModel services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_formViewModel = formViewModel;
	_services = services;
	
	@weakify(self)
	_executeAllowMSCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAllow];
	}];
	
	_executeAllowMLCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeAllow];
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)executeAllow {
	return [self.services.httpClient fetchCheckAllowApply];
}

- (RACSignal *)fetchProductType {
	return [RACSignal combineLatest:@[[self.services.httpClient fetchProductType], [self.services.httpClient fetchCirculateCash]] reduce:^id(NSArray *product, MSFCirculateCashModel *loan){
		if (loan.totalLimit.doubleValue > 0) {
			return @2;
		} else {
			if ([product containsObject:@"4101"] || [product containsObject:@"4102"]) {
				return @1;
			} else {
				return @0;
			}
		}
	}];
}

@end
