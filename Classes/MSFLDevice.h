//
// MSFLDevice.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@class UIDevice;

@interface MSFLDevice : MTLModel <MTLJSONSerializing,MTLFMDBSerializing>

@property(nonatomic,readonly) NSString *manufacturer;
@property(nonatomic,readonly) NSString *brand;
@property(nonatomic,readonly) NSString *model;
@property(nonatomic,readonly) NSString *deviceID;

- (instancetype)initWithUDID:(NSString *)udid device:(UIDevice *)device;

+ (instancetype)currentDevice;

@end
