//
//  MSFFaceMask.h
//  Finance
//
//  Created by xbm on 15/12/28.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class RACCommand;
@class MSFAttachment;

__attribute__((deprecated("This class is unavailable")))

@interface MSFFaceMaskViewModel : RVMViewModel

@property (nonatomic, copy) NSString *imgFilePath;
@property (nonatomic, strong) MSFAttachment *attachment;

@property (nonatomic, strong, readonly) RACCommand *takeFaceMaskPhotoCommand;

@property (nonatomic, strong, readonly) RACCommand *getFaceMaskInfoCommand;

@property (nonatomic, strong, readonly) RACCommand *updateImageCommand;

@property (nonatomic, weak, readonly) id <MSFApplicationViewModel> applicationViewModel;

- (instancetype)initWithApplicationViewModel:(id<MSFApplicationViewModel>)applicaitonViewModel;

@end
