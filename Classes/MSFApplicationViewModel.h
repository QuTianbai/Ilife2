//
// MSFApplicationViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFFormsViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFFormsViewModel.h"

@protocol MSFApplicationViewModel <NSObject>

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) MSFFormsViewModel *formViewModel;

@end
