//
// MSFProfessionalViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFReactiveView.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFSelectKeyValues;
@class MSFApplicationForms;
@class MSFContact;

@interface MSFProfessionalViewModel : RVMViewModel <MSFReactiveView>

@property (nonatomic, strong, readonly) MSFApplicationForms *forms;
@property (nonatomic, strong) NSString *address;// 详细地址
@property (nonatomic, assign, readonly) BOOL edited;

@property (nonatomic, strong) MSFSelectKeyValues *degrees;// 教育程度
@property (nonatomic, strong) NSString *degreesTitle;
@property (nonatomic, strong) MSFSelectKeyValues *socialstatus;// 社会身份
@property (nonatomic, strong) NSString *socialstatusTitle;
@property (nonatomic, strong) MSFSelectKeyValues *industry; // 行业类别
@property (nonatomic, strong) NSString *industryTitle;
@property (nonatomic, strong) MSFSelectKeyValues *nature; // 单位性质
@property (nonatomic, strong) NSString *natureTitle; // 单位性质
@property (nonatomic, strong) MSFSelectKeyValues *professional; // 职业
@property (nonatomic, strong) NSString *professionalTitle; // 职业

@property (nonatomic, readonly) RACCommand *startedWorkDateCommand;
@property (nonatomic, readonly) RACCommand *startedDateCommand;
@property (nonatomic, readonly) RACCommand *enrollmentYearCommand;

@property (nonatomic, readonly) RACCommand *executeEducationCommand;// 选择教育程度
@property (nonatomic, readonly) RACCommand *executeSocialStatusCommand;// 选择社会身份
@property (nonatomic, readonly) RACCommand *executeIndustryCommand;// 选择行业信息
@property (nonatomic, readonly) RACCommand *executeNatureCommand;// 选择单位性质
@property (nonatomic, readonly) RACCommand *executePositionCommand;// 选择部门信息

@property (nonatomic, strong, readonly) RACCommand *executeAddressCommand; //选择地址信息
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *normalIncome;
@property (nonatomic, copy, readonly) NSString *surplusIncome;
@property (nonatomic, copy, readonly) NSString *loan;
@property (nonatomic, copy, readonly) NSString *marriage;
@property (nonatomic, copy, readonly) NSArray *contacts;

@property (nonatomic, strong, readonly) RACCommand *executeMarriageCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRemoveContact;
@property (nonatomic, strong, readonly) RACCommand *executeAddContact;

@property (nonatomic, copy, readonly) NSString *code;

- (NSInteger)numberOfSections;

@end
