//
//  MSFDeviceGet.h
//  Finance
//
//  Created by xbm on 15/8/14.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	IPHONE4 = 1,
	IPHONE4S = 1 << 1,
	IPHONE5 = 1 << 2,
	IPHONE5C = 1 << 3,
	IPHONE5S = 1 << 4,
	IPHONE6 = 1 << 5,
	IPHONE6P = 1 << 6
}DeviceTypeNum;

typedef NS_ENUM(NSInteger, MsfScreenType) {
	MSF_SCREEN_UNKNOWN = 0,
	MSF_SCREEN_4 = 1,
	MSF_SCREEN_5 = 2,
	MSF_SCREEN_6 = 3,
	MSF_SCREEN_6P = 4
};

static const DeviceTypeNum litter6 = IPHONE4 | IPHONE4S | IPHONE5 | IPHONE5C |IPHONE5S;

static const DeviceTypeNum bigger6 = IPHONE6 | IPHONE6P;

@interface MSFDeviceGet : NSObject

+ (DeviceTypeNum)deviceNum;

+ (NSString *)imei;

MsfScreenType msf_getScreenType();

@end
