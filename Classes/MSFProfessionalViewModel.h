//
// MSFProfessionalViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class RACCommand;
@class MSFSelectKeyValues;
@class MSFAreas;
@class MSFFormsViewModel;
@class UIViewController;
@class MSFApplicationForms;

// 职业－学生/在职人员/自由职业
@interface MSFProfessionalViewModel : RVMViewModel

#pragma mark - 教育/社会身份

// 教育程度
@property(nonatomic,strong) MSFSelectKeyValues *degrees;
@property(nonatomic,strong) NSString *degreesTitle;

// 社会身份
@property(nonatomic,strong) MSFSelectKeyValues *socialstatus;
@property(nonatomic,strong) NSString *socialstatusTitle;

#pragma mark - 学生信息

// 学生
@property(nonatomic,strong) NSString *school;
@property(nonatomic,strong) MSFSelectKeyValues *eductionalSystme;
@property(nonatomic,strong) NSString *eductionalSystmeTitle;
@property(nonatomic,strong) NSString *enrollmentYear;

#pragma mark - 职业信息

// 工作年限
@property(nonatomic,strong) MSFSelectKeyValues *seniority;
@property(nonatomic,strong) NSString *seniorityTitle;

// 单位信息
@property(nonatomic,strong) NSString *company; // 单位名称
@property(nonatomic,strong) MSFSelectKeyValues *industry; // 行业类别
@property(nonatomic,strong) NSString *industryTitle; // 行业类别
@property(nonatomic,strong) MSFSelectKeyValues *nature; // 单位性质
@property(nonatomic,strong) NSString *natureTitle; // 单位性质

// 职位信息
@property(nonatomic,strong) MSFSelectKeyValues *department; // 部门
@property(nonatomic,strong) MSFSelectKeyValues *position; // 职位
@property(nonatomic,strong) NSString *startedDate; // 入职时间

@property(nonatomic,strong) NSString *departmentTitle; // 部门
@property(nonatomic,strong) NSString *positionTitle; // 职位


@property(nonatomic,strong) NSString *areaCode;
@property(nonatomic,strong) NSString *telephone;
@property(nonatomic,strong) NSString *extensionTelephone;

/**
 * 工作地区
 */
@property(nonatomic,strong) MSFAreas *province;
@property(nonatomic,strong) MSFAreas *city;
@property(nonatomic,strong) MSFAreas *area;

/**
 *  详细地址
 */
@property(nonatomic,strong) NSString *address;

@property(nonatomic,strong) RACCommand *executeRequest;
@property(nonatomic,strong) RACCommand *executeIncumbencyRequest;

@property(nonatomic,readonly) MSFApplicationForms *model;
@property(nonatomic,readonly) RACCommand *executeEducationCommand;
@property(nonatomic,readonly) RACCommand *executeSocialStatusCommand;
@property(nonatomic,readonly) RACCommand *executeEductionalSystmeCommand;
@property(nonatomic,readonly) RACCommand *executeEnrollmentYearCommand;
@property(nonatomic,readonly) RACCommand *executeWorkingLengthCommand;

// 单位信息
@property(nonatomic,readonly) RACCommand *executeIndustryCommand;
@property(nonatomic,readonly) RACCommand *executeNatureCommand;

// 部门信息
@property(nonatomic,readonly) RACCommand *executeDepartmentCommand;
@property(nonatomic,readonly) RACCommand *executePositionCommand;
@property(nonatomic,readonly) RACCommand *executeStartedDateCommand;

@property(nonatomic,strong,readonly) RACCommand *executeAddressCommand;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel contentViewController:(UIViewController *)viewController;

@end
