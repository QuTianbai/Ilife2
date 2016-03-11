//
// MSFApplicationViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class MSFLoanType;
@class RACCommand;

// 贷款申请, 需遵循的协议
@protocol MSFApplicationViewModel <NSObject>

// 申请API调用服务
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

// 申请数据提交，提交完成后，进入提交广告界面
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

// 申请的产品类型: 社保贷/马上贷款/随借随还
@property (nonatomic, strong, readonly) MSFLoanType *loanType;

// 上传附件的时候需要
@property (nonatomic, strong, readwrite) NSString *applicationNo;
@property (nonatomic, strong, readwrite) NSString *amount;
@property (nonatomic, strong, readwrite) NSString *loanTerm;
@property (nonatomic, strong, readwrite) NSArray *accessories;

@end
