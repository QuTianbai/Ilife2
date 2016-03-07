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

extern const NSInteger MSFProfessionalContactCellAdditionButton;
extern const NSInteger MSFProfessionalContactCellRemoveButton;
extern const NSInteger MSFProfessionalContactCellRelationshipButton;
extern const NSInteger MSFProfessionalContactCellRelationshipTextFeild;
extern const NSInteger MSFProfessionalContactCellNameTextFeild;
extern const NSInteger MSFProfessionalContactCellPhoneTextFeild;
extern const NSInteger MSFProfessionalContactCellPhoneButton;
extern const NSInteger MSFProfessionalContactCellAddressTextFeild;
extern const NSInteger MSFProfessionalContactCellAddressSwitch;

@interface MSFProfessionalViewModel : RVMViewModel <MSFReactiveView>

@property (nonatomic, strong, readonly) MSFApplicationForms *forms;
@property (nonatomic, strong) NSString *address;// 详细地址

@property (nonatomic, assign, readonly) BOOL edited __deprecated;
@property (nonatomic, strong) MSFSelectKeyValues *degrees __deprecated;// 教育程度
@property (nonatomic, strong) NSString *degreesTitle __deprecated;
@property (nonatomic, strong) MSFSelectKeyValues *socialstatus __deprecated;// 社会身份
@property (nonatomic, strong) NSString *socialstatusTitle __deprecated;
@property (nonatomic, strong) MSFSelectKeyValues *industry __deprecated; // 行业类别
@property (nonatomic, strong) NSString *industryTitle __deprecated;
@property (nonatomic, strong) MSFSelectKeyValues *nature __deprecated; // 单位性质
@property (nonatomic, strong) NSString *natureTitle __deprecated; // 单位性质
@property (nonatomic, strong) MSFSelectKeyValues *professional __deprecated; // 职业
@property (nonatomic, strong) NSString *professionalTitle __deprecated; // 职业
@property (nonatomic, readonly) RACCommand *startedWorkDateCommand __deprecated;
@property (nonatomic, readonly) RACCommand *startedDateCommand __deprecated;
@property (nonatomic, readonly) RACCommand *enrollmentYearCommand __deprecated;

@property (nonatomic, readonly) RACCommand *executeEducationCommand;// 选择教育程度
@property (nonatomic, readonly) RACCommand *executeSocialStatusCommand;// 选择社会身份


@property (nonatomic, strong, readonly) RACCommand *executeAddressCommand; //选择地址信息
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

// 社会身份编码
@property (nonatomic, copy, readonly) NSString *code;
// 社会身份文字
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *normalIncome;
@property (nonatomic, copy, readonly) NSString *surplusIncome;
@property (nonatomic, copy, readonly) NSString *loan;
@property (nonatomic, copy, readonly) NSString *marriage;

@property (nonatomic, copy, readonly) NSString *schoolName;
@property (nonatomic, copy, readonly) NSString *schoolDate;
@property (nonatomic, copy, readonly) NSString *schoolLength;

@property (nonatomic, copy, readonly) NSString *jobName;
@property (nonatomic, copy, readonly) NSString *jobCategory;
@property (nonatomic, copy, readonly) NSString *jobNature;
@property (nonatomic, copy, readonly) NSString *jobDate;

@property (nonatomic, copy, readonly) NSString *jobPhone;
@property (nonatomic, copy, readonly) NSString *jobExtPhone;
@property (nonatomic, copy, readonly) NSString *jobAddress;
@property (nonatomic, copy, readonly) NSString *jobDetailAddress;
@property (nonatomic, copy, readonly) NSString *jobPositionDepartment;
@property (nonatomic, copy, readonly) NSString *jobPosition;
@property (nonatomic, copy, readonly) NSString *jobPositionDate;

@property (nonatomic, copy, readonly) NSString *qualification;

@property (nonatomic, strong, readonly) RACCommand *executeMarriageCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRemoveContactCommand;
@property (nonatomic, strong, readonly) RACCommand *executeAddContactCommand;

@property (nonatomic, strong, readonly) RACCommand *executeRelationshipCommand;
@property (nonatomic, strong, readonly) RACCommand *executeContactCommand;
@property (nonatomic, strong, readonly) RACCommand *executeSchoolDateCommand;
@property (nonatomic, strong, readonly) RACCommand *executeJobDateCommand;
@property (nonatomic, strong, readonly) RACCommand *executeJobPositionDateCommand;

// 选择行业信息
@property (nonatomic, strong, readonly) RACCommand *executeIndustryCommand;

// 选择单位性质
@property (nonatomic, strong, readonly) RACCommand *executeNatureCommand;

// 选择部门信息
@property (nonatomic, strong, readonly) RACCommand *executePositionCommand;

// 联系人MSFContactViewModel
@property (nonatomic, strong, readonly) NSArray *viewModels;

- (NSInteger)numberOfSections;

@end
