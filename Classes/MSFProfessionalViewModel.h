//
// MSFProfessionalViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFReactiveView.h"

@class RACCommand;
@class MSFSelectKeyValues;
@class MSFFormsViewModel;
@class MSFApplicationForms;
@class MSFAddressViewModel;

@interface MSFProfessionalViewModel : RVMViewModel<MSFReactiveView>

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
@property (nonatomic, strong) NSString *address;// 详细地址

@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

@end
