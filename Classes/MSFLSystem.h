//
// MSFLSystem.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@class UIDevice;

@interface MSFLSystem : MTLModel <MTLFMDBSerializing>

@property(nonatomic,strong,readonly) NSString *platform;
@property(nonatomic,strong,readonly) NSString *version;
@property(nonatomic,strong,readonly) NSString *sdkVersion;
@property(nonatomic,strong,readonly) NSString *buildId;

- (instancetype)initWithDeivce:(UIDevice *)device;
+ (instancetype)currentSystem;

@end
