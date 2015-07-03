//
//  MSFAboutUsCell.m
//  Cash
//
//  Created by xutian on 15/5/18.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAboutUsCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@implementation MSFAboutUsCell

- (void)viewDidLoad {
  self.title = @"关于我们";

  [_aboutWebView
   rac_liftSelector:@selector(loadHTMLString:baseURL:)
   withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.aboutAgreementSignal,[RACSignal return:nil]]]];
}

@end