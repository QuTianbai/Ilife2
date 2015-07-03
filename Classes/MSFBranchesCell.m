//
//  MSFVersionUpdate.m
//  Cash
//
//  Created by xutian on 15/5/18.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBranchesCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@implementation MSFBranchesCell

- (void)viewDidLoad {
  
  self.title = @"网点分布";
  
  [_branchWebView
   rac_liftSelector:@selector(loadHTMLString:baseURL:)
   withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.branchAgreementSignal,[RACSignal return:nil]]]];
  
}

@end