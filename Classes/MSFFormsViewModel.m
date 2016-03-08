//
// MSFFormsViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"
#import <Mantle/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFPersonalViewModel.h"
#import "MSFProfessionalViewModel.h"
#import "MSFRelationshipViewModel.h"

#import "MSFApplicationForms.h"
#import "MSFClient+ApplyInfo.h"
#import "MSFClient+ApplyCash.h"
#import "MSFClient+Users.h"
#import "MSFResponse.h"
#import "MSFAddress.h"

#import "MSFMarkets.h"
#import "MSFClient+CheckEmploee2.h"
#import "MSFClient+BankCardList.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFBankCardListModel.h"
#import "MSFUser.h"

@interface MSFFormsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *bankCardArray;
@property (nonatomic, strong, readwrite) RACSubject *updatedContentSignal;
@property (nonatomic, strong, readwrite) MSFApplicationForms *model;
@property (nonatomic, strong, readwrite) MSFMarket *market;
@property (nonatomic, strong, readwrite) MSFMarkets *markets;
@property (nonatomic, strong, readwrite) MSFAddress *currentAddress;
@property (nonatomic, strong, readwrite) MSFAddress *workAddress;
@property (nonatomic, assign, readwrite) BOOL pending;
@property (nonatomic, weak, readwrite) id <MSFViewModelServices> services;

@end

@implementation MSFFormsViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	return self;
}

#pragma mark - Public

- (RACSignal *)submitUserInfoType:(int)infoType {
	return [self.services.httpClient submitUserInfo:self.model
																				 infoType:infoType];
}

- (void)setBankCardMasterDefult {
	self.masterBankCardNO = @"";
	self.master = NO;
}

@end
