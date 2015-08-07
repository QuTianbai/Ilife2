//
// MSFViewModelServices.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFClient;
@class MSFServer;
@class RACSignal;

@protocol MSFViewModelServices <NSObject>

- (void)pushViewModel:(id)viewModel;
- (void)popViewModel;
- (void)presentViewModel:(id)viewModel;
- (MSFClient *)httpClient;
- (MSFServer *)server;
- (RACSignal *)fetchLocationWithLatitude:(double)latitude longitude:(double)longitude;

@end
