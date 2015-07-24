//
// MSFViewModelServices.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFClient;
@class MSFServer;

@protocol MSFViewModelServices <NSObject>

- (void)pushViewModel:(id)viewModel;
- (void)presentViewModel:(id)viewModel;
- (MSFClient *)httpClient;
- (MSFServer *)server;

@end
