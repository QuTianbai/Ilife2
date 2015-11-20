//
//  MSFSocialInsuranceCashViewModel.h
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFSelectKeyValues.h"

@class RACCommand;

@interface MSFSocialInsuranceCashViewModel : RVMViewModel

//职工保险
@property (nonatomic, strong) MSFSelectKeyValues *purpose;// 教育程度
@property (nonatomic, copy) NSString *cashpurpose;
@property (nonatomic, strong) MSFSelectKeyValues *employeeInsuranceStatus;
@property (nonatomic, copy) NSString *employeeOldInsuranceStatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *employeeOlderModey;
@property (nonatomic, copy) NSString *employeeOlderModeyTitle;
@property (nonatomic, copy) NSString *employeeOlderDate;
@property (nonatomic, copy) NSString *employeeOlderMonths;
@property (nonatomic, strong) MSFSelectKeyValues *employMedicalStatus;
@property (nonatomic, copy) NSString *employMedicalStatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *employeeMedicalMoney;
@property (nonatomic, copy) NSString *employeeMedicalMoneyTitle;
@property (nonatomic, copy) NSString *employeeMedicalDate;
@property (nonatomic, copy) NSString *employeeMedicalMonths;
@property (nonatomic, strong) MSFSelectKeyValues *emplyoeeJuryStatus;
@property (nonatomic, copy) NSString *emplyoeeJuryStatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *employeeOutJobStatus;
@property (nonatomic, copy) NSString *employeeOutJobStatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *employeeBearStatus;
@property (nonatomic, copy) NSString *employeeBearStatusTitle;

//居民保险
@property (nonatomic, strong) MSFSelectKeyValues *residentOlderInsuranceStatus;
@property (nonatomic, copy) NSString *residentOlderInsuranceStatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *residentOlderInsuranceMoney;
@property (nonatomic, copy) NSString *residentOlderInsuranceMoneyTitle;
@property (nonatomic, copy) NSString *residentOlderInsuranceDate;
@property (nonatomic, copy) NSString *residentOlderInsuranceYears;
@property (nonatomic, strong) MSFSelectKeyValues *residentMedicalInsuranceStatus;
@property (nonatomic, copy) NSString *residentMedicalInsuranceStatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *residentMedicalInsuranceMoney;
@property (nonatomic, copy) NSString *residentMedicalInsuranceMoneyTitle;
@property (nonatomic, copy) NSString *residentMedicalInsuranceDate;
@property (nonatomic, copy) NSString *residentMedicalInsuranceYears;


@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmployeeInsuranceStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmployeeOlderModeyCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmployMedicalStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmployeeMedicalMoneyCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmplyoeeJuryStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmployeeOutJobStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeEmployeeBearStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeoldInsuranceDateCommand;
@property (nonatomic, strong, readonly) RACCommand *executeoldMedicalDateCommand;

@property (nonatomic, strong, readonly) RACCommand *executeResidentOlderInsuranceStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeResidentOlderInsuranceMoneyCommand;
@property (nonatomic, strong, readonly) RACCommand *executeResidentMedicalInsuranceStatusCommand;
@property (nonatomic, strong, readonly) RACCommand *executeResidentMedicalInsuranceMoneyCommand;

@property (nonatomic, strong, readonly) RACCommand *executeSubmitCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;
@end
