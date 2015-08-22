//
//	MSFPersonalViewModel.m
//	Cash
//
//	Created by xutian on 15/6/13.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationshipViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplicationForms.h"
#import "MSFFormsViewModel.h"
#import "MSFClient+MSFApplyCash.h"
#import <UIKit/UIKit.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "NSString+Matches.h"

@interface MSFRelationshipViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFRelationshipViewModel

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formsViewModel = viewModel;
	_model = viewModel.model;
	_services = viewModel.services;
	[self initialize];
	
	@weakify(self)
	[RACObserve(self, marryValues) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.maritalStatus = object.code;
		self.marryValuesTitle = object.text;
		if ([object.code isEqualToString:@"MG02"]) {
				self.familyOneValues = [MTLJSONAdapter modelOfClass:MSFSelectKeyValues.class fromJSONDictionary:@{
					@"text": @"配偶",
					@"code": @"RF01",
					@"typeId": @"009"
				} error:nil];
		} else if ([object.code isEqualToString:@"MG01"] && [self.familyOneValues.code isEqualToString:@"RF01"]) {
			self.familyOneValues = nil;
		}
	}];
	[RACObserve(self, houseValues) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.houseType = object.code;
		self.houseValuesTitle = object.text;
	}];
	[RACObserve(self, familyOneValues) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.memberRelation = object.code;
		self.familyOneValuesTitle = object.text;
	}];
	[RACObserve(self, familyTwoValues) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.memberRelation2 = object.code;
		self.familyTwoValuesTitle = object.text;
	}];
	[RACObserve(self, otherOneValues) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.relation1 = object.code;
		self.otherOneValuesTitle = object.text;
	}];
	[RACObserve(self, otherTwoValues) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.relation2 = object.code;
		self.otherTwoValuesTitle = object.text;
	}];

	_executeMarryValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self marryValuesSignal];
	}];
	_executeMarryValuesCommand.allowsConcurrentExecution = YES;
	_executeHouseValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self houseValuesSignal];
	}];
	_executeHouseValuesCommand.allowsConcurrentExecution = YES;
	_executeFamilyOneValuesCommand = [[RACCommand alloc] initWithEnabled:[self familyOneValidSignal] signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self familyOneValuesSignal];
	}];
	_executeFamilyOneValuesCommand.allowsConcurrentExecution = YES;
	_executeFamilyTwoValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self familyTwoValuesSignal];
	}];
	_executeFamilyTwoValuesCommand.allowsConcurrentExecution = YES;
	_executeOtherOneValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self otherOneValuesSignal];
	}];
	_executeOtherOneValuesCommand.allowsConcurrentExecution = YES;
	_executeOtherTwoValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self otherTwoValuesSignal];
	}];
	_executeOtherTwoValuesCommand.allowsConcurrentExecution = YES;
  _executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self)
    self.model.applyStatus1 = @"1";
    return [self commitSignal];
  }];
	
	return self;
}

#pragma mark - Private

- (void)initialize {
	NSArray *marrages = [MSFSelectKeyValues getSelectKeys:@"marital_status"];
	[marrages enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.maritalStatus]) {
			self.marryValues = obj;
			*stop = YES;
		}
	}];
	NSArray *housevalues = [MSFSelectKeyValues getSelectKeys:@"housing_conditions"];
	[housevalues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.houseType]) {
			self.houseValues = obj;
			*stop = YES;
		}
	}];
	
	NSArray *familyOneValues = [MSFSelectKeyValues getSelectKeys:@"familyMember_type"];
	[familyOneValues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.memberRelation]) {
			self.familyOneValues = obj;
			*stop = YES;
		}
	}];
	NSArray *familyTwoValues = [MSFSelectKeyValues getSelectKeys:@"familyMember_type"];
	[familyTwoValues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.memberRelation2]) {
			self.familyTwoValues = obj;
			*stop = YES;
		}
	}];
	NSArray *otherRelations = [MSFSelectKeyValues getSelectKeys:@"relationship"];
	[otherRelations enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.relation1]) {
			self.otherOneValues = obj;
			*stop = YES;
		}
	}];
	NSArray *otherRelations2 = [MSFSelectKeyValues getSelectKeys:@"relationship"];
	[otherRelations2 enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.relation2]) {
			self.otherTwoValues = obj;
			*stop = YES;
		}
	}];
}

- (RACSignal *)marryValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"marital_status"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.marryValues = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)houseValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"housing_conditions"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.houseValues = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)familyOneValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"familyMember_type"]];
		if ([self.model.maritalStatus isEqualToString:@"MG01"]) {
			viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"familyMember_type2"]];
		}
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.familyOneValues = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)familyTwoValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"familyMember_type"]];
		if ([self.model.maritalStatus isEqualToString:@"MG02"] || [self.model.maritalStatus isEqualToString:@"MG01"]) {
			viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"familyMember_type2"]];
		}
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.familyTwoValues = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)otherOneValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"relationship"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.otherOneValues = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)otherTwoValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"relationship"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.otherTwoValues = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)commitValidSignal {
	return [RACSignal return:@YES];
}

- (RACSignal *)memberValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, hasMember2),
		RACObserve(self.model, memberName),
		RACObserve(self.model, memberRelation),
		RACObserve(self.model, memberCellNum),
		RACObserve(self.model, memberName2),
		RACObserve(self.model, memberRelation2),
		RACObserve(self.model, memberCellNum2),
	]
	reduce:^id(NSNumber *hasMember2, NSString *name, NSString *relation, NSString *phone, NSString *name2, NSString *relation2, NSString *phone2) {
		if (hasMember2.boolValue) {
			return @(name.length > 0 && relation.length > 0 && phone.length > 0 && name2.length > 0 && relation2.length > 0 && phone2.length > 0);
		} else {
			return @(name.length > 0 && relation.length > 0 && phone.length > 0);
		}
	}];
}

- (RACSignal *)contactValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, hasContact2),
		RACObserve(self.model, name1),
		RACObserve(self.model, relation1),
		RACObserve(self.model, phone1),
		RACObserve(self.model, name2),
		RACObserve(self.model, relation2),
		RACObserve(self.model, phone2),
	]
	reduce:^id(NSNumber *hasMember2, NSString *name, NSString *relation, NSString *phone, NSString *name2, NSString *relation2, NSString *phone2) {
		if (hasMember2.boolValue) {
			return @(name.length > 0 && relation.length > 0 && phone.length > 0 && name2.length > 0 && relation2.length > 0 && phone2.length > 0);
		} else {
			return @(name.length > 0 && relation.length > 0 && phone.length > 0);
		}
	}];
}

- (RACSignal *)commitSignal {
	return [self.formsViewModel submitSignalWithPage:4];
}

- (RACSignal *)familyOneValidSignal {
	return [RACSignal  combineLatest:@[RACObserve(self.model, maritalStatus)] reduce:^id(NSString *code) {
		return @(![code isEqualToString:@"MG02"]);
	}];
}

#pragma mark - Custom Accessors

- (NSString *)confirmMessage {
	__block NSString *usage;
	NSArray *items = [MSFSelectKeyValues getSelectKeys:@"moneyUse"];
	[items enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.usageCode]) {
			usage = obj.text;
		}
	}];
	NSString *message = [NSString stringWithFormat:@"贷款金额 %@元\n贷款期数 %@期\n贷款用途 %@\n预计每期还款金额 %@元 ",
		self.model.principal,
		self.model.tenor,
		usage,
		self.model.repayMoneyMonth
		];
	return message;
}

#pragma mark - private

- (NSString *)checkForm {
	
	if (self.model.maritalStatus.length == 0) {
		return @"请选择婚姻状况";
	}
	if (self.model.houseType.length == 0) {
		return @"请选择住房状况";
	}
	
	if (self.model.memberName.length == 0 && self.model.memberName2.length == 0) {
		return @"请输入至少一位家庭成员姓名";
	}
	
	if (self.model.memberRelation.length > 0 || self.model.memberName.length > 0 || self.model.memberCellNum.length > 0 || self.model.memberAddress.length > 0) {
		if (![self.model.memberName isChineseName]) {
			return @"请输入正确的家庭成员姓名";
		}
		if (self.model.memberRelation.length == 0) {
			return @"请选择家庭成员与申请人关系";
		}
		if (![self.model.memberCellNum isMobile]) {
			return @"请输入正确的家庭成员电话";
		}
		if (self.model.memberAddress.length > 0 && (self.model.memberAddress.length < 8 || self.model.memberAddress.length > 60)) {
			return @"请输入家庭成员现住所详细地址";
		}
	}
	
	if (self.hasMember2 && (self.model.memberRelation2.length > 0 || self.model.memberName2.length > 0 || self.model.memberCellNum2.length > 0 || self.model.memberAddress2.length > 0)) {
		if (![self.model.memberName2 isChineseName]) {
			return @"请输入正确的家庭成员二的姓名";
		}
		if (self.model.memberRelation2.length == 0) {
			return @"请选择家庭成员二与申请人关系";
		}
		if (![self.model.memberCellNum2 isMobile]) {
			return @"请输入正确的家庭成员二的电话";
		}
		if (self.model.memberAddress2.length > 0 && (self.model.memberAddress2.length < 8 || self.model.memberAddress2.length > 60)) {
			return @"请输入家庭成员二现住所详细地址";
		}
	}
	
	if (self.model.name1.length == 0 && self.model.name2.length == 0) {
		return @"请输入至少一位联系人姓名";
	}
	
	if (self.model.name1.length > 0 || self.model.relation1.length > 0 || self.model.phone1.length > 0) {
		if (self.model.name1.length == 0) {
			return @"请输入正确的其他联系人姓名";
		}
		if (self.model.relation1.length == 0) {
			return @"请选择联系人与申请人关系";
		}
		if (![self.model.phone1 isMobile]) {
			return @"请输入正确的其他联系人电话";
		}
	}
	
	if (self.hasContact2 && (self.model.name2.length > 0 || self.model.relation2.length > 0 || self.model.phone2.length > 0) && (self.model.name2.length == 0 || self.model.relation2.length == 0 || self.model.phone2.length == 0)) {
		return @"请填写完第二位联系人信息";
	}
	
	NSMutableArray *phoneArray = [NSMutableArray arrayWithArray:@[self.model.memberCellNum, self.model.phone1]];
	NSMutableArray *nameArray  = [NSMutableArray arrayWithArray:@[self.model.memberName, self.model.name1]];
	if (self.hasMember2) {
		[phoneArray addObject:self.model.memberCellNum2];
		[nameArray addObject:self.model.memberName2];
	}
	if (self.hasContact2) {
		[phoneArray addObject:self.model.phone2];
		[nameArray addObject:self.model.name2];
	}
	
	for (int i = 0 ; i < nameArray.count ; i ++) {
		for (int j = i + 1; j < nameArray.count; j++) {
			if ([nameArray[i] length] == 0) {
				continue;
			}
			if ([nameArray[i] isEqualToString:nameArray[j]]) {
				return @"家庭成员（或者其他联系人）之间姓名不能相同";
			}
		}
	}

	for (int i = 0 ; i < phoneArray.count ; i ++) {
		for (int j = i + 1; j < phoneArray.count; j++) {
			if ([phoneArray[i] length] == 0) {
				continue;
			}
			if ([phoneArray[i] isEqualToString:phoneArray[j]]) {
				return @"家庭成员（或者其他联系人）之间手机号不能相同";
			}
		}
	}
	
	return nil;
}

@end