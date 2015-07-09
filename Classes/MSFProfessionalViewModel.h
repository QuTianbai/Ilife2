//
// MSFProfessionalViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"

@class RACCommand;
@class MSFSelectKeyValues;
@class MSFAreas;

// 职业－学生/在职人员/自由职业
@interface MSFProfessionalViewModel : MSFFormsViewModel

// 教育程度
@property(nonatomic,strong) MSFSelectKeyValues *degrees;

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

@end
