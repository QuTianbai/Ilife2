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
	_pending = NO;
	_services = services;
	_model = [[MSFApplicationForms alloc] init];
	_markets = [[MSFMarkets alloc] init];
	_currentAddress = [[MSFAddress alloc] init];
	_workAddress = [[MSFAddress alloc] init];

	self.updatedContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFAFViewModel updatedContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		if (!self.services.httpClient.isAuthenticated) return;
		// 获取申请的产品线信息
		[[self.services.httpClient fetchCheckEmploeeWithProductCode:@"1101"] subscribeNext:^(MSFMarkets *markets) {
			if (self.markets.teams.count == 0) {
				[self.markets mergeValuesForKeysFromModel:markets];
			}
		} error:^(NSError *error) {
			NSLog(@"");
			[SVProgressHUD dismiss];
		}];
		// 申请单列表获取银行卡，如果存在多张银行卡在API返回的时候第一张就是主卡
		RACSignal *signal = [[self.services.httpClient fetchBankCardList].collect replayLazily];
		[signal subscribeNext:^(id x) {
			for (MSFBankCardListModel *ob in x) {
				self.master = NO;
				if ([ob isEqual:[NSNull null]]) {
					//self.master = NO;
					return ;
				} else {
					self.masterBankCardNO = ob.bankCardNo;
					self.masterbankInfo = [NSString stringWithFormat:@"%@(%@)", ob.bankName, ob.bankCardNo];
					self.master = YES;
					break;
				}
			}
			
		}error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
		
		// 获取服务器存储的申请资料信息
		[[self.services.httpClient fetchApplyInfo]
		 subscribeNext:^(MSFApplicationForms *forms) {
			 [self.model mergeValuesForKeysFromModel:forms];
		} error:^(NSError *error) {
			[SVProgressHUD dismiss];
		}];
	}];
	
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
