//
// MSFWebViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@interface MSFWebViewModel : RVMViewModel

// viewModel URL load html
@property (nonatomic, strong, readonly) NSURL *URL;

// Create new viewModel
//
// URL - Use to load webview html
//
// return viewModel instance
- (instancetype)initWithURL:(NSURL *)URL;

@end
