//
//  MSFCartViewModel.h
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class RACCommand;
@class MSFCart;
@class MSFMarkets;
@class MSFLoanType;
@class MSFFormsViewModel;
@class MSFTrial;

@interface MSFCartViewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) NSString *applicationNo;
@property (nonatomic, strong) MSFLoanType *loanType;
@property (nonatomic, strong) MSFFormsViewModel *formViewModel; // null
@property (nonatomic, strong) NSArray *accessories; // null

// 页面展示数据
@property (nonatomic, strong, readonly) NSString *compId; // 商铺编号
@property (nonatomic, strong, readonly) NSString *term; // 贷款期数, 外部可以修改
@property (nonatomic, strong, readonly) NSString *downPmtAmt; // 首付金额
@property (nonatomic, strong, readonly) NSString *loanAmt; // 贷款金额
@property (nonatomic, assign, readonly) BOOL joinInsurance; // 是否加入寿险计划

@property (nonatomic, strong, readonly) MSFCart  *cart;
@property (nonatomic, strong, readonly) MSFTrial *trial;
@property (nonatomic, strong, readonly) NSArray  *terms; // 产品群信息

@property (nonatomic, strong, readonly) RACCommand *executeInsuranceCommand; //查看保险协议
@property (nonatomic, strong, readonly) RACCommand *executeNextCommand; //点击下一步

- (instancetype)initWithApplicationNo:(NSString *)appNo
														 services:(id<MSFViewModelServices>)services;
- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
