//
// MSFProfessionalViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProfessionalViewModel.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <FMDB/FMDB.h>

#import "MSFSelectionViewController.h"

#import "MSFSelectKeyValues.h"
#import "MSFApplicationForms.h"
#import "MSFAreas.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient+ApplyCash.h"
#import "NSString+Matches.h"
#import "NSDate+UTC0800.h"

#import "MSFSelectionViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAddress.h"
#import "MSFProfessional.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFContact.h"
#import "MSFContactViewModel.h"

const NSInteger MSFProfessionalContactCellAdditionButton = 700;
const NSInteger MSFProfessionalContactCellRemoveButton  = 800;
const NSInteger MSFProfessionalContactCellRelationshipButton = 900;
const NSInteger MSFProfessionalContactCellRelationshipTextFeild  = 600;

@interface MSFProfessionalViewModel ( )

@property (nonatomic, strong) MSFFormsViewModel *formsViewModel;
@property (nonatomic, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, assign) NSUInteger modelHash;

@property (nonatomic, strong) MSFProfessional *model;
@property (nonatomic, strong, readwrite) NSArray *contacts;
@property (nonatomic, strong, readwrite) NSArray *viewModels;

@end

@implementation MSFProfessionalViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewModel `-dealloc`");
}

#pragma mark - NSObject

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_model = [self.services.httpClient user].professional.copy;
	_contacts = [self.services.httpClient user].contacts ?: @[[[MSFContact alloc] init]];
	_viewModels = [[NSArray alloc] init];
	NSArray *contacts = [self.services.httpClient.user contacts];
	if (!contacts) {
		self.viewModels = [self.viewModels arrayByAddingObject:[[MSFContactViewModel alloc] initWithModel:[[MSFContact alloc] init] Services:self.services]];
	} else {
		[contacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			self.viewModels = [self.viewModels arrayByAddingObject:[[MSFContactViewModel alloc] initWithModel:obj Services:self.services]];
		}];
	}
	
	RACChannelTo(self, normalIncome) = RACChannelTo(self.model, monthIncome);
	RACChannelTo(self, surplusIncome) = RACChannelTo(self.model, otherIncome);
	RACChannelTo(self, loan) = RACChannelTo(self.model, otherLoan);
	
	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:[self updateValidSignal] signalBlock:^RACSignal *(id input) {
		return [self updateSignal];
	}];
	
	RAC(self, code) = RACObserve(self.model, socialIdentity);
	RAC(self, identifier) = [RACObserve(self.model, socialIdentity) flattenMap:^RACStream *(id value) {
		return [self.services msf_selectValuesWithContent:@"social_status" keycode:value];
	}];
	_executeSocialStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services msf_selectKeyValuesWithContent:@"social_status"];
	}];
	RAC(self.model, socialIdentity) = [[self.executeSocialStatusCommand.executionSignals
		switchToLatest]
		map:^id(MSFSelectKeyValues *x) {
				return x.code;
		}];
	RAC(self, marriage) = [RACObserve(self.services.httpClient.user, maritalStatus) flattenMap:^RACStream *(id value) {
		return [self.services msf_selectValuesWithContent:@"marital_status" keycode:value];
	}];
	_executeMarriageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services msf_selectKeyValuesWithContent:@"marital_status"];
	}];
	RAC(self.services.httpClient.user, maritalStatus) = [[self.executeMarriageCommand.executionSignals
		switchToLatest]
		map:^id(MSFSelectKeyValues *x) {
				return x.code;
		}];
	
	_executeAddContact = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self AddContact:[[MSFContact alloc] init]];
	}];
	_executeRemoveContact = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		UIButton *button = (UIButton *)input;
		return [self removeContact:self.contacts[button.tag - MSFProfessionalContactCellRemoveButton]];
	}];
	
	_executeRelationshipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		UIButton *button = input;
		MSFContactViewModel *viewModel = self.viewModels[button.tag - MSFProfessionalContactCellRelationshipButton];
		return [viewModel.executeRelationshipCommand execute:nil];
	}];
	
  return self;
}

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = viewModel.services;
	_formsViewModel = viewModel;
	_forms = viewModel.model.copy;
	
	NSDictionary *addrDic = @{@"province" : _forms.workProvinceCode ?: @"",
														@"city" : _forms.workCityCode ?: @"",
														@"area" : _forms.workCountryCode ?: @""};
	MSFAddress *addressModel = [MSFAddress modelWithDictionary:addrDic error:nil];
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:addressModel services:_services];
	_address = _addressViewModel.address;
	
	[self initialize];
	
	_modelHash = _forms.hash;
	
	return self;
}

- (BOOL)edited {
	NSUInteger newHash = _forms.hash;
	return newHash != _modelHash;
}

#pragma mark - Private

- (void)commonInit {
	NSArray *degress = [MSFSelectKeyValues getSelectKeys:@"edu_background"];
	[degress enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:_forms.education]) {
			self.degrees = obj;
			*stop = YES;
		}
	}];
	NSArray *professions = [MSFSelectKeyValues getSelectKeys:@"social_status"];
	[professions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:_forms.socialStatus]) {
			self.socialstatus = obj;
			*stop = YES;
		}
	}];
	NSArray *industries = [MSFSelectKeyValues getSelectKeys:@"industry_category"];
	[industries enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:_forms.industry]) {
			self.industry = obj;
			*stop = YES;
		}
	}];
	NSArray *positions = [MSFSelectKeyValues getSelectKeys:@"professional"];
	[positions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:_forms.professional]) {
			self.professional = obj;
			*stop = YES;
		}
	}];
	NSArray *natures = [MSFSelectKeyValues getSelectKeys:@"unit_nature"];
	[natures enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:_forms.companyType]) {
			self.nature = obj;
			*stop = YES;
		}
	}];
}

- (void)resetProperties:(NSString *)newStatus {
	NSArray *status = @[@[@"SI01"], @[@"SI02", @"SI04"], @[@"SI03", @"SI05", @"SI06"]];
	BOOL reset = YES;
	for (int i = 0; i < 3; i++) {
		NSArray *arr = status[i];
		if ([arr containsObject:_forms.socialStatus] && [arr containsObject:newStatus]) {
			reset = NO;
			break;
		}
	}
	if (reset) {
		_forms.unitName = nil;
		_forms.empStandFrom = nil;
		_forms.programLength = nil;
		_forms.workStartDate = nil;
		_forms.department = nil;
		_forms.professional = nil;
		_forms.industry = nil;
		_forms.companyType = nil;
		_forms.workProvinceCode = nil;
		_forms.workCityCode = nil;
		_forms.workCountryCode = nil;
		_forms.empAdd = nil;
		_forms.unitAreaCode = nil;
		_forms.unitTelephone = nil;
		_forms.unitExtensionTelephone = nil;
		
		self.industry = nil;
		self.industryTitle = nil;
		self.nature = nil;
		self.natureTitle = nil;
		self.professional = nil;
		self.professionalTitle = nil;
		
		self.address = nil;
	}
}

- (void)initialize {
	[self commonInit];
	
	RAC(self, address) = RACObserve(self, addressViewModel.address);
	RAC(self, forms.workProvinceCode) = RACObserve(self, addressViewModel.provinceCode);
	RAC(self, forms.workCityCode) = RACObserve(self, addressViewModel.cityCode);
	RAC(self, forms.workCountryCode) = RACObserve(self, addressViewModel.areaCode);
	_executeAddressCommand = self.addressViewModel.selectCommand;
	
	@weakify(self)
	[RACObserve(self, degrees) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.forms.education = object.code;
		self.degreesTitle = object.text;
	}];
	
	[RACObserve(self, socialstatus) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		[self resetProperties:object.code];
		self.forms.socialStatus = object.code;
		self.socialstatusTitle = object.text;
	}];
	
	[RACObserve(self, industry) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.forms.industry = object.code;
		self.industryTitle = object.text;
	}];
	
	[RACObserve(self, nature) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.forms.companyType = object.code;
		self.natureTitle = object.text;
	}];
	
	[RACObserve(self, professional) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.forms.professional = object.code;
		self.professionalTitle = object.text;
	}];
	
	_startedWorkDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self startedWorkDateSignal:input];
	}];
	_startedDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self startedDateSignal:input];
	}];
	_enrollmentYearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self enrollmentYearSignal:input];
	}];
	_executeEducationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self educationSignal];
	}];
	_executeEducationCommand.allowsConcurrentExecution = YES;
	
	_executeSocialStatusCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self socialStatusSignal];
	}];
	_executeSocialStatusCommand.allowsConcurrentExecution = YES;
	
	_executeIndustryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self industrySignal];
	}];
	_executeIndustryCommand.allowsConcurrentExecution = YES;
	
	_executeNatureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self natureSignal];
	}];
	_executeNatureCommand.allowsConcurrentExecution = YES;
	
	_executePositionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self positionSignal];
	}];
	_executePositionCommand.allowsConcurrentExecution = YES;
	
	_executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self commitSignal];
	}];
}

- (RACSignal *)educationSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		NSString *jsonFile = @"";
		if ([self.socialstatus.code isEqualToString:@"SI01"]) {
			jsonFile = @"edu_background1";
		} else {
			jsonFile = @"edu_background";
		}
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:jsonFile]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.degrees = x;
			self.forms.education = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)socialStatusSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"social_status"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.socialstatus = x;
			self.forms.socialStatus = x.code;
			if ([x.code isEqualToString:@"SI01"] && ([self.degrees.code isEqualToString:@"LE09"] || [self.degrees.code isEqualToString:@"LE10"] || [self.degrees.code isEqualToString:@"LE11"])) {
				self.degrees = nil;
				self.degreesTitle = nil;
			}
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)industrySignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"industry_category"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.industry = x;
			self.forms.industry = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)natureSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"unit_nature"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.nature = x;
			self.forms.companyType = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)positionSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"professional"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.professional = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)commitSignal {
	MSFApplicationForms *forms = self.forms;
	if (forms.education.length == 0) {
		return [self errorSignal:@"请选择教育程度"];
	}
	if (forms.socialStatus.length == 0) {
		return [self errorSignal:@"请选择社会身份"];
	}
	if (forms.income.length == 0) {
		return [self errorSignal:@"请填写正确的每月税前工作收入"];
	}
	if (forms.otherIncome.length == 0) {
		return [self errorSignal:@"请填写正确的每月其它收入"];
	}
	if (forms.familyExpense.length == 0) {
		return [self errorSignal:@"请填写正确的每月其它贷款应还金额"];
	}
	if ([forms.socialStatus isEqualToString:@"SI01"]) {
		if (forms.unitName.length < 4) {
			return [self errorSignal:@"请填写正确的学校名称"];
		}
		if (forms.empStandFrom.length == 0) {
			return [self errorSignal:@"请选择入学年月"];
		}
		if (forms.programLength.intValue < 1 || forms.programLength.intValue > 8) {
			return [self errorSignal:@"请填写学制（1~8整数）"];
		}
	} else if ([forms.socialStatus isEqualToString:@"SI02"] || [forms.socialStatus isEqualToString:@"SI04"]) {
		if (!forms.workStartDate) {
			return [self errorSignal:@"请选择参加工作日期"];
		}
		if (forms.unitName.length < 4) {
			return [self errorSignal:@"请填写正确的工作单位名称"];
		}
		if (forms.industry.length == 0) {
			return [self errorSignal:@"请选择行业"];
		}
		if (forms.companyType.length == 0) {
			return [self errorSignal:@"请选择单位性质"];
		}
		if (forms.department.length == 0) {
			return [self errorSignal:@"请填写正确的就职部门全称"];
		}
		if (forms.professional.length == 0) {
			return [self errorSignal:@"请选择职业"];
		}
		if (!forms.empStandFrom) {
			return [self errorSignal:@"请选择入职年月"];
		}
		NSString *compareResult = [self compareDay:forms.empStandFrom earlierThanDay:forms.workStartDate];
		if (compareResult) {
			return [self errorSignal:compareResult];
		}
		BOOL length  = forms.unitAreaCode.length < 3 || forms.unitAreaCode.length > 4;
		BOOL length3 = forms.unitAreaCode.length == 3 && ![forms.unitAreaCode isShortAreaCode];
		BOOL scalar  = ![forms.unitAreaCode isScalar];
		if (length || length3 || scalar) {
			return [self errorSignal:@"请填写正确的单位座机区号"];
		}
		if (forms.unitTelephone.length < 7 || ![forms.unitTelephone isScalar]) {
			return [self errorSignal:@"请填写正确的单位座机号"];
		}
		if (forms.unitExtensionTelephone.length > 0 && (forms.unitExtensionTelephone.length > 5 || ![forms.unitExtensionTelephone isScalar])) {
			return [self errorSignal:@"请填写正确的单位电话分机号"];
		}
		if (forms.workProvinceCode.length == 0) {
			return [self errorSignal:@"请选择单位地址"];
		}
		if (forms.workCityCode.length == 0) {
			return [self errorSignal:@"请选择单位地址"];
		}
		if (forms.workCountryCode.length == 0) {
			return [self errorSignal:@"请选择单位地址"];
		}
		if (forms.empAdd.length < 3 || forms.empAdd.length > 40) {
			return [self errorSignal:@"请填写正确的单位详细地址"];
		}
	}
	
	[self.formsViewModel.model mergeValuesForKeysFromModel:_forms];
	return [self.formsViewModel submitUserInfoType:2];
}

- (RACSignal *)errorSignal:(NSString *)msg {
	return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:msg}]];
}

- (NSString *)compareDay:(NSString *)day1 earlierThanDay:(NSString *)day2 {
	NSArray *components1 = [day1 componentsSeparatedByString:@"-"];
	NSArray *components2 = [day2 componentsSeparatedByString:@"-"];
	if (components1.count != 2) {
		return @"请选择入职日期";
	}
	if (components2.count != 2) {
		return @"请选择参加工作日期";
	}
	if ([components1[0] integerValue] < [components2[0] integerValue]) {
		return @"入职日期不能早于参加工作日期";
	}
	if ([components1[0] integerValue] == [components2[0] integerValue] && [components1[1] integerValue] < [components2[1] integerValue]) {
		return @"入职日期不能早于参加工作日期";
	}
	return nil;
}

#pragma mark - Getter

- (RACSignal *)startedWorkDateSignal:(UIView *)aView {
	@weakify(self)
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate msf_date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-50];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[ActionSheetDatePicker
		 showPickerWithTitle:@""
		 datePickerMode:UIDatePickerModeDate
		 selectedDate:currentDate
		 minimumDate:minDate
		 maximumDate:maxDate
		 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
			 self.forms.workStartDate = [NSDateFormatter professional_stringFromDate:selectedDate];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.forms.empStandFrom = nil;
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:aView];
		return nil;
	}] replay];
}

- (RACSignal *)startedDateSignal:(UIView *)aView {
	@weakify(self)
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate msf_date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-50];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[ActionSheetDatePicker
		 showPickerWithTitle:@""
		 datePickerMode:UIDatePickerModeDate
		 selectedDate:currentDate
		 minimumDate:minDate
		 maximumDate:maxDate
		 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
			 self.forms.empStandFrom = [NSDateFormatter professional_stringFromDate:selectedDate];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.forms.empStandFrom = nil;
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:aView];
		return nil;
	}] replay];
}

- (RACSignal *)enrollmentYearSignal:(UIView *)aView {
	@weakify(self)
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate msf_date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-5];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[ActionSheetDatePicker
		 showPickerWithTitle:@""
		 datePickerMode:UIDatePickerModeDate
		 selectedDate:currentDate
		 minimumDate:minDate
		 maximumDate:maxDate
		 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
				self.forms.empStandFrom = [NSDateFormatter professional_stringFromDate:selectedDate];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.forms.empStandFrom = nil;
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:aView];
		return nil;
	}] replay];
}


#pragma mark - Private

- (RACSignal *)updateValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, identifier),
		RACObserve(self, normalIncome),
		RACObserve(self, surplusIncome),
		RACObserve(self, marriage),
	]
	reduce:^id(NSString *condition, NSString *email, NSString *phone, NSString *address, NSString *detail){
		return @(condition.length > 0 && email.length > 0 && address.length > 0 && detail.length > 0);
	}];
}

- (RACSignal *)updateSignal {
	return [[self.services.httpClient fetchUserInfo] flattenMap:^RACStream *(MSFUser *value) {
		MSFUser *model = [[MSFUser alloc] initWithDictionary:@{@keypath(MSFUser.new, professional): self.model} error:nil];
		[value mergeValueForKey:@keypath(MSFUser.new, professional) fromModel:model];
		return [[self.services.httpClient updateUser:value] doNext:^(id x) {
			[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, professional) fromModel:model];
		}];
	}];
}

#pragma mark - Public

- (NSInteger)numberOfSections {
	return  5 + self.contacts.count;
}

- (RACSignal *)removeContact:(MSFContact *)contact {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		self.contacts = [self.contacts mtl_arrayByRemovingObject:contact];
		self.viewModels = [self.viewModels mtl_arrayByRemovingObject:[[MSFContactViewModel alloc] initWithModel:contact Services:self.services]];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)AddContact:(MSFContact *)contact {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		self.contacts = [self.contacts arrayByAddingObject:contact];
		self.viewModels = [self.viewModels arrayByAddingObject:[[MSFContactViewModel alloc] initWithModel:contact Services:self.services]];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
