//
// MSFClozeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFClient;
@class MSFAddressViewModel;

@interface MSFClozeViewModel : RVMViewModel

/**
 *	The User realname, Identifier Card name
 */
@property (nonatomic, strong) NSString *name;

/**
 *	identfier Card no
 */
@property (nonatomic, strong) NSString *card;

/**
 *	The identifer Card invalid time
 */
@property (nonatomic, strong) NSDate *expired;
@property (nonatomic, strong) NSString *expired1;

/**
 *	The bank name
 */
@property (nonatomic, strong) NSString *bankName;
@property (nonatomic, strong) NSString *bankCode;

/**
 *	The bank no
 */
@property (nonatomic, strong) NSString *bankNO;

/**
 *	The bank Address String value compose with `province city area`
 */
@property (nonatomic, strong) NSString *bankAddress;

/**
 *	Execute Request Command
 */
@property (nonatomic, strong, readonly) RACCommand *executeAuth;

/**
 *	Execute Select Address Command
 */
@property (nonatomic, strong, readonly) RACCommand *executeSelected;

// 身份证长期有效
@property (nonatomic, assign) BOOL permanent;

/**
 *	Identifier Card lifelong valid command
 */
@property (nonatomic, strong, readonly) RACCommand *executePermanent;

/**
 *	Address Select ViewModel
 */
@property (nonatomic, strong, readonly) MSFAddressViewModel *addressViewModel;

/**
 *	是否可以提交数据
 *
 *	@return @YES
 */
- (RACSignal *)authoriseValidSignal;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
