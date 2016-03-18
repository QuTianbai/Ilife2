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
#import "MSFAddress.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSString+Matches.h"
#import "NSDate+UTC0800.h"

#import "MSFSelectionViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFAddressCodes.h"
#import "MSFProfessional.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFContact.h"
#import "MSFContactViewModel.h"
#import "MSFPersonal.h"

const NSInteger MSFProfessionalContactCellAdditionButton = 700;
const NSInteger MSFProfessionalContactCellRemoveButton  = 800;
const NSInteger MSFProfessionalContactCellRelationshipButton = 900;
const NSInteger MSFProfessionalContactCellRelationshipTextFeild  = 600;
const NSInteger MSFProfessionalContactCellNameTextFeild = 500;
const NSInteger MSFProfessionalContactCellPhoneTextFeild = 400;
const NSInteger MSFProfessionalContactCellPhoneButton = 300;
const NSInteger MSFProfessionalContactCellAddressTextFeild = 200;
const NSInteger MSFProfessionalContactCellAddressSwitch = 100;

@interface MSFProfessionalViewModel ( )

@property (nonatomic, strong) MSFFormsViewModel *formsViewModel DEPRECATED_ATTRIBUTE;
@property (nonatomic, assign) NSUInteger modelHash DEPRECATED_ATTRIBUTE;

@property (nonatomic, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, strong) MSFProfessional *model;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, strong, readwrite) NSArray *viewModels;
@property (nonatomic, strong) NSString *maritalStatus;
@property (nonatomic, strong) NSString *jobCategoryCode;
@property (nonatomic, strong) NSString *jobNatureCode;
@property (nonatomic, strong) NSString *jobPositionCode;
@property (nonatomic, strong) NSString *qualificationCode;

@end

@implementation MSFProfessionalViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewModel `-dealloc`");
}

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel services:(id <MSFViewModelServices>)services {
  self = [self initWithServices:services];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	_model = [self.services.httpClient user].professional.copy;
	_contacts = [self.services.httpClient user].contacts ?: @[[[MSFContact alloc] init]];
	_viewModels = [[NSArray alloc] init];
	
	self.maritalStatus = [self.services.httpClient user].personal.maritalStatus;
	
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
	
	RACChannelTo(self, schoolName) = RACChannelTo(self.model, unitName);
	RACChannelTo(self, schoolDate) = RACChannelTo(self.model, empStandFrom);
	RACChannelTo(self, schoolLength) = RACChannelTo(self.model, lengthOfSchooling);
	
	RACChannelTo(self, jobName) = RACChannelTo(self.model, unitName);
	RACChannelTo(self, jobCategoryCode) = RACChannelTo(self.model, empType);
	RACChannelTo(self, jobNatureCode) = RACChannelTo(self.model, empStructure);
	RACChannelTo(self, jobDate) = RACChannelTo(self.model, workStartDate);
	
	RACChannelTo(self, jobPhone) = RACChannelTo(self.model, empPhone);
	RACChannelTo(self, jobExtPhone) = RACChannelTo(self.model, empPhoneExtNum);
	RACChannelTo(self, jobDetailAddress) = RACChannelTo(self.model, empAddr);
	RACChannelTo(self, jobPositionCode) = RACChannelTo(self.model, empPost);
	RACChannelTo(self, jobPositionDate) = RACChannelTo(self.model, empStandFrom);
	RACChannelTo(self, jobPositionDepartment) = RACChannelTo(self.model, empDepartment);
	
	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:[self updateValidSignal] signalBlock:^RACSignal *(id input) {
		return [self updateSignal];
	}];
	
	// 社会身份
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
	
	// 婚姻状态
	RAC(self, marriage) = [RACObserve(self, maritalStatus) flattenMap:^RACStream *(id value) {
		return [self.services msf_selectValuesWithContent:@"marital_status" keycode:value];
	}];
	_executeMarriageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services msf_selectKeyValuesWithContent:@"marital_status"];
	}];
	RAC(self, maritalStatus) = [[self.executeMarriageCommand.executionSignals
		switchToLatest]
		map:^id(MSFSelectKeyValues *x) {
				return x.code;
		}];
	// 联系人信息
	_executeAddContactCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self AddContact:[[MSFContact alloc] init]];
	}];
	_executeRemoveContactCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		UIButton *button = (UIButton *)input;
		return [self removeContact:self.contacts[button.tag - MSFProfessionalContactCellRemoveButton]];
	}];
	_executeRelationshipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		UIButton *button = input;
		MSFContactViewModel *viewModel = self.viewModels[button.tag - MSFProfessionalContactCellRelationshipButton];
		return [viewModel.executeRelationshipCommand execute:nil];
	}];
	_executeContactCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		UIButton *button = input;
		MSFContactViewModel *viewModel = self.viewModels[button.tag - MSFProfessionalContactCellPhoneButton];
		return [viewModel.executeSelectContactCommand execute:nil];
	}];
	
	// 教育信息
	_executeSchoolDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self enrollmentYearSignal:input];
	}];
	RAC(self, schoolDate) = [self.executeSchoolDateCommand.executionSignals switchToLatest];
	
	// 工作信息
	_executeJobDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self enrollmentYearSignal:input];
	}];
	RAC(self, jobDate) = [self.executeJobDateCommand.executionSignals switchToLatest];
	
	_executeIndustryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services msf_selectKeyValuesWithContent:@"industry_category"] doNext:^(MSFSelectKeyValues *x) {
			self.jobCategoryCode = x.code;
		}];
	}];
	RAC(self, jobCategory) = [RACObserve(self, jobCategoryCode) flattenMap:^id(id value) {
		return [self.services msf_selectValuesWithContent:@"industry_category" keycode:value];
	}];
	_executeNatureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services msf_selectKeyValuesWithContent:@"unit_nature"] doNext:^(MSFSelectKeyValues *x) {
			self.jobNatureCode = x.code;
		}];
	}];
	RAC(self, jobNature) = [RACObserve(self, jobNatureCode) flattenMap:^id(id value) {
		return [self.services msf_selectValuesWithContent:@"unit_nature" keycode:value];
	}];
	RAC(self, jobPosition) = [RACObserve(self, jobPositionCode) flattenMap:^RACStream *(id value) {
		return [self.services msf_selectValuesWithContent:@"professional" keycode:value];
	}];
	_executePositionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services msf_selectKeyValuesWithContent:@"professional"] doNext:^(MSFSelectKeyValues *x) {
			self.jobPositionCode = x.code;
		}];
	}];
	_executeJobPositionDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self enrollmentYearSignal:input withLimit:self.jobDate];
	}];
//	RAC(self, jobPositionDate) = [self.executeJobPositionDateCommand.executionSignals switchToLatest];
	
		NSDictionary *addr = @{
		@"province" : self.model.empProvinceCode ?: @"",
		@"city" : self.model.empCityCode ?: @"",
		@"area" : self.model.empZoneCode ?: @""
	};
    @weakify(self);
    RAC(self, jobPositionDate) = [[self.executeJobPositionDateCommand.executionSignals switchToLatest] merge:[RACObserve(self, jobDate) filter:^BOOL(id value) {
        @strongify(self);
        if (value && self.jobPositionDate) {
            NSDate *date1 = [NSDateFormatter msf_dateFromString:(NSString *)value];
            NSDate *date2 = [NSDateFormatter msf_dateFromString:(NSString *)self.jobPositionDate];
            if ([date1 timeIntervalSinceDate:date2] > 0) {
                return YES;
            } else {
                return NO;
            }
        }
        return NO;
    }]];
	MSFAddressCodes *addrModel = [MSFAddressCodes modelWithDictionary:addr error:nil];
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:addrModel services:_services];
	_address = _addressViewModel.address;
	RAC(self, model.empProvinceCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self, model.empCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self, model.empZoneCode) = RACObserve(self.addressViewModel, areaCode);
	RAC(self, model.empProvince) = RACObserve(self.addressViewModel, provinceName);
	RAC(self, model.empCity) = RACObserve(self.addressViewModel, cityName);
	RAC(self, model.empZone) = RACObserve(self.addressViewModel, cityCode);
	RAC(self, jobAddress) = RACObserve(self.addressViewModel, address);
	_executeAddressCommand = self.addressViewModel.selectCommand;
	
	self.qualificationCode = @"LE06";
	RACChannelTo(self, qualificationCode) = RACChannelTo(self.model, qualification);
    return self;
}

- (void)updateViewModels {
	NSMutableArray *tempViewModels = [NSMutableArray arrayWithArray:self.viewModels];
	NSMutableArray *tempContacts = [NSMutableArray arrayWithArray:self.viewModels];
	MSFContact *content = [[MSFContact alloc] init];
	content.contactRelation = @"RF01";
	tempContacts[0] = content;
	tempViewModels[0] = [[MSFContactViewModel alloc] initWithModel:content Services:self.services];
	self.viewModels = tempViewModels;
	self.contacts = tempContacts;
}

- (void)updateViewModelsWithRelation:(NSString *)relation {
    
    NSMutableArray *tempViewModels = [NSMutableArray arrayWithArray:self.viewModels];
    NSMutableArray *tempContacts = [NSMutableArray arrayWithArray:self.viewModels];
    MSFContact *content = [[MSFContact alloc] init];
    if ([relation isEqualToString:@"20"]) {
        content.contactRelation = @"RF01";
    }
    tempContacts[0] = content;
    tempViewModels[0] = [[MSFContactViewModel alloc] initWithModel:content Services:self.services];
    self.viewModels = tempViewModels;
    self.contacts = tempContacts;
}

#pragma mark - Private

- (RACSignal *)enrollmentYearSignal:(UIView *)aView {
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
			 [subscriber sendNext:[NSDateFormatter professional_stringFromDate:selectedDate]];
			 [subscriber sendCompleted];
		 }
		 cancelBlock:^(ActionSheetDatePicker *picker) {
			 [subscriber sendNext:nil];
			 [subscriber sendCompleted];
		 }
		 origin:aView];
		return nil;
	}]
	replay];
}

- (RACSignal *)enrollmentYearSignal:(UIView *)aView withLimit:(NSString *)jobDate {
	[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDate *currentDate = [NSDate msf_date];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setYear:-5];
			NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
			if (jobDate) {
					minDate = [NSDateFormatter msf_dateFromString:self.jobDate];
			}
			[comps setYear:5];
			[ActionSheetDatePicker
			 showPickerWithTitle:@""
			 datePickerMode:UIDatePickerModeDate
			 selectedDate:currentDate
			 minimumDate:minDate
			 maximumDate:nil
			 doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
					 [subscriber sendNext:[NSDateFormatter professional_stringFromDate:selectedDate]];
					 [subscriber sendCompleted];
			 }
			 cancelBlock:^(ActionSheetDatePicker *picker) {
					 [subscriber sendNext:nil];
					 [subscriber sendCompleted];
			 }
			 origin:aView];
			return nil;
	}]
	replay];
}

#pragma mark - Private

- (RACSignal *)updateValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, identifier),
		RACObserve(self, normalIncome),
		RACObserve(self, surplusIncome),
		RACObserve(self, marriage),
	]
	reduce:^id(NSString *condition, NSString *email, NSString *phone, NSString *address){
		return @(condition.length > 0 && email.length > 0 && address.length > 0);
	}];
}

- (RACSignal *)updateSignal {
    if ([self.code isEqualToString:@"SI02"] || [self.code isEqualToString:@"SI04"]) {
        if (self.jobPosition.length == 0) {
            NSError *error = [NSError errorWithDomain:@"MSFProfessionalViewModel" code:0 userInfo:@{
                                                                                                    NSLocalizedFailureReasonErrorKey: @"请填写职业",
                                                                                                    }];
            return [RACSignal error: error];
        } else if (self.jobPositionDepartment.length == 0) {
            NSError *error = [NSError errorWithDomain:@"MSFProfessionalViewModel" code:0 userInfo:@{
                                                                                                    NSLocalizedFailureReasonErrorKey: @"请填写部门",
                                                                                                    }];
            return [RACSignal error: error];
        } else if (self.jobPositionDate.length == 0) {
            NSError *error = [NSError errorWithDomain:@"MSFProfessionalViewModel" code:0 userInfo:@{
                                                                                                    NSLocalizedFailureReasonErrorKey: @"请填写入职日期",
                                                                                                    }];
            
            return [RACSignal error: error];
        }        
    }

	__block NSError *error = nil;
	[self.viewModels enumerateObjectsUsingBlock:^(MSFContactViewModel *obj, NSUInteger idx, BOOL *stop) {
		if (!obj.isValid) {
			error = [NSError errorWithDomain:@"MSFProfessionalViewModelDomain" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请填写完整联系人信息"
			}];
			*stop = YES;
		}
	}];
	if (error) return [RACSignal error:error];
	return [[self.services.httpClient fetchUserInfo] flattenMap:^RACStream *(MSFUser *user) {
		MSFPersonal *personal = [[MSFPersonal alloc] initWithDictionary:@{@keypath(MSFPersonal.new, maritalStatus): self.maritalStatus} error:nil];
		[user.personal mergeValueForKey:@keypath(MSFPersonal.new, maritalStatus) fromModel:personal];
		
		NSArray *contacts = [self.viewModels.rac_sequence map:^id(MSFContactViewModel *value) {
			return value.model;
		}].array;
		
		MSFUser *model = [[MSFUser alloc] initWithDictionary:@{
			@keypath(MSFUser.new, professional): self.model,
			@keypath(MSFUser.new, personal): user.personal,
			@keypath(MSFUser.new, contacts): contacts
		} error:nil];
		[user mergeValueForKey:@keypath(MSFUser.new, professional) fromModel:model];
		[user mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
		[user mergeValueForKey:@keypath(MSFUser.new, contacts) fromModel:model];
		
		return [[self.services.httpClient updateUser:user] doNext:^(id x) {
			[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, professional) fromModel:model];
			[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
			[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, contacts) fromModel:model];
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
