//
// MSFAgreement.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAgreement.h"
#import "MSFServer.h"
#import <libextobjc/extobjc.h>
#import "MSFProduct.h"
#import "MSFApplyList.h"

@implementation MSFAgreement

- (instancetype)initWithServer:(MSFServer *)server {
  return [super initWithDictionary:@{@keypath(self.server): server} error:nil];
}

- (NSURL *)userURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"agreement/user"];
}

- (NSURL *)loanURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"agreement/loan"];
}

- (NSURL *)aboutWeURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/about.htm"];
}

- (NSURL *)productURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/intro.htm"];
}

- (NSURL *)helpURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/help.htm"];
}

- (NSURL *)branchesURL {
  
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/branch.htm"];
}

- (NSURL *)registerURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"agreement.htm"];
}

- (NSURL *)lifeInsuranceURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"/msfinance/page/about/insuranceInfo.htm"];
}

- (NSURL *)loanAgreementURLWithProduct:(MSFProduct *)product {
	//TODO: 暂缺贷款协议地址格式,参见- (RACSignal *)fetchRepayURLWithAppliList:(MSFApplyList *)applylist;
	NSString *path = [NSString stringWithFormat:@"https://192.168.2.51:8443/msfinanceapi/v1/coresys/cont/contract/fineinfo?productId=%@",product.productId];
	return [NSURL URLWithString:path];
	//TODO: 协议server需要更新
	return [self.server.baseWebURL URLByAppendingPathComponent:path];
}

@end
