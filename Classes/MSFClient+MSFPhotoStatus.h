//
//	MSFClient+MSFPhotoStatus.h
//	Cash
//
//	Created by xbm on 15/6/11.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFPhotoStatus)

- (RACSignal *)updateBankCardAvatarWithFileURL:(NSURL *)URL ownURL:(NSURL *)ownURL;

@end
