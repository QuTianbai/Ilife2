//
//  MSFSocialInsuranceCashViewModel.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialInsuranceCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectionViewModel.h"
#import "MSFSocialInsuranceModel.h"
#import "NSDate+UTC0800.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient+MSFSocialInsurance.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFApplicationForms.h"
#import "MSFFormsViewModel.h"

enum SELECTTYPE {
	EMPOLDSTATUS,    //职工养老社保状态
	EMPOLDMONEY,     //职工养老基数
	EMPMEDSTATUS,    //职工医疗状态
	EMPMEDMONEY,     //职工医疗基数
	EMPINHUYRSTATUS, //职工工伤险状态
	EMPUNEMPSTATUS,  //职工失业险装填
	EMPBEARSTATUS,   //职工生育险状态
	RESOLDSTATUS,    //居民养老状态
	RESOLDMONEY,     //居民养老基数
	RESMEDSTATUS,    //居民医疗状态
	RESMEDMONEY      //居民医疗基数
};

static NSString *const MSFSocialInsuranceCashViewModelErrorDomain = @"MSFSocialInsuranceCashViewModelErrorDomain";

@interface MSFSocialInsuranceCashViewModel()

@end

@implementation MSFSocialInsuranceCashViewModel

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel productID:(NSString *)productID services:(id <MSFViewModelServices>)services {
  self = [self initWithServices:services];
  if (!self) {
    return nil;
  }
	_productID = productID;
	_productCd = productID;
	_formViewModel = formsViewModel;
	RAC(self, productType) = [RACObserve(self, formViewModel.model.socialStatus) map:^id(id value) {
		self.productType = value;
		//[self commonInit];
		self.active = NO;
		self.active = YES;
		[self commonInitDefult];
		return value;
	}];
	
	RACChannelTo(self, productCd) = RACChannelTo(self, productID);
	RACChannelTo(self, accessoryInfoVOArray) = RACChannelTo(self, accessories);
	
  return self;
}

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_cashpurpose = @"";
	_employeeOldInsuranceStatusTitle = @"";
	_employeeOlderModeyTitle = @"";
	_employeeOlderDate = @"";
	_employeeOlderMonths = @"";
	_employMedicalStatusTitle = @"";
	_employeeMedicalMoneyTitle = @"";
	_emplyoeeJuryStatusTitle = @"";
	_employeeOutJobStatusTitle = @"";
	_employeeBearStatusTitle = @"";
	_residentOlderInsuranceStatusTitle = @"";
	_residentOlderInsuranceMoneyTitle = @"";
	_residentMedicalInsuranceStatusTitle = @"";
	_residentMedicalInsuranceMoneyTitle = @"";
	_residentOlderInsuranceYears = @"2";
	_status = @"0";
	_productCd = @"";
	_accessoryInfoVOArray = [[NSArray alloc] init];
	
	_model = [[MSFSocialInsuranceModel alloc] init];
	
	RAC(self, cashpurpose) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
		return value.text;
	}];
	
	RAC(self, model.empEdwExist) = [RACObserve(self, employeeInsuranceStatus) map:^id(MSFSelectKeyValues *value) {
		self.employeeOldInsuranceStatusTitle = value.text;
		return value.code;
	}];
	
	RAC(self, employeeOldInsuranceStatusTitle) = [RACObserve(self, employeeInsuranceStatus) map:^id(id value) {
		return [value text];
	}];
	
	RAC(self, model.empEdwBase) = [RACObserve(self, employeeOlderModey) map:^id(MSFSelectKeyValues *value) {
		self.employeeOlderModeyTitle = value.text;
		return value.code;
	}];
	
	RAC(self, model.empMdcInsuExist) = [RACObserve(self, employMedicalStatus) map:^id(MSFSelectKeyValues *value) {
		self.employMedicalStatusTitle = value.text;
		return value.code;
	}];
	RAC(self, model.empMdcInsuBase) = [RACObserve(self, employeeMedicalMoney) map:^id(MSFSelectKeyValues *value) {
		self.employeeMedicalMoneyTitle = value.text;
		return value.code;
	}];
	
	RAC(self, model.injuInsuExist) = [RACObserve(self, emplyoeeJuryStatus) map:^id(MSFSelectKeyValues *value) {
		self.emplyoeeJuryStatusTitle = value.text;
		return value.code;
	}];
	RAC(self, model.unempInsuExist) = [RACObserve(self, employeeOutJobStatus) map:^id(MSFSelectKeyValues *value) {
		self.employeeOutJobStatusTitle = value.text;
		return value.code;
	}];
	RAC(self, model.birthInsuExist) = [RACObserve(self, employeeBearStatus) map:^id(MSFSelectKeyValues *value) {
		self.employeeBearStatusTitle = value.text;
		return value.code;
	}];
	RAC(self, model.empEdwStartDate) = RACObserve(self, employeeOlderDate);
	RAC(self, model.empMdcInsuStartDate) = RACObserve(self, employeeMedicalDate);
	RAC(self, model.empEdwMonths) = RACObserve(self, employeeOlderMonths);
	RAC(self, model.empMdcMonths) = RACObserve(self, employeeMedicalMonths);
	//居民保险
	RAC(self, model.rsdtOldInsuExist) = [RACObserve(self, residentOlderInsuranceStatus) map:^id(MSFSelectKeyValues *value) {
		self.residentOlderInsuranceStatusTitle = value.text;
		return value.code;
	}];
	
	RAC(self, model.rsdtOldInsuLvl) = [RACObserve(self, residentOlderInsuranceMoney) map:^id(MSFSelectKeyValues *value) {
		self.residentOlderInsuranceMoneyTitle = value.text;
		return value.code;
	}];
	
	RAC(self, model.rsdtMdcInsuExist) = [RACObserve(self, residentMedicalInsuranceStatus) map:^id(MSFSelectKeyValues *value) {
		self.residentMedicalInsuranceStatusTitle = value.text;
		return value.code;
	}];
	RAC(self, model.rsdtMdcInsuLvl) = [RACObserve(self, residentMedicalInsuranceMoney) map:^id(MSFSelectKeyValues *value) {
		self.residentMedicalInsuranceMoneyTitle = value.text;
		return value.code;
	}];
	RAC(self, model.rsdtOldInsuStartDate) = RACObserve(self, residentOlderInsuranceDate);
	RAC(self, model.rsdtMdcInsuStartDate) = RACObserve(self, residentMedicalInsuranceDate);
	RAC(self, model.rsdtOldInsuYears) = RACObserve(self, residentOlderInsuranceYears);
	RAC(self, model.rsdtMdcInsuYears) = RACObserve(self, residentMedicalInsuranceYears);
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchGetSocialInsuranceInfo] subscribeNext:^(id x) {
			self.model = x;
			[self commonInit];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
	
	
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"moneyUse" index:0];
	}];
	_executeEmployeeInsuranceStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:1];
	}];
	_executeEmployeeOlderModeyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"employeeOlderInsurance" index:2];
	}];
	_executeEmployeeMedicalMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"employeeMedicalInsurance" index:3];
	}];
	_executeResidentOlderInsuranceMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"residentOlderInsurance" index:4];
	}];
	_executeResidentMedicalInsuranceMoneyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"residentMedicalInsurance" index:5];
	}];
	
	_executeEmployMedicalStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:6];
	}];
	_executeEmplyoeeJuryStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:7];
	}];
	_executeEmployeeOutJobStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:8];
	}];
	_executeEmployeeBearStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:9];
	}];
	
	_executeResidentOlderInsuranceStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:10];
	}];
	_executeResidentMedicalInsuranceStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal:@"isInsurance" index:11];
	}];
	
	_executeoldInsuranceDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self OldInsurancestartSignal:input withIndex:0];
	}];
	
	_executeoldMedicalDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self OldInsurancestartSignal:input withIndex:1];
	}];
	
	_executeoldInsuranceDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self OldInsurancestartSignal:input withIndex:2];
	}];
	
	_executeoldMedicalDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self OldInsurancestartSignal:input withIndex:3];
	}];
	
	_executeSaveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self saveSignal];
	}];

	
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self submitSignal];
	}];
	
	return self;
	
}

- (RACSignal *)executePurposeSignal:(NSString *)jsonFileName index:(NSInteger)index {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectViewModelWithFilename:jsonFileName];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			switch (index) {
				case 0:
					self.purpose = x;
					break;
				case 1:
					self.employeeInsuranceStatus = x;
					break;
				case 2:
					self.employeeOlderModey = x;
					break;
				case 3:
					self.employeeMedicalMoney = x;
					break;
				case 4:
					self.residentOlderInsuranceMoney = x;
					break;
				case 5:
					self.residentMedicalInsuranceMoney = x;
					break;
				case 6:
					self.employMedicalStatus = x;
					break;
				case 7:
					self.emplyoeeJuryStatus = x;
					break;
				case 8:
					self.employeeOutJobStatus = x;
					break;
				case 9:
					self.employeeBearStatus = x;
					break;
				case 10:
					self.residentOlderInsuranceStatus = x;
					break;
				case 11:
					self.residentMedicalInsuranceStatus = x;
					break;
				default:
					break;
			}
			[self.services popViewModel];
		}];
		[subscriber sendCompleted];
		return nil;
	}];
	return nil;
}

- (RACSignal *)OldInsurancestartSignal:(UIView *)aView withIndex:(NSInteger)index {
	@weakify(self)
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate msf_date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-50];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[ActionSheetDatePicker
		 showPickerWithTitle:@""
		 datePickerMode:UIDatePickerModeDate
		 selectedDate:currentDate
		 minimumDate:minDate
		 maximumDate:maxDate
		 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
			 switch (index) {
				 case 0:
					 self.employeeOlderDate = [NSDateFormatter msf_stringFromDate4:selectedDate];
					 break;
				 case 1:
					 self.employeeMedicalDate = [NSDateFormatter msf_stringFromDate4:selectedDate];
					 break;
				 case 2:
					 self.residentOlderInsuranceDate = [NSDateFormatter msf_stringFromDate4:selectedDate];
					 break;
				 case 3:
					 self.residentMedicalInsuranceDate = [NSDateFormatter msf_stringFromDate4:selectedDate];
					 break;
				 default:
					 break;
			 }
				
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 switch (index) {
				 case 0:
					 self.employeeOlderDate = nil;
					 break;
				 case 1:
					 self.employeeMedicalDate = nil;
					 break;
				 case 2:
					 self.residentOlderInsuranceDate = nil;
					 break;
				 case 3:
					 self.residentMedicalInsuranceDate = nil;
					 break;
				 default:
					 break;
			 }
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:aView];
		return nil;
	}] replay];
}

- (void)commonInit {
	if ([self.productType isEqualToString:@"SI05"]) {
		//居民
		if (self.model.rsdtOldInsuExist == nil || [self.model.rsdtOldInsuExist isEqualToString:@""]) {
			[self setPostionDefultWithName:@"isInsurance" selectValuesType:RESOLDSTATUS index:0];
		} else {
			NSArray *radOlderExist = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
			[radOlderExist enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.rsdtOldInsuExist]) {
					self.residentOlderInsuranceStatus = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.rsdtOldInsuLvl == nil || [self.model.rsdtOldInsuLvl isEqualToString:@""]) {
			[self setPostionDefultWithName:@"residentOlderInsurance" selectValuesType:RESOLDMONEY index:2];
		} else {
			NSArray *residentOlderInsuranceMoney = [MSFSelectKeyValues getSelectKeys:@"residentOlderInsurance"];
			[residentOlderInsuranceMoney enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.rsdtOldInsuLvl]) {
					self.residentOlderInsuranceMoney = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.rsdtMdcInsuExist == nil || [self.model.rsdtMdcInsuExist isEqualToString:@""]) {
			[self setPostionDefultWithName:@"isInsurance" selectValuesType:RESMEDSTATUS index:0];
		} else {
			NSArray *residentMedicalInsuranceStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
			[residentMedicalInsuranceStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.rsdtMdcInsuExist]) {
					self.residentMedicalInsuranceStatus = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.rsdtMdcInsuLvl == nil || [self.model.rsdtMdcInsuLvl isEqualToString:@""]) {
			[self setPostionDefultWithName:@"residentMedicalInsurance" selectValuesType:RESMEDMONEY index:0];
		} else {
			NSArray *residentMedicalInsuranceMoney = [MSFSelectKeyValues getSelectKeys:@"residentMedicalInsurance"];
			[residentMedicalInsuranceMoney enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.rsdtMdcInsuLvl]) {
					self.residentMedicalInsuranceMoney = obj;
					*stop = YES;
				}
			}];
		}
		
		self.residentOlderInsuranceDate = self.model.rsdtOldInsuStartDate?:[self setTime];
		self.residentOlderInsuranceYears = self.model.rsdtOldInsuYears?:@"2";
		self.residentMedicalInsuranceDate = self.model.rsdtMdcInsuStartDate?:[self setTime];
		self.residentMedicalInsuranceYears = self.model.rsdtMdcInsuYears?:@"2";

	} else {
		//职工
		if (self.model.empEdwExist == nil || [self.model.empEdwExist isEqualToString:@""]) {
			[self setPostionDefultWithName:@"isInsurance" selectValuesType:EMPOLDSTATUS index:0];
		} else {
			NSArray *employeeOlderExist = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
			[employeeOlderExist enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.empEdwExist]) {
					self.employeeInsuranceStatus = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.empEdwBase == nil || [self.model.empEdwBase isEqualToString:@""]) {
			[self setPostionDefultWithName:@"employeeOlderInsurance" selectValuesType:EMPOLDMONEY index:2];
		} else {
			NSArray *employeeOlderModey = [MSFSelectKeyValues getSelectKeys:@"employeeOlderInsurance"];
			[employeeOlderModey enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.empEdwBase]) {
					self.employeeOlderModey = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.empMdcInsuExist == nil || [self.model.empMdcInsuExist isEqualToString:@""]) {
			[self setPostionDefultWithName:@"isInsurance" selectValuesType:EMPMEDSTATUS index:0];
		} else {
		
			NSArray *employMedicalStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
			[employMedicalStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.empMdcInsuExist]) {
					self.employMedicalStatus = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.empMdcInsuBase == nil || [self.model.empMdcInsuBase isEqualToString:@""]) {
			[self setPostionDefultWithName:@"employeeMedicalInsurance" selectValuesType:EMPMEDMONEY index:3];
		} else {
			NSArray *employeeMedicalMoney = [MSFSelectKeyValues getSelectKeys:@"employeeMedicalInsurance"];
			[employeeMedicalMoney enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.empMdcInsuBase]) {
					self.employeeMedicalMoney = obj;
					*stop = YES;
				}
			}];
	}
	
	
	if (self.model.injuInsuExist == nil || [self.model.injuInsuExist isEqualToString:@""]) {
		[self setPostionDefultWithName:@"isInsurance" selectValuesType:EMPINHUYRSTATUS index:0];
	} else {
		NSArray *emplyoeeJuryStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		[emplyoeeJuryStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
			if ([obj.code isEqualToString:self.model.injuInsuExist]) {
				self.emplyoeeJuryStatus = obj;
				*stop = YES;
			}
		}];
	}
	
		if (self.model.unempInsuExist == nil || [self.model.unempInsuExist isEqualToString:@""]) {
			[self setPostionDefultWithName:@"isInsurance" selectValuesType:EMPUNEMPSTATUS index:0];
		} else {
			NSArray *employeeOutJobStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
			[employeeOutJobStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.unempInsuExist]) {
					self.employeeOutJobStatus = obj;
					*stop = YES;
				}
			}];
		}
		
		if (self.model.birthInsuExist == nil || [self.model.birthInsuExist isEqualToString:@""]) {
			[self setPostionDefultWithName:@"isInsurance" selectValuesType:EMPBEARSTATUS index:0];
		} else {
		
			NSArray *employeeBearStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
			[employeeBearStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:self.model.birthInsuExist]) {
					self.employeeBearStatus = obj;
					*stop = YES;
				}
			}];
		}
		
		self.employeeOlderDate = self.model.empEdwStartDate?:[self setTime];
		self.employeeOlderMonths = self.model.empEdwMonths?:@"12";
		self.employeeMedicalDate = self.model.empMdcInsuStartDate?:[self setTime];
		self.employeeMedicalMonths = self.model.empMdcMonths?:@"12";
	}
}

- (void)commonInitDefult {
	if ([self.productType isEqualToString:@"SI05"]) {
		//居民
		NSArray *radOlderExist = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.residentOlderInsuranceStatus = radOlderExist.firstObject;
		
		NSArray *residentOlderInsuranceMoney = [MSFSelectKeyValues getSelectKeys:@"residentOlderInsurance"];
		self.residentOlderInsuranceMoney = residentOlderInsuranceMoney[2];
		
		NSArray *residentMedicalInsuranceStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.residentMedicalInsuranceStatus = residentMedicalInsuranceStatus.firstObject;
		
		NSArray *residentMedicalInsuranceMoney = [MSFSelectKeyValues getSelectKeys:@"residentMedicalInsurance"];
		self.residentMedicalInsuranceMoney = residentMedicalInsuranceMoney.firstObject;
		
		self.residentOlderInsuranceDate = [self setTime];
		self.residentOlderInsuranceYears = @"2";
		
		self.residentMedicalInsuranceDate = [self setTime];
		self.residentMedicalInsuranceYears = @"2";
	} else {
		//职工
		NSArray *employeeOlderExist = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.employeeInsuranceStatus = employeeOlderExist.firstObject;
		
		NSArray *employeeOlderModey = [MSFSelectKeyValues getSelectKeys:@"employeeOlderInsurance"];
		self.employeeOlderModey = employeeOlderModey[2];
		
		NSArray *employMedicalStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.employMedicalStatus = employMedicalStatus.firstObject;
		
		NSArray *employeeMedicalMoney = [MSFSelectKeyValues getSelectKeys:@"employeeMedicalInsurance"];
		self.employeeMedicalMoney = employeeMedicalMoney[3];
		
		NSArray *emplyoeeJuryStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.emplyoeeJuryStatus = emplyoeeJuryStatus.firstObject;
		
		NSArray *employeeOutJobStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.employeeOutJobStatus = employeeOutJobStatus.firstObject;
		
		NSArray *employeeBearStatus = [MSFSelectKeyValues getSelectKeys:@"isInsurance"];
		self.employeeBearStatus = employeeBearStatus.firstObject;
		
		self.employeeOlderDate = [self setTime];
		self.employeeOlderMonths = @"12";
		self.employeeMedicalDate = [self setTime];
		self.employeeMedicalMonths = @"12";

	}
}

- (void)setPostionDefultWithName:(NSString *)filename selectValuesType:(NSInteger)type index:(NSInteger)index {
	NSArray *array = [MSFSelectKeyValues getSelectKeys:filename];
	switch (type) {
		case EMPOLDSTATUS:
			self.employeeInsuranceStatus = array[index];
			break;
		case EMPOLDMONEY:
			self.employeeOlderModey = array[index];
			break;
		case EMPMEDSTATUS:
			self.employMedicalStatus = array[index];
			break;
		case EMPMEDMONEY:
			self.employeeMedicalMoney = array[index];
			break;
		case EMPINHUYRSTATUS:
			self.emplyoeeJuryStatus = array[index];
			break;
		case EMPUNEMPSTATUS:
			self.employeeOutJobStatus = array[index];
			break;
		case EMPBEARSTATUS:
			self.employeeBearStatus = array[index];
			break;
			
		case RESOLDSTATUS:
			self.residentOlderInsuranceStatus = array[index];
			break;
		case RESOLDMONEY:
			self.residentOlderInsuranceMoney = array[index];
			break;
		case RESMEDSTATUS:
			self.residentMedicalInsuranceStatus = array[index];
			break;
		case RESMEDMONEY:
			self.residentMedicalInsuranceMoney = array[index];
			break;
			
  default:
			break;
	}
	//selectvelues = array[index];
}

- (NSString *)setTime {
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDateComponents *comps = nil;
	
	comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
	NSDateComponents *adcomps = [[NSDateComponents alloc] init];
 [adcomps setYear:-1];
 NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
	return [NSDateFormatter msf_stringFromDate4:newdate];
}

- (RACSignal *)submitSignal {
	
	return [self.services.httpClient fetchSubmitSocialInsuranceInfoWithModel:@{@"productCd": self.productCd, @"loanPurpose":self.purpose.code} AndAcessory:self.accessoryInfoVOArray Andstatus:self.status];
}

- (RACSignal *)saveSignal {
	
	NSError *error = nil;
	NSString *errorStr = @"";
	if (self.cashpurpose.length == 0 ) {
		errorStr = @"请选择贷款用途";
		
		error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
		return [RACSignal error:error];
	}
	if (![self.productType isEqualToString:@"SI05"]) {
		if (self.employeeOlderMonths.intValue > 600 ) {
			self.employeeOlderMonths = @"12";
			errorStr = @"职工养老保险实际缴费月数:请输入600以内整书";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
		if (self.employeeMedicalMonths.intValue > 600) {
			self.employeeMedicalMonths = @"12";
			errorStr = @"职工医疗保险实际缴费月数:请输入600以内整书";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
	} else {
		if (self.residentOlderInsuranceYears.intValue > 50 ) {
			self.residentOlderInsuranceYears = @"2";
			errorStr = @"居民养老保险实际缴费年数:请输入600以内整书";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
		if (self.residentMedicalInsuranceYears.intValue > 50) {
			self.residentMedicalInsuranceYears = @"2";
			errorStr = @"居民医疗保险实际缴费年数:请输入600以内整书";
			
			error = [NSError errorWithDomain:MSFSocialInsuranceCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
			return [RACSignal error:error];
		}
	}
	
	return [self.services.httpClient fetchSaveSocialInsuranceInfoWithModel:self.model];
	
}

@end
