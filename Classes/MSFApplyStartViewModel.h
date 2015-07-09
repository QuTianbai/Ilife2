//
//  MSFApplyStartViewModel.h
//  Cash
//
//  Created by xbm on 15/5/28.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"

@class RACCommand;
@class MSFClient;
@class MSFApplyInfo;
@class MSFCheckEmployee;
@class MSFMonths;
@class MSFSelectKeyValues;
@class MSFProductViewModel;
@class MSFAFCareerViewModel;
@class MSFAreas;
@class MSFSubmitViewModel;
@class MSFAFStudentViewModel;
@class MSFRelationMemberViewModel;

@interface MSFApplyStartViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;

@property(nonatomic,strong,readonly) MSFCheckEmployee *checkEmployee;
@property(nonatomic,strong,readonly) MSFApplyInfo *applyInfoModel;

- (instancetype)initWithEmployee:(MSFCheckEmployee *)employee applyInfo:(MSFApplyInfo *)applyInfo;

@property(nonatomic,strong) RACCommand *executeCashMoney;
@property(nonatomic,strong) RACCommand *executeNextPage;
@property(nonatomic,strong) RACCommand *executeIncome;
@property(nonatomic,strong) RACCommand *executeInJob;
@property(nonatomic,strong) RACCommand *executeStudent;
@property(nonatomic,strong) RACCommand *executeFree;
@property(nonatomic,strong) RACCommand *executeFamily;
@property(nonatomic,strong) RACCommand *executeSubmit;

@property(nonatomic,strong) MSFAreas *province;
@property(nonatomic,strong) MSFAreas *city;
@property(nonatomic,strong) MSFAreas *area;

@property(nonatomic,strong,readonly) MSFProductViewModel *requestViewModel;
@property(nonatomic,strong,readonly) MSFAFCareerViewModel *careerViewModel;
@property(nonatomic,strong,readonly) MSFAFStudentViewModel *studentViewModel;
@property(nonatomic,strong) MSFRelationMemberViewModel *relationViewModel;
@property(nonatomic,strong,readonly) MSFSubmitViewModel *submitViewModel;
// 基本信息
@property(nonatomic,strong) RACCommand *executeBasic;
- (RACSignal *)basicValidSignal;

@end
