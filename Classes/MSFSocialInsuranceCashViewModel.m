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
#import "MSFClient+MSFApplyInfo.h"
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
#import "MSFUserContact.h"
#import "MSFClient+MSFApplyInfo.h"
#import "NSString+Matches.h"

static NSString *const MSFSocialInsuranceCashViewModelErrorDomain = @"MSFSocialInsuranceCashViewModelErrorDomain";

@interface MSFSocialInsuranceCashViewModel()

@property (nonatomic, strong) MSFAddressViewModel *liveAddrViewModel;
@property (nonatomic, strong) MSFAddressViewModel *compAddrViewModel;
@property (nonatomic, strong, readwrite) MSFSelectKeyValues *purpose;
@property (nonatomic, strong, readwrite) MSFSelectKeyValues *basicPayment;
@property (nonatomic, strong, readwrite) MSFUserContact *contact;

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
	[self setUpAddress];
	if (self.formViewModel.model.contrastList.count > 0) {
		self.contact = self.formViewModel.model.contrastList[0];
	}
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
	_joinInsurance = YES;
	_accessoryInfoVOArray = [[NSArray alloc] init];
	_model = [[MSFSocialInsuranceModel alloc] init];
	_contact = [[MSFUserContact alloc] init];
	if (self.formViewModel.model.contrastList.count > 0) {
		_contact = self.formViewModel.model.contrastList[0];
	}

	[[MSFSelectKeyValues getSelectKeys:@"moneyUse"] enumerateObjectsUsingBlock:^(MSFSelectKeyValues *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		if ([obj.code isEqualToString:@"PL99"]) {
			self.purpose = obj;
			*stop = YES;
		}
	}];
	[[MSFSelectKeyValues getSelectKeys:@"employeeOlderInsurance"] enumerateObjectsUsingBlock:^(MSFSelectKeyValues *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
		if ([obj.code isEqualToString:@"C"]) {
			self.basicPayment = obj;
			*stop = YES;
		}
	}];
	
	@weakify(self)
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"moneyUse" index:0];
	}];
	_executeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self insuranceSignal];
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
		[self prepareSubmit];
		return [self submitSignal];
	}];
	
	[[self.services.httpClient fetchGetSocialInsuranceInfo]subscribeNext:^(MSFSocialInsuranceModel *x) {
			[_model mergeValuesForKeysFromModel:x];
	} error:^(NSError *error) {
			
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
				case 0: self.purpose = x; break;
				case 1: self.contact.contactRelation = x.code; break;
				case 2: self.basicPayment = x; break;
				default: break;
			}
			[self.services popViewModel];
		}];
		[subscriber sendCompleted];
		return nil;
	}];
	return nil;
}

- (RACSignal *)insuranceSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLifeInsuranceViewModel *viewModel = [[MSFLifeInsuranceViewModel alloc] initWithServices:self.services loanType:self.loanType];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)submitSignal {
	if (self.status.integerValue == 0) {
		return [[[self.services.httpClient fetchSaveSocialInsuranceInfoWithModel:self.model]
			zipWith:[self.services.httpClient submitUserInfo:self.formViewModel.model infoType:4]]
			map:^id(id value) {
				return value;
			}];
	}
	return [self.services.httpClient fetchSubmitSocialInsuranceInfoWithModel:@{@"productCd": self.productCd, @"loanPurpose":self.purpose.code, @"jionLifeInsurance": self.joinInsurance ? @"1" : @"0"} AndAcessory:self.accessoryInfoVOArray Andstatus:self.status];
}

- (void)prepareSubmit {
	MSFApplicationForms *forms = self.formViewModel.model;
	if (forms.contrastList.count == 0) {
		forms.contrastList = @[self.contact];
	}
	self.model.empEdwBase = self.basicPayment.code;
}

- (NSString *)invalidString {
	MSFApplicationForms *forms = self.formViewModel.model;
	if (self.purpose.code.length == 0) {
		return @"请选择贷款用途";
	} else if (forms.currentProvinceCode.length == 0 || forms.currentCityCode.length == 0 || forms.currentProvinceCode.length == 0) {
		return @"请选择居住地区";
	} else if (forms.abodeDetail.length < 3) {
		return @"请填写居住地址，不少于3个字";
	} else if (forms.unitName.length < 4 || forms.unitName.length > 30) {
		return @"请填写单位名称，4~30个汉字";
	} else if (forms.workProvinceCode.length == 0 || forms.workCityCode.length == 0 || forms.workCountryCode.length == 0) {
		return @"请选择公司所在地区";
	} else if (forms.empAdd.length < 3) {
		return @"请填写公司地址，不少于3个字";
	} else if (self.contact.contactRelation.length == 0) {
		return @"请选择与联系人关系";
	} else if (self.contact.contactName.length == 0 || !self.contact.contactName.isChineseName) {
		return @"请填写正确的联系人姓名";
	} else if (self.contact.contactMobile.length != 11 || ![self.contact.contactMobile isMobile]) {
		return @"请填写正确的手机号码";
	} else if (self.model.empEdwBase.length == 0) {
		return @"请选择社保缴费基数";
	}
	return nil;
}

@end
