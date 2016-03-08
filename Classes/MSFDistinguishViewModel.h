//
// MSFDistinguishViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFApplicationViewModel.h"

@class RACCommand;

__attribute__((deprecated("This class is unavailable")))

@interface MSFDistinguishViewModel : RVMViewModel

@property (nonatomic, strong) RACCommand *executeInventoryCommand;

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicationViewModel;

@end
