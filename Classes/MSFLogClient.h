//
// MSFLogClient.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFLSystem;
@class MSFLDevice;
@class MSFLChannel;
@class MSFLEvent;
@class RACSignal;
@class MSFClient;

@interface MSFLogClient : NSObject

@property(nonatomic,copy,readonly) NSString *path;
@property(nonatomic,copy,readonly) MSFLSystem *system;
@property(nonatomic,copy,readonly) MSFLDevice *device;
@property(nonatomic,copy,readonly) MSFLChannel *channel;
@property(nonatomic,copy,readonly) MSFClient *client;

//TODO: 设计把三个对方放在一个对象里，然后通过这个对象的dictionrayValue解析
@property(nonatomic,strong,readonly) NSDictionary *infoDictionary;

- (instancetype)initWithPath:(NSString *)path
  system:(MSFLSystem *)system
  device:(MSFLDevice *)device
  channel:(MSFLChannel *)channel;

- (void)addEvent:(MSFLEvent *)event;
- (NSArray *)events;
- (void)cleanup;

+ (instancetype)sharedClient;

- (RACSignal *)sendLogs;

@end
