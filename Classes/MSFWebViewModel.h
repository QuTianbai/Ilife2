//
// MSFWebViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@interface MSFWebViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL;

@end
