//
// MSFProfessionalViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProfessionalViewModel.h"
#import <FMDB/FMDB.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplicationForms.h"
#import "MSFAreas.h"
#import "MSFClient+MSFApplyCash.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSString+Matches.h"
#import "MSFFormsViewModel.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFAddressViewModel.h"
#import "NSString+Matches.h"

@interface MSFProfessionalViewModel ( )

@property (nonatomic, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFProfessionalViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewModel `-dealloc`");
}

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel  {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = formsViewModel.services;
	_formsViewModel = formsViewModel;
	_model = formsViewModel.model;
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:formsViewModel.workAddress services:formsViewModel.services];
	[self initialize];
	
	return self;
}

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel addressViewModel:(MSFAddressViewModel *)addressViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = formsViewModel.services;
	_formsViewModel = formsViewModel;
	_model = formsViewModel.model;
	_addressViewModel = addressViewModel;
	[self initialize];
	
	return self;
}

#pragma mark - Private

- (void)commonInit {
	NSArray *degress = [MSFSelectKeyValues getSelectKeys:@"edu_background"];
	[degress enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.education]) {
			self.degrees = obj;
			*stop = YES;
		}
	}];
	NSArray *professions = [MSFSelectKeyValues getSelectKeys:@"social_status"];
	[professions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.socialStatus]) {
			self.socialstatus = obj;
			*stop = YES;
		}
	}];
	NSArray *seniorities = [MSFSelectKeyValues getSelectKeys:@"service_year"];
	[seniorities enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.workingLength]) {
			self.seniority = obj;
			*stop = YES;
		}
	}];
	NSArray *industries = [MSFSelectKeyValues getSelectKeys:@"industry_category"];
	[industries enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.industry]) {
			self.industry = obj;
			*stop = YES;
		}
	}];
	NSArray *positions = [MSFSelectKeyValues getSelectKeys:@"position"];
	[positions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.title]) {
			self.position = obj;
			*stop = YES;
		}
	}];
	NSArray *natures = [MSFSelectKeyValues getSelectKeys:@"unit_nature"];
	[natures enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.companyType]) {
			self.nature = obj;
			*stop = YES;
		}
	}];
	NSArray *eductionalSystme = [MSFSelectKeyValues getSelectKeys:@"school_system"];
	[eductionalSystme enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.programLength]) {
			self.eductionalSystme = obj;
			*stop = YES;
		}
	}];
}

- (void)initialize {
	[self commonInit];
	RAC(self, address) = RACObserve(self.addressViewModel, address);
	RAC(self.model, currentAddress) = RACObserve(self.addressViewModel, address);
	RAC(self.model, workProvince) = RACObserve(self.addressViewModel, provinceName);
	RAC(self.model, workProvinceCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self.model, workCity) = RACObserve(self.addressViewModel, cityName);
	RAC(self.model, workCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self.model, workCountry) = RACObserve(self.addressViewModel, areaName);
	RAC(self.model, workCountryCode) = RACObserve(self.addressViewModel, areaCode);
	
	_executeAddressCommand = self.addressViewModel.selectCommand;
	
	RACChannelTo(self, school) = RACChannelTo(self.model, universityName);
	RACChannelTo(self, enrollmentYear) = RACChannelTo(self.model, enrollmentYear);
	RACChannelTo(self, startedDate) = RACChannelTo(self.model, currentJobDate);
	RACChannelTo(self, company) = RACChannelTo(self.model, company);
	RACChannelTo(self, unitAreaCode) = RACChannelTo(self.model, unitAreaCode);
	RACChannelTo(self, unitTelephone) = RACChannelTo(self.model, unitTelephone);
	RACChannelTo(self, unitExtensionTelephone) = RACChannelTo(self.model, unitExtensionTelephone);
	
	@weakify(self)
	
	[RACObserve(self, degrees) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.education = object.code;
		self.degreesTitle = object.text;
	}];
	
	[RACObserve(self, socialstatus) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.socialStatus = object.code;
		self.socialstatusTitle = object.text;
	}];
	
	[RACObserve(self, eductionalSystme) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.programLength = object.code;
		self.eductionalSystmeTitle = object.text;
	}];
	
	[RACObserve(self, seniority) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.workingLength = object.code;
		self.seniorityTitle = object.text;
	}];
	
	[RACObserve(self, industry) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.industry = object.code;
		self.industryTitle = object.text;
	}];
	
	[RACObserve(self, nature) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.companyType = object.code;
		self.natureTitle = object.text;
	}];
  
  RACChannelTo(self, departmentTitle) = RACChannelTo(self.model, department);
	
	[RACObserve(self, position) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.title = object.code;
		self.positionTitle = object.text;
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
	
	_executeEductionalSystmeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self eductionalSystmeSignal];
	}];
	_executeEductionalSystmeCommand.allowsConcurrentExecution = YES;
	
	_executeWorkingLengthCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self workingLengthSignal];
	}];
	_executeWorkingLengthCommand.allowsConcurrentExecution = YES;
	
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
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"edu_background"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.degrees = x;
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
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.socialstatus = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)eductionalSystmeSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"school_system"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.eductionalSystme = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)workingLengthSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"service_year"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.seniority = x;
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
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.industry = x;
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
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.nature = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)positionSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"position"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.position = x;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)commitSignal {
	if ([self.model.education isEqualToString:@""] || self.model.education == nil) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择教育程度",
		}]];
	}
	if ([self.model.socialStatus isEqualToString:@""] || self.model.socialStatus == nil) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择社会身份",
		}]];
	} else if ([self.model.socialStatus isEqualToString:@"SI01"]) {
		if (self.model.universityName.length == 0 || ![self.model.universityName isChineseName] || self.model.universityName.length < 4) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入学校全称",
			}]];
		}
		if ([self.model.enrollmentYear isEqualToString:@""] || self.model.enrollmentYear == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择入学年份",
			}]];
		}
		if ([self.model.programLength isEqualToString:@""] || self.model.programLength == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择学制",
			}]];
		}
	} else if ([self.model.socialStatus isEqualToString:@"SI02"]) {
		if ([self.model.workingLength isEqualToString:@""] || self.model.workingLength == nil) {
			return [RACSignal error:[NSError	errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择工作年限",
			}]];
		}
		if (self.model.company.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入当前就职单位全称",
			}]];
		}
		if (![self.model.company isChineseName] || self.model.company.length < 4 || self.model.company.length > 20) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的当前就职单位全称"}]];
		}
		if ([self.model.industry isEqualToString:@""] || self.model.industry == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择行业类别",
			}]];
		}
		if ([self.model.companyType isEqualToString:@""] || self.model.companyType == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择行业性质",
			}]];
		}
		if (self.model.department.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入当前就职部门全称"}]];
		}
		if (self.model.department.length > 0 && ![self.model.department isChineseName]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入正确的当前就职部门全称",
			}]];
		}
		if ([self.model.title isEqualToString:@""] || self.model.title == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择职位",
			}]];
		}
		if ([self.model.currentJobDate isEqualToString:@""] || self.model.currentJobDate == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择入职时间",
			}]];
		}
		if (self.model.unitAreaCode.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入单位电话区号"}]];
		}
		if (self.model.unitAreaCode.length == 3) {
			NSArray *validArea = @[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"];
			if (![validArea containsObject:self.model.unitAreaCode]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的单位电话区号"}]];
			}
		} else if (self.model.unitAreaCode.length > 4 || ![self.model.unitAreaCode isScalar]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的单位电话区号"}]];
		}
		if (self.model.unitTelephone.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入单位座机号码"}]];
		}
		if (![[self.model.unitAreaCode stringByAppendingString:self.model.unitTelephone] isTelephone] || self.model.unitAreaCode == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入正确的单位座机号码",
			}]];
		}
		if (self.model.unitExtensionTelephone.length > 0 && (self.model.unitExtensionTelephone.length > 4 || ![self.model.unitExtensionTelephone isScalar])) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的单位电话分机号"}]];
		}
		if ([self.model.workProvinceCode isEqualToString:@""] || self.model.workProvinceCode == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择单位地址",
	    }]];
		}
		if ([self.model.workProvince isEqualToString:@""] || self.model.workProvince == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择单位地址",
			}]];
		}
		if ([self.model.workCityCode isEqualToString:@""] || self.model.workCityCode == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择单位地址",
			}]];
		}
		if ([self.model.workCity isEqualToString:@""] || self.model.workCity == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择单位地址",
			}]];
		}
		if ([self.model.workCountryCode isEqualToString:@""] || self.model.workCountryCode == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			  NSLocalizedFailureReasonErrorKey: @"请选择单位地址",
			}]];
		}
		if ([self.model.workCountry isEqualToString:@""] || self.model.workCountry == nil) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择单位地址",
			}]];
		}
		if (self.model.workTown.length == 0) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入详细的地址信息"}]];
		}
		if (self.model.workTown.length > 0 && (self.model.workTown.length < 4 || self.model.workTown.length > 40)) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入正确的详细地址"}]];
		}
	}
	
	return [self.formsViewModel submitSignalWithPage:3];
}

- (RACSignal *)commitValidSignal {
	return [[RACSignal
		combineLatest:@[
			[self	 studentValidSignal],
			[self staffMemberValidSignal],
			[self freelanceSignal]
		]]
		or];
}

- (RACSignal *)freelanceSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self.model, socialStatus),
		RACObserve(self.model, education),
	]
	reduce:^id(NSString *social, NSString *education) {
		return @([social isEqualToString:@"SI03"] && education.length > 0);
	}];
}

- (RACSignal *)studentValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self.model, socialStatus),
		RACObserve(self.model, universityName),
		RACObserve(self.model, programLength),
		RACObserve(self.model, enrollmentYear),
	]
	 reduce:^id (NSString *social, NSString *universityName, NSString *programLength, NSString *enrollmentYear) {
		return @([social isEqualToString:@"SI01"] && universityName.length != 0 && programLength.length != 0 && enrollmentYear.length != 0);
	 }];
}

- (RACSignal *)staffMemberValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self.model, socialStatus),
		RACObserve(self.model, company),
		RACObserve(self.model, industry),
		RACObserve(self.model, companyType),
		
		RACObserve(self.model, department),
		RACObserve(self.model, title),
		RACObserve(self.model, currentJobDate),
		
		RACObserve(self.model, unitAreaCode),
		RACObserve(self.model, unitTelephone),
		RACObserve(self.model, unitExtensionTelephone),
		
		RACObserve(self.model, workProvinceCode),
		RACObserve(self.model, workCityCode),
		RACObserve(self.model, workCountryCode),
		
		RACObserve(self.model, workTown)
	] reduce:^id( NSString *socail, NSString *company, NSString *industry, NSString *companyType, NSString *department, NSString *title, NSString *currentJobDate, NSString *unitAreaCode, NSString *unitTelephone, NSString *unitExtensionTelephone, NSString *workProvinceCode, NSString *workCityCode, NSString *workCountryCode, NSString *workTown) {
		return @(
			[socail isEqualToString:@"SI02"] &&
			company.length != 0 &&
			industry.length != 0 &&
			companyType.length != 0 &&
			department.length != 0 &&
			title.length != 0 &&
			currentJobDate.length != 0 &&
			unitAreaCode.length != 0 &&
			unitTelephone.length != 0 &&
			workProvinceCode.length != 0 &&
			workCityCode.length != 0 &&
			workCountryCode.length != 0 &&
			workTown.length != 0
		);
	}];
}

@end
