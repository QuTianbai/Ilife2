//
//	MSFClient+MSFAdver.h
//	Cash
//
//	Created by xbm on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Adver)

- (RACSignal *)fetchAdverWithCategory:(NSString *)category;

@end
