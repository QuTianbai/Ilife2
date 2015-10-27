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
#import "MSFClient+MSFApplyCash.h"
#import "NSString+Matches.h"
#import "NSDate+UTC0800.h"

#import "MSFSelectionViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAddress.h"

@interface MSFProfessionalViewModel ( )

@property (nonatomic, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFProfessionalViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewModel `-dealloc`");
}

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = formsViewModel.services;
	_formsViewModel = formsViewModel;
	
	MSFAddress *addressModel = [MSFAddress modelWithDictionary:@{@"province" : formsViewModel.model.workProvinceCode, @"city" : formsViewModel.model.workCityCode, @"area" : formsViewModel.model.workCountryCode} error:nil];
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:addressModel services:_services];
	_address = _addressViewModel.address;
	
	[self initialize];
	
	return self;
}

#pragma mark - Private

- (void)commonInit {
	NSArray *degress = [MSFSelectKeyValues getSelectKeys:@"edu_background"];
	[degress enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.formsViewModel.model.education]) {
			self.degrees = obj;
			*stop = YES;
		}
	}];
	NSArray *professions = [MSFSelectKeyValues getSelectKeys:@"social_status"];
	[professions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.formsViewModel.model.socialStatus]) {
			self.socialstatus = obj;
			*stop = YES;
		}
	}];
	NSArray *industries = [MSFSelectKeyValues getSelectKeys:@"industry_category"];
	[industries enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.formsViewModel.model.industry]) {
			self.industry = obj;
			*stop = YES;
		}
	}];
	NSArray *positions = [MSFSelectKeyValues getSelectKeys:@"professional"];
	[positions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.formsViewModel.model.professional]) {
			self.professional = obj;
			*stop = YES;
		}
	}];
	NSArray *natures = [MSFSelectKeyValues getSelectKeys:@"unit_nature"];
	[natures enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.formsViewModel.model.companyType]) {
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
		if ([arr containsObject:self.formsViewModel.model.socialStatus] && [arr containsObject:newStatus]) {
			reset = NO;
			break;
		}
	}
	if (reset) {
		self.formsViewModel.model.unitName = nil;
		self.formsViewModel.model.empStandFrom = nil;
		self.formsViewModel.model.programLength = nil;
		self.formsViewModel.model.workStartDate = nil;
		self.formsViewModel.model.income = nil;
		self.formsViewModel.model.otherIncome = nil;
		self.formsViewModel.model.familyExpense = nil;
		self.formsViewModel.model.department = nil;
		self.formsViewModel.model.professional = nil;
		self.formsViewModel.model.industry = nil;
		self.formsViewModel.model.companyType = nil;
		self.formsViewModel.model.workProvinceCode = nil;
		self.formsViewModel.model.workCityCode = nil;
		self.formsViewModel.model.workCountryCode = nil;
		self.formsViewModel.model.empAdd = nil;
		self.formsViewModel.model.unitAreaCode = nil;
		self.formsViewModel.model.unitTelephone = nil;
		self.formsViewModel.model.unitExtensionTelephone = nil;
		
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
	
	RAC(self, address) = RACObserve(self.addressViewModel, address);
	RAC(self.formsViewModel.model, workProvinceCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self.formsViewModel.model, workCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self.formsViewModel.model, workCountryCode) = RACObserve(self.addressViewModel, areaCode);
	_executeAddressCommand = self.addressViewModel.selectCommand;
	
	@weakify(self)
	[RACObserve(self, degrees) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.formsViewModel.model.education = object.code;
		self.degreesTitle = object.text;
	}];
	
	[RACObserve(self, socialstatus) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		[self resetProperties:object.code];
		self.formsViewModel.model.socialStatus = object.code;
		self.socialstatusTitle = object.text;
	}];
	
	[RACObserve(self, industry) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.formsViewModel.model.industry = object.code;
		self.industryTitle = object.text;
	}];
	
	[RACObserve(self, nature) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.formsViewModel.model.companyType = object.code;
		self.natureTitle = object.text;
	}];
	
	[RACObserve(self, professional) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.formsViewModel.model.professional = object.code;
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
			self.formsViewModel.model.education = x.code;
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
			self.formsViewModel.model.socialStatus = x.code;
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
			self.formsViewModel.model.industry = x.code;
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
			self.formsViewModel.model.companyType = x.code;
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
	MSFApplicationForms *forms = self.formsViewModel.model;
	if (forms.education.length == 0) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择教育程度"}]];
	}
	if (forms.socialStatus.length == 0) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择社会身份"}]];
	}
	if ([forms.socialStatus isEqualToString:@"SI01"]) {
		if (forms.unitName.length < 4) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的学校名称"}]];
		}
		if (forms.empStandFrom.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择入学年月"}]];
		}
		if (forms.programLength.intValue < 1 || forms.programLength.intValue > 8) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写学制（1~8整数）"}]];
		}
	} else if ([forms.socialStatus isEqualToString:@"SI02"] || [forms.socialStatus isEqualToString:@"SI04"]) {
		if (!forms.workStartDate) {
			return [RACSignal error:[NSError	errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择参加工作日期"}]];
		}
		if (forms.unitName.length < 4) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的工作单位名称"}]];
		}
		if (forms.industry.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择行业"}]];
		}
		if (forms.companyType.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择单位性质"}]];
		}
		if (forms.department.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的就职部门全称"}]];
		}
		if (forms.professional.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择职业"}]];
		}
		if (!forms.empStandFrom) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择入职年月"}]];
		}
		NSString *compareResult = [self compareDay:forms.empStandFrom earlierThanDay:forms.workStartDate];
		if (compareResult) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: compareResult}]];
		}
		if (forms.income.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的每月税前工作收入"}]];
		}
		if (forms.otherIncome.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的每月其它收入"}]];
		}
		if (forms.familyExpense.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的每月其它贷款应还金额"}]];
		}
		BOOL length  = forms.unitAreaCode.length < 3 || forms.unitAreaCode.length > 4;
		BOOL length3 = forms.unitAreaCode.length == 3 && ![forms.unitAreaCode isShortAreaCode];
		BOOL scalar  = ![forms.unitAreaCode isScalar];
		if (length || length3 || scalar) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的单位座机区号"}]];
		}
		if (forms.unitTelephone.length < 7 || ![forms.unitTelephone isScalar]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的单位座机号"}]];
		}
		if (forms.unitExtensionTelephone.length > 0 && (forms.unitExtensionTelephone.length > 5 || ![forms.unitExtensionTelephone isScalar])) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的单位电话分机号"}]];
		}
		if (forms.workProvinceCode.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择单位地址"}]];
		}
		if (forms.workCityCode.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择单位地址"}]];
		}
		if (forms.workCountryCode.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择单位地址"}]];
		}
		if (forms.empAdd.length < 3 || forms.empAdd.length > 40) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请填写正确的单位详细地址"}]];
		}
	}
	
	return [self.formsViewModel submitUserInfoType:2];
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
			 self.formsViewModel.model.workStartDate = [NSDateFormatter msf_stringFromDate2:selectedDate];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.formsViewModel.model.empStandFrom = nil;
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
			 self.formsViewModel.model.empStandFrom = [NSDateFormatter msf_stringFromDate2:selectedDate];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.formsViewModel.model.empStandFrom = nil;
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
				self.formsViewModel.model.empStandFrom = [NSDateFormatter msf_stringFromDate2:selectedDate];
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 self.formsViewModel.model.empStandFrom = nil;
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:aView];
		return nil;
	}] replay];
}

@end
