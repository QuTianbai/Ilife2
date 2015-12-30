//
//  MSFSocialInsuranceCashViewModel.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialInsuranceCashViewModel.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFClient+MSFSocialInsurance.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSDate+UTC0800.h"

#import "MSFSocialInsuranceModel.h"
#import "MSFLifeInsuranceViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAddressViewModel.h"

#import "MSFApplicationForms.h"
#import "MSFLoanType.h"
#import "MSFAddress.h"

static NSString *const MSFSocialInsuranceCashViewModelErrorDomain = @"MSFSocialInsuranceCashViewModelErrorDomain";

@interface MSFSocialInsuranceCashViewModel()

@property (nonatomic, strong) MSFAddressViewModel *liveAddrViewModel;
@property (nonatomic, strong) MSFAddressViewModel *compAddrViewModel;

@end

@implementation MSFSocialInsuranceCashViewModel

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel loanType:(MSFLoanType *)loanType services:(id <MSFViewModelServices>)services {
  self = [self initWithServices:services];
  if (!self) {
    return nil;
  }
	_loanType = loanType;
	_productCd = loanType.typeID;
	_formViewModel = formsViewModel;
	RACChannelTo(self, productCd) = RACChannelTo(self, loanType.typeID);
	RACChannelTo(self, accessoryInfoVOArray) = RACChannelTo(self, accessories);
  return self;
}

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_status = @"0";
	_productCd = @"";
	_accessoryInfoVOArray = [[NSArray alloc] init];
	_model = [[MSFSocialInsuranceModel alloc] init];
	
	[self setUpAddress];

	[[MSFSelectKeyValues getSelectKeys:@"moneyUse"] enumerateObjectsUsingBlock:^(MSFSelectKeyValues *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		if ([obj.code isEqualToString:@"PL99"]) {
			_purpose = obj;
			*stop = YES;
		}
	}];
	[[MSFSelectKeyValues getSelectKeys:@"employeeOlderInsurance"] enumerateObjectsUsingBlock:^(MSFSelectKeyValues *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		if ([obj.code isEqualToString:@"C"]) {
			_purpose = obj;
			*stop = YES;
		}
	}];
	
	@weakify(self)
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"moneyUse" index:0];
	}];
	_executeRelationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"familyMember_type" index:1];
	}];
	_executeBasicPaymentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"employeeOlderInsurance" index:2];
	}];
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self submitSignal];
	}];
	
	return self;
}

- (void)setUpAddress {
	NSDictionary *live = @{@"province" : self.formViewModel.model.currentProvinceCode ?: @"",
												 @"city" : self.formViewModel.model.currentCityCode ?: @"",
												 @"area" : self.formViewModel.model.currentCountryCode ?: @""};
	NSDictionary *comp = @{@"province" : self.formViewModel.model.workProvinceCode ?: @"",
												 @"city" : self.formViewModel.model.workCityCode ?: @"",
												 @"area" : self.formViewModel.model.workCountryCode ?: @""};
	MSFAddress *liveAddr = [MSFAddress modelWithDictionary:live error:nil];
	MSFAddress *compAddr = [MSFAddress modelWithDictionary:comp error:nil];
	_liveAddrViewModel = [[MSFAddressViewModel alloc] initWithAddress:liveAddr services:self.services];
	_compAddrViewModel = [[MSFAddressViewModel alloc] initWithAddress:compAddr services:self.services];
	_liveArea = _liveAddrViewModel.address;
	_companyArea = _compAddrViewModel.address;
	
	RAC(self, liveArea) = RACObserve(self, liveAddrViewModel.address);
	RAC(self, companyArea) = RACObserve(self, compAddrViewModel.address);

	RAC(self, formViewModel.model.currentProvinceCode) = RACObserve(self, liveAddrViewModel.provinceCode);
	RAC(self, formViewModel.model.currentCityCode) = RACObserve(self, liveAddrViewModel.cityCode);
	RAC(self, formViewModel.model.currentCountryCode) = RACObserve(self, liveAddrViewModel.areaCode);
	RAC(self, formViewModel.model.workProvinceCode) = RACObserve(self, compAddrViewModel.provinceCode);
	RAC(self, formViewModel.model.workCityCode) = RACObserve(self, compAddrViewModel.cityCode);
	RAC(self, formViewModel.model.workCountryCode) = RACObserve(self, compAddrViewModel.areaCode);

	_executeLiveAddressCommand = _liveAddrViewModel.selectCommand;
	_executeCompAddressCommand = _compAddrViewModel.selectCommand;
}

- (RACSignal *)executePurposeSignal:(NSString *)jsonFileName index:(NSInteger)index {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectViewModelWithFilename:jsonFileName];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			switch (index) {
				case 0: _purpose = x; break;
				case 1: _relation = x; break;
				case 2: _basicPayment = x; break;
				default: break;
			}
			[self.services popViewModel];
		}];
		[subscriber sendCompleted];
		return nil;
	}];
	return nil;
}

- (NSString *)setTime {
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = nil;
	
	comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
	NSDateComponents *adcomps = [[NSDateComponents alloc] init];
 [adcomps setYear:-1];
 NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
	return [NSDateFormatter insurance_stringFromDate:newdate];
}

- (RACSignal *)submitSignal {
	return [self.services.httpClient fetchSubmitSocialInsuranceInfoWithModel:@{@"productCd": self.productCd, @"loanPurpose":self.purpose.code, @"jionLifeInsurance": self.jionLifeInsurance} AndAcessory:self.accessoryInfoVOArray Andstatus:self.status];
}

- (RACSignal *)saveSignal {
	NSError *error = nil;
	NSString *errorStr = @"";
	if (self.cashpurpose.length == 0 ) {
		errorStr = @"请选择贷款用途";
		
		error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
		return [RACSignal error:error];
	}
	if (!([self.professional isEqualToString:@"SI05"] || [self.professional isEqualToString:@"SI03"] ||[self.professional isEqualToString:@"SI06"])) {
		if (self.employeeOlderMonths.intValue > 600 || self.employeeOlderMonths.intValue < 1) {
			self.employeeOlderMonths = @"12";
			errorStr = @"职工养老保险实际缴费月数:请输入1-600之间的整数";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
		if (self.employeeMedicalMonths.intValue > 600 || self.employeeMedicalMonths.intValue < 1) {
			self.employeeMedicalMonths = @"12";
			errorStr = @"职工医疗保险实际缴费月数:请输入1-600之间的整数";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
	} else {
		if (self.residentOlderInsuranceYears.intValue > 50 || self.residentOlderInsuranceYears.intValue < 1) {
			self.residentOlderInsuranceYears = @"2";
			errorStr = @"居民养老保险实际缴费年数:请输入1-50之间的整数";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
		if (self.residentMedicalInsuranceYears.intValue > 50 || self.residentMedicalInsuranceYears.intValue < 1) {
			self.residentMedicalInsuranceYears = @"2";
			errorStr = @"居民医疗保险实际缴费年数:请输入1-50之间的整数";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
	}
	
	return [self.services.httpClient fetchSaveSocialInsuranceInfoWithModel:self.model];
	
}

- (RACSignal *)executeLifeInsuranceSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLifeInsuranceViewModel *viewModel = [[MSFLifeInsuranceViewModel alloc] initWithServices:self.services loanType:self.loanType];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
