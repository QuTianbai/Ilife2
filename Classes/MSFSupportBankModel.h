//
//  MSFSupportBankModel.h
//  Finance
//
//  Created by Wyc on 16/3/16.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFObject.h"

@interface MSFSupportBankModel : MSFObject

@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *bankCode;
@property (nonatomic, assign, readonly) double singleAmountLimit;
@property (nonatomic, assign, readonly) double dayAmountLimit;
@property (nonatomic, copy, readonly) NSString *isMainCard;
@property (nonatomic, copy, readonly) NSString *picUrl;

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers;

@end
