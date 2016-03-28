//
//  MSFAuthorizationViewModel.h
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

typedef NS_ENUM(NSInteger, AuthorizationChannel){
    AuthorizationChannelTaoBao = 0,
    AuthorizationChannelMessage,
    AuthorizationChannelJingDong
};

@class MSFApplicationViewModel;

@interface MSFAuthorizationViewModel : RVMViewModel

@property (nonatomic, weak,readonly) MSFApplicationViewModel *applicationViewModel;
@property (nonatomic, assign) AuthorizationChannel channel;

- (instancetype)initWithModel:(id)model Services:(id <MSFViewModelServices>)services;

@end
