//
//  MSFPersonalViewModel.h
//  Cash
//
//  Created by xutian on 15/6/13.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFSelectKeyValues.h"

@class RACCommand;

@interface MSFRelationshipViewModel : RVMViewModel
/**
 *婚姻状况
 */
@property(nonatomic,strong) MSFSelectKeyValues *marryValues;
/**
 *住房状况
 */
@property(nonatomic,strong) MSFSelectKeyValues *houseValues;
/**
 *家庭成员一与申请人关系
 */
@property(nonatomic,strong) MSFSelectKeyValues *familyOneValues;
/**
 *家庭成员二与申请人关系
 */
@property(nonatomic,strong) MSFSelectKeyValues *familyTwoValues;
/**
 *其他联系人与申请人关系
 */
@property(nonatomic,strong) MSFSelectKeyValues *otherOneValues;
/**
 *其他联系人二与申请人关系
 */
@property(nonatomic,strong) MSFSelectKeyValues *otherTwoValues;
/**
 *家庭成员姓名
 */
@property(nonatomic,copy) NSString *familyOneNameValues;
/**
 *家庭成员手机号
 */
@property(nonatomic,copy) NSString *phoneNumOneValues;
/**
 *同现居地址一
 */
@property(nonatomic,strong) MSFSelectKeyValues *addressOneValues;
/**
 *家庭成员二姓名
 */
@property(nonatomic,copy) NSString *familyTwoNameValues;
/**
 *家庭成员二手机号
 */
@property(nonatomic,copy) NSString *phoneNumTwoValues;
/**
 *同现居地址二
 */
@property(nonatomic,copy) NSString *addressTwoValues;
/**
 *其他联系人姓名
 */
@property(nonatomic,copy) NSString *otherOneNameValues;
/**
 *其他联系人手机号
 */
@property(nonatomic,copy) NSString *otherPhoneOneValues;
/**
 *其他联系人姓名二
 */
@property(nonatomic,copy) NSString *otherTwoNameValues;
/**
 *其他联系人手机号二
 */
@property(nonatomic,copy) NSString *otherPhoneTwoValues;
@property(nonatomic,strong) RACCommand *executeRequest;
- (RACSignal *)requestValidSignal;

@end