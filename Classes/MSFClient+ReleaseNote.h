//
// MSFClient+ReleaseNote.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (ReleaseNote)

/**
 *	获取服务器记录的版本信息
 *
 *	@return ReleaseNote
 */
- (RACSignal *)fetchReleaseNote;

@end
