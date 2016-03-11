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
    @weakify (self)
//    [[self.didBecomeActiveSignal flattenMap:^RACStream *(id value) {
//        @strongify(self)
//        //[self.]
//    }];
//
    
    [RACObserve(self, status) subscribeNext:^(NSNumber *status) {
        @strongify(self)
        self.applyAmounts = @"10000";
        self.repayAmmounts = @"2000";
        self.repayDates = @"";
        switch (status.integerValue) {
            case MSFCreditInReview: {
                self.title = @"审核中";
                self.subtitle = @"审核已提交";
            } break;
            case MSFCreditConfirmation:{
                self.title = @"等待确认合同";
                self.subtitle = @"";
                self.action = @"确认合同";
            } break;
            default:
                break;
        }
        
    }];
    
}

@end
