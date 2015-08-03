//
// MSFProfessionalViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProfessionalViewModel.h"
#import <FMDB/FMDB.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
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
	
	_executeDepartmentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self departmentSignal];
	}];
	_executeDepartmentCommand.allowsConcurrentExecution = YES;
	
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

- (RACSignal *)departmentSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"professional"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.department = x;
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
	if ([self.model.education isEqualToString:@""]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择教育程度",
		}]];
	}
	if ([self.model.socialStatus isEqualToString:@""]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请选择社会身份",
		}]];
	} else if ([self.model.socialStatus isEqualToString:@"SI01"]) {
		if ([self.model.universityName isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入学校名称",
			}]];
		}
		if ([self.model.enrollmentYear isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择入学年份",
			}]];
		}
		if ([self.model.programLength isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择学制",
			}]];
		}
	} else if ([self.model.socialStatus isEqualToString:@"SI02"]) {
		if ([self.model.workingLength isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择工作年限",
			}]];
		}
		if ([self.model.company isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入单位全称",
			}]];
		}
		if ([self.model.industry isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择行业类别",
			}]];
		}
		
		if ([self.model.companyType isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择行业性质",
			}]];
		}
		if ([self.model.department isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入部门",
			}]];
		}
		if ([self.model.title isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择职位",
			}]];
		}
		if ([self.model.currentJobDate isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择入职时间",
			}]];
		}
		if (![[self.model.unitAreaCode stringByAppendingString:self.model.unitTelephone] isTelephone]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输正确的联系电话",
			}]];
		}
		if ([self.model.workProvince isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择入所在地区",
			}]];
		}
		if ([self.model.workTown isEqualToString:@""]) {
			return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入详细地址",
			}]];
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
