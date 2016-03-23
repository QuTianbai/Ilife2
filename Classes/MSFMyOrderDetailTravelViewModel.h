//
//  MSFMyOrderDetailTravelViewModel.h
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFMyOrderDetailTravelViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *departureTime;
@property (nonatomic, copy, readonly) NSString *returnTime;
@property (nonatomic, copy, readonly) NSString *isNeedVisa;
@property (nonatomic, copy, readonly) NSString *origin;
@property (nonatomic, copy, readonly) NSString *destination;
@property (nonatomic, assign, readonly) int travelNum;
@property (nonatomic, assign, readonly) int travelKidsNum;
@property (nonatomic, copy, readonly) NSString *travelType;

- (instancetype)initWithModel:(id)model;

@end
