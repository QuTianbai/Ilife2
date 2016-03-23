//
// MSFClient+Wallet.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Wallet)

// 获取额度信息，信用钱包内容信息
- (RACSignal *)fetcchWallet;

@end
