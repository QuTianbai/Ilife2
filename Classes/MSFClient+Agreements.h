//
// MSFClient+Agreements.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFProduct;
@class MSFApplyCashVIewModel;
@class MSFCartViewModel;

// 用户注册协议
extern NSString *const MSFAgreementTypeRegister;

// 关于我们
extern NSString *const MSFAgreementTypeAboutUs;

// 产品介绍
extern NSString *const MSFAgreementTypeIntro;

// 用户帮助
extern NSString *const MSFAgreementTypeHelper;

// 分店地址
extern NSString *const MSFAgreementTypeAddresses;

// 寿险计划协议
extern NSString *const MSFAgreementTypeInsurance;

@interface MSFClient (Agreements)

// Loan agreement.
//
// product - The apply product.
//
// Returns agreement HTML
- (RACSignal *)fetchLoanAgreementWithProduct:(MSFApplyCashVIewModel *)product;
- (RACSignal *)fetchLoanAgreementWithCart:(MSFCartViewModel *)product;

// fetch user agreement or static html
//
// type - html content type
//
// Returns HTML Content signal
- (RACSignal *)fetchUserAgreementWithType:(NSString *)type;

- (RACSignal *)fetchLifeLoanAgreement:(NSString *)productCode;

// 加载商品贷协议
- (RACSignal *)fetchCommodityLoanAgreement:(MSFCartViewModel *)productCode;

@end
