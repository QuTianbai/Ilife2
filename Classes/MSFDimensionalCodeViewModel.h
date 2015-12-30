//
// MSFDimensionalCodeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFDimensionalCodeViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *dismensionalCode;
@property (nonatomic, strong, readonly) NSURL *dismensionalCodeURL;

- (instancetype)initWithModel:(id)model;

@end
