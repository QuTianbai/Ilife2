//
//  MSFLocation.h
//  Finance
//
//  Created by xbm on 15/7/30.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol MSFLocationDelegate <NSObject>

- (void)getLocationCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface MSFLocation : NSObject

@property (nonatomic,assign) id<MSFLocationDelegate> delegate;

- (void)startLocation;

@end
