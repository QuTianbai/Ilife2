//
// MSFWebViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFWebViewModel.h"
#import "MSFClient+Agreements.h"

@interface MSFWebViewModel ()

@property (nonatomic, strong) NSString *agreementType;

@end

@implementation MSFWebViewModel

- (instancetype)initWithServices:(id <MSFViewModelServices>)services type:(NSString *)agreementType {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_agreementType = agreementType;
  
  return self;
}

- (RACSignal *)HTMLSignal {
	return [self.services.httpClient fetchUserAgreementWithType:self.agreementType];
}

@end
