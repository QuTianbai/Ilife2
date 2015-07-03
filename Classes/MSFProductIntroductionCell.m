//
//  MSFProductIntroductionCell.m
//  Cash
//
//  Created by xutian on 15/5/18.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProductIntroductionCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@implementation MSFProductIntroductionCell

- (void)viewDidLoad {
  
  self.title = @"产品介绍";
  
  [_productWebView
   rac_liftSelector:@selector(loadHTMLString:baseURL:)
   withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.productAgreementSignal,[RACSignal return:nil]]]];
}

@end