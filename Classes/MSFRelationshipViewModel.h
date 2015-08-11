//
//	MSFPersonalViewModel.h
//	Cash
//
//	Created by xutian on 15/6/13.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFSelectKeyValues.h"
#import "MSFViewModelServices.h"

@class MSFFormsViewModel;
@class RACCommand;
@class MSFApplicationForms;

@interface MSFRelationshipViewModel : RVMViewModel

@property (nonatomic, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, readonly) MSFApplicationForms *model;

/**
 *婚姻状况
 */
@property (nonatomic, strong) MSFSelectKeyValues *marryValues;
@property (nonatomic, strong) NSString *marryValuesTitle;
/**
 *住房状况
 */
@property (nonatomic, strong) MSFSelectKeyValues *houseValues;
@property (nonatomic, strong) NSString *houseValuesTitle;

/**
 *家庭成员一与申请人关系
 */
@property (nonatomic, strong) MSFSelectKeyValues *familyOneValues;
@property (nonatomic, strong) NSString *familyOneValuesTitle;
/**
 *家庭成员二与申请人关系
 */
@property (nonatomic, strong) MSFSelectKeyValues *familyTwoValues;
@property (nonatomic, strong) NSString *familyTwoValuesTitle;
/**
 *其他联系人与申请人关系
 */
@property (nonatomic, strong) MSFSelectKeyValues *otherOneValues;
@property (nonatomic, strong) NSString *otherOneValuesTitle;
/**
 *其他联系人二与申请人关系
 */
@property (nonatomic, strong) MSFSelectKeyValues *otherTwoValues;
@property (nonatomic, strong) NSString *otherTwoValuesTitle;
/**
 *家庭成员一姓名
 */
@property (nonatomic, strong) MSFSelectKeyValues *familyOneNameValues;
@property (nonatomic, copy) NSString *familyOneNameValuesTitle;
/**
 *家庭成员一手机号
 */
@property (nonatomic, strong) MSFSelectKeyValues *phoneNumOneValues;
@property (nonatomic, copy) NSString *phoneNumOneValuesTitle;
/**
 *同现居地址一
 */
@property (nonatomic, strong) MSFSelectKeyValues *addressOneValues;
@property (nonatomic, copy) NSString *addressOneValuesTitle;
/**
 *家庭成员二姓名
 */
@property (nonatomic, strong) MSFSelectKeyValues *familyTwoNameValues;
@property (nonatomic, copy) NSString *familyTwoNameValuesTitle;
/**
 *家庭成员二手机号
 */
@property (nonatomic, strong) MSFSelectKeyValues *phoneNumTwoValues;
@property (nonatomic, copy) NSString *phoneNumTwoValuesTitle;
/**
 *同现居地址二
 */
@property (nonatomic, strong) MSFSelectKeyValues *addressTwoValues;
@property (nonatomic, copy) NSString *addressTwoValuesTitle;
/**
 *其他联系人姓名
 */
@property (nonatomic, strong) MSFSelectKeyValues *otherOneNameValues;
@property (nonatomic, copy) NSString *otherOneNameValuesTitle;
/**
 *其他联系人手机号
 */
@property (nonatomic, strong) MSFSelectKeyValues *otherPhoneOneValues;
@property (nonatomic, copy) NSString *otherPhoneOneValuesTitle;
/**
 *其他联系人姓名二
 */
@property (nonatomic, strong) MSFSelectKeyValues *otherTwoNameValues;
@property (nonatomic, copy) NSString *otherTwoNameValuesTitle;
/**
 *其他联系人手机号二
 */
@property (nonatomic, strong) MSFSelectKeyValues *otherPhoneTwoValues;
@property (nonatomic, copy) NSString *otherPhoneTwoValuesTitle;
@property (nonatomic, strong) RACCommand *executeRequest;

@property (nonatomic, assign) BOOL hasMember2;
@property (nonatomic, assign) BOOL hasContact2;
@property (nonatomic, strong, readonly) NSString *confirmMessage;

@property (nonatomic, strong, readonly) RACCommand *executeMarryValuesCommand;
@property (nonatomic, strong, readonly) RACCommand *executeHouseValuesCommand;
@property (nonatomic, strong, readonly) RACCommand *executeFamilyOneValuesCommand;
@property (nonatomic, strong, readonly) RACCommand *executeFamilyTwoValuesCommand;
@property (nonatomic, strong, readonly) RACCommand *executeOtherOneValuesCommand;
@property (nonatomic, strong, readonly) RACCommand *executeOtherTwoValuesCommand;

@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel;

@end