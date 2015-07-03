//
// MSFLChannel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MTLModel.h"
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@class NSBundle;

@interface MSFLChannel : MTLModel <MTLFMDBSerializing>

@property(nonatomic,copy,readonly) NSString *channel;
@property(nonatomic,copy,readonly) NSString *appVersion;

- (instancetype)initWithBundle:(NSBundle *)bundle;

+ (instancetype)currentChannel;

@end
