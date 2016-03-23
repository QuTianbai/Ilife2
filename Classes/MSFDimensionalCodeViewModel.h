//
// MSFDimensionalCodeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class MSFOrderDetail;
@class MSFPayment;

@interface MSFDimensionalCodeViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;
@property (nonatomic, strong, readonly) NSString *timist;
@property (nonatomic, strong, readonly) NSString *dismensionalCode;
@property (nonatomic, strong, readonly) NSURL *dismensionalCodeURL;
@property (nonatomic, strong, readonly) RACSignal *invalidSignal;

- (instancetype)initWithModel:(id)model __deprecated_msg("Use `-initWithPayment:order: instead");

- (instancetype)initWithPayment:(MSFPayment *)payment order:(MSFOrderDetail *)order;

@end
