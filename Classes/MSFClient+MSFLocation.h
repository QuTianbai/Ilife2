//
//  MSFClient+MSFLocation.h
//  Finance
//
//  Created by xbm on 15/7/30.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"
#import <CoreLocation/CoreLocation.h>


@interface MSFClient (MSFLocation)

- (RACSignal *)fetchLocationAdress:(CLLocationCoordinate2D)coordinate;

@end
