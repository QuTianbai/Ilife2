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

@interface MSFSocialInsuranceCashViewModel()

@property (nonatomic, assign) id<MSFViewModelServices>services;
@property (nonatomic, strong) MSFSocialInsuranceModel *model;

@end

@implementation MSFSocialInsuranceCashViewModel

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
	
	
	_model = [[MSFSocialInsuranceModel alloc] init];
	
	RAC(self, cashpurpose) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
		return value.text;
	}];
	
	RAC(self, model.empEdwExist) = [RACObserve(self, employeeInsuranceStatus) map:^id(MSFSelectKeyValues *value) {
		self.employeeOldInsuranceStatusTitle = value.text;
		return value.code;
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
		[comps setYear:-5];
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
					 self.employeeOlderDate = [NSDateFormatter msf_stringFromDate2:selectedDate];
					 break;
				 case 1:
					 self.employeeMedicalDate = [NSDateFormatter msf_stringFromDate2:selectedDate];
					 break;
				 case 2:
					 self.residentOlderInsuranceDate = [NSDateFormatter msf_stringFromDate2:selectedDate];
					 break;
				 case 3:
					 self.residentMedicalInsuranceDate = [NSDateFormatter msf_stringFromDate2:selectedDate];
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

- (RACSignal *)submitSignal {
	return nil;
}

@end
