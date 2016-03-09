//
//  MSFCreditViewModel.m
//  Finance
//
//  Created by Wyc on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Photos.h"

#import "MSFPhoto.h"
#import "MSFClient+Photos.h"

@interface MSFCreditViewModel ()

@property (nonatomic, strong, readwrite) NSString *action;
@property (nonatomic, weak) id <MSFViewModelServices>services;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSString *subtitle;

@property (nonatomic, strong, readwrite) NSString *repayAmmounts;
@property (nonatomic, strong, readwrite) NSString *applyAmounts;
@property (nonatomic, strong, readwrite) NSString *repayDates;

@property (nonatomic, strong, readwrite) NSArray *photos;

@property (nonatomic, assign, readwrite) MSFCreditStatus status;


@property (nonatomic, strong, readwrite) MSFPhoto *photo;
@property (nonatomic, strong, readwrite) NSString *groudTitle;

@end

@implementation MSFCreditViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _services = services;
    return self;
    
}

@end
