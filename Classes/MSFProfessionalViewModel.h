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

// 教育程度
@property(nonatomic,strong) MSFSelectKeyValues *degrees;
@property(nonatomic,strong) NSString *degreesTitle;

// 社会身份
@property(nonatomic,strong) MSFSelectKeyValues *socialstatus;
@property(nonatomic,strong) NSString *socialstatusTitle;

/**
 *  职业
 */
@property(nonatomic,strong) MSFSelectKeyValues *profession;

/**
 *  工作年限
 */
@property(nonatomic,strong) MSFSelectKeyValues *seniority;

/**
 *  单位名称
 */
@property(nonatomic,strong) NSString *company;

/**
 *  行业类别
 */
@property(nonatomic,strong) MSFSelectKeyValues *industry;

/**
 *  职位
 */
@property(nonatomic,strong) MSFSelectKeyValues *position;

/**
 *  单位性质
 */
@property(nonatomic,strong) MSFSelectKeyValues *nature;

/**
 *  入职时间
 */
@property(nonatomic,strong) NSDate *date;

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

- (instancetype)initWithModel:(id)model;


@property(nonatomic,readonly) MSFApplicationForms *model;
@property(nonatomic,readonly) RACCommand *executeEducationCommand;
@property(nonatomic,readonly) RACCommand *executeSocialStatusCommand;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel contentViewController:(UIViewController *)viewController;

@end
