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
@class MSFAmortize;
@class MSFLoanType;
@class MSFFormsViewModel;
@class MSFTrial;

typedef NS_ENUM(NSUInteger, MSFCartType) {
    MSFCartCommodity,
    MSFCartTravel,
};

@interface MSFCartViewModel : RVMViewModel <MSFApplicationViewModel>

// MSFApplicationViewModel
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) MSFLoanType *loanType;
@property (nonatomic, strong, readwrite) NSArray *accessories;
@property (nonatomic, strong, readwrite) NSString *applicationNo;
@property (nonatomic, strong, readwrite) NSString *amount;
@property (nonatomic, strong, readwrite) NSString *loanTerm;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

// 页面展示数据
@property (nonatomic, strong, readonly) NSString *compId; // 商铺编号
@property (nonatomic, strong) NSString *term; // 贷款期数, 外部可以修改
@property (nonatomic, strong, readonly) NSString *downPmtAmt; // 首付金额
@property (nonatomic, strong, readonly) NSString *loanAmt; // 贷款金额
@property (nonatomic, assign, readonly) BOOL joinInsurance; // 是否加入寿险计划

@property (nonatomic, strong) NSString *lifeInsuranceAmt; // 寿险金额
@property (nonatomic, strong) NSString *loanFixedAmt; // 月还款额
@property (nonatomic, strong) NSString *downPmtScale; // 首付比例
@property (nonatomic, strong) NSString *totalAmt; // 总金额
@property (nonatomic, strong) NSString *promId; // 活动ID

@property (nonatomic, strong, readonly) MSFCart  *cart;
@property (nonatomic, strong) MSFTrial *trial;
@property (nonatomic, strong, readonly) NSArray  *terms; // 产品群信息
@property (nonatomic, assign, readonly) BOOL barcodeInvalid __deprecated;

@property (nonatomic, assign, readonly) BOOL isDownPmt; // 是否需要首付
@property (nonatomic, assign, readonly) BOOL hasAgreeProtocol; // 是否同意贷款协议

// 页面命令
@property (nonatomic, strong, readonly) RACCommand *executeInsuranceCommand; //查看保险协议
@property (nonatomic, strong, readonly) RACCommand *executeNextCommand; //点击下一步
@property (nonatomic, strong, readonly) RACCommand *executeTrialCommand; // 商品试算
@property (nonatomic, strong, readonly) RACCommand *executeProtocolCommand; // 商品试算

// MSFPlanViewModel
@property (nonatomic, strong, readonly) NSArray *viewModels;

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services;

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
