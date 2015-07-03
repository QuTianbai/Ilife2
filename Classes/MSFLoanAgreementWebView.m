//
//  MSFLoanAgreementWebView.m
//  Cash
//
//  Created by xbm on 15/6/4.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLoanAgreementWebView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@interface MSFLoanAgreementWebView ()

@property(weak, nonatomic) IBOutlet UIWebView *LoanAgreenmentWV;

@end

@implementation MSFLoanAgreementWebView

- (void)viewDidLoad {
  self.title = @"贷款协议";
  [self.LoanAgreenmentWV rac_liftSelector:@selector(loadHTMLString:baseURL:)
                    withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.loanAgreementSignal,[RACSignal return:nil]]]];
}

- (void)bindViewModel:(id)viewModel {
  
}

@end
