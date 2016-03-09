//
// MSFCommodityViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFApplicationViewModel.h"

@class RACCommand;

__attribute__((deprecated("This class is unavailable. Please use the MSFCartViewModel class instead")))

// 商品编辑界面的ViewModel
@interface MSFCommodityCashViewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

// 申请订单号，社保贷默认申请流程中申请订单号为空字符串
@property (nonatomic, strong) NSString *applicationNo;

// 申请的产品类型: 社保贷/马上贷款/随借随还
@property (nonatomic, strong) MSFLoanType *loanType;

// 附件列表 <NSDictionary>
@property (nonatomic, strong) NSArray *accessories;

// 传入的二维码编码信息
@property (nonatomic, strong, readonly) NSString *barcode;

- (instancetype)initWithViewModel:(id)viewModel loanType:(MSFLoanType *)loanType barcode:(NSString *)barcode __deprecated_msg("Use initWithLoanType: barcode: services: intead");
- (instancetype)initWithLoanType:(MSFLoanType *)loanType barcode:(NSString *)barcode services:(id <MSFViewModelServices>)services;

@end
