//
// MSFApplicationViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFViewModelServices.h"
@class MSFFormsViewModel;

@protocol MSFApplicationViewModel <NSObject>

@required

@property (nonatomic, strong) NSString *applicationNo;
@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) MSFFormsViewModel *formViewModel;

@optional

// 社保贷产品ID
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSArray *accessories;

@end
