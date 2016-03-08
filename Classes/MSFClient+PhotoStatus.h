//
//	MSFClient+PhotoStatus.h
//	Cash
//
//	Created by xbm on 15/6/11.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (PhotoStatus)

- (RACSignal *)updateBankCardAvatarWithFileURL:(NSURL *)URL ownURL:(NSURL *)ownURL __deprecated;

@end
