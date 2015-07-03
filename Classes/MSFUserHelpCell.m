//
//  MSFTheInterestRateCell.m
//  Cash
//
//  Created by xutian on 15/5/18.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFUserHelpCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@implementation MSFUserHelpCell

- (void)viewDidLoad {
  
  self.title = @"用户帮助";
  
  [_userHelpWebView
   rac_liftSelector:@selector(loadHTMLString:baseURL:)
   withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.usersAgreementSignal,[RACSignal return:nil]]]];

}

@end