//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddressViewModel.h"
#import "MSFAreas.h"
#import "NSString+Matches.h"

@interface MSFPersonalViewModel ()

@property(nonatomic,readonly) MSFAddressViewModel *addressViewModel;

@end

@implementation MSFPersonalViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel addressViewModel:(MSFAddressViewModel *)addressViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formsViewModel = viewModel;
	_addressViewModel = addressViewModel;
	_model = viewModel.model;
	
	RAC(self,address) = RACObserve(self.addressViewModel, address);
	RAC(self.model,currentProvince) = RACObserve(self.addressViewModel, provinceName);
	RAC(self.model,currentProvinceCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self.model,currentCity) = RACObserve(self.addressViewModel, cityName);
	RAC(self.model,currentCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self.model,currentCountry) = RACObserve(self.addressViewModel, areaName);
	RAC(self.model,currentCountryCode) = RACObserve(self.addressViewModel, areaCode);
	
	_executeAlterAddressCommand = self.addressViewModel.selectCommand;
	@weakify(self)
  _executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self);
    return [self commitSignal];
  }];
//	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:self.commitValidSignal signalBlock:^RACSignal *(id input) {
//		@strongify(self)
//		return [self commitSignal];
//	}];
	
	return self;
}

#pragma mark - Private

- (RACSignal *)commitSignal {
  if ([self.model.income isEqualToString:@""]) {
    return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入月工资收入"}]];
  }
  if ([self.model.familyExpense isEqualToString:@""]) {
    return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入每月还贷额"}]];
  }
  if ([self.model.otherIncome isEqualToString:@""]) {
    return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入月其他收入"}]];
  }
	if (![[self.model.homeCode stringByAppendingString:self.model.homeLine] isTelephone]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输正确的联系电话",
		}]];
	}
	else if (![self.model.email isMail]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输正确的邮箱",
		}]];
	}
	else if (![self validAddress]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"详细地址至少输入三个地址",
		}]];
	}
	
	return [self.formsViewModel submitSignalWithPage:2];
}

- (RACSignal *)commitValidSignal {
	return [RACSignal
		combineLatest:@[
			RACObserve(self.model, income),
			RACObserve(self.model, otherIncome),
			RACObserve(self.model, familyExpense),
			RACObserve(self.model, currentProvince),
			RACObserve(self.model, currentCity),
			RACObserve(self.model, currentCountry),
		]
		reduce:^id(NSString *income, NSString *other, NSString *expense, NSString *province, NSString *city, NSString *country) {
			return @(
				[income isScalar] &&
				[other isScalar] &&
				[expense isScalar] &&
				province != nil &&
				city != nil &&
				country != nil
			);
		}];
}

- (BOOL)validAddress {
	NSInteger length1 = self.model.currentTown.length > 1 ? 1: 0;
	NSInteger length2 = self.model.currentCommunity.length > 1 ? 1: 0;
	NSInteger length3 = self.model.currentApartment.length > 1 ? 1: 0;
	NSInteger length4 = self.model.currentStreet.length > 1 ? 1: 0;
	
	return (length1 + length2 + length3 + length4) > 2;
}

@end
