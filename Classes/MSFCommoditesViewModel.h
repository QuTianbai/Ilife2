//
// MSFCommoditesViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFApplicationViewModel.h"

@class RACCommand;
@class MSFBarcode;

// 商品贷，申请信息编辑，ViewModel
@interface MSFCommoditesViewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, weak) id <MSFViewModelServices> services;

// 申请订单号，社保贷默认申请流程中申请订单号为空字符串
@property (nonatomic, strong) NSString *applicationNo;

// 申请表中，用户基本信息/职业信息/联系人信息
@property (nonatomic, strong) MSFFormsViewModel *formViewModel;

// 申请的产品类型: 社保贷/马上贷款/随借随还
@property (nonatomic, strong) MSFLoanType *loanType;

// 附件列表 <NSDictionary>
@property (nonatomic, strong) NSArray *accessories;

// 传入的二维码编码信息
@property (nonatomic, strong, readonly) MSFBarcode *barcode;

// 执行协议，调用协议界面
@property (nonatomic, strong, readonly) RACCommand *executeAgreementCommand;

// 商品贷申请入口
- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel loanType:(MSFLoanType *)loanType barcode:(MSFBarcode *)barcode;

@end
