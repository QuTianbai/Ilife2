//
// MSFViewModelServices.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFClient;

@protocol MSFViewModelServices <NSObject>

- (void)pushViewModel:(id)viewModel;
- (MSFClient *)httpClient;

@end
