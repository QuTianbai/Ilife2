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
#import <UIKit/UIKit.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFAddressViewModel.h"

@interface MSFProfessionalViewModel ( )

@property(nonatomic,weak) UIViewController *viewController;
@property(nonatomic,readonly) MSFAddressViewModel *addressViewModel;

@end

@implementation MSFProfessionalViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProfessionalViewModel `-dealloc`");
}

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel contentViewController:(UIViewController *)viewController {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formsViewModel = formsViewModel;
	_viewController = viewController;
	_model = formsViewModel.model;
	_addressViewModel = [[MSFAddressViewModel alloc] initWithWorkApplicationForm:self.model controller:self.viewController];
	[self initialize];
	
	RAC(self, address) = RACObserve(self.addressViewModel, address);
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
	
	[RACObserve(self, department) subscribeNext:^(MSFSelectKeyValues *object) {
		@strongify(self)
		self.model.department = object.code;
		self.departmentTitle = object.text;
	}];
	
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
	
	_executeEnrollmentYearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self enrollmentYearSignal];
	}];
	
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
	
	_executeStartedDateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self startedDateSignal];
	}];
//  _executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//    @strongify(self)
//    return [self commitSignal];
//  }];
	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:self.commitValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self commitSignal];
	}];
	
	return self;
}

#pragma mark - Private

- (void)initialize {
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
	NSArray *department = [MSFSelectKeyValues getSelectKeys:@"professional"];
	[department enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.department]) {
			self.department = obj;
			*stop = YES;
		}
	}];
}

- (RACSignal *)educationSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"edu_background"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"教育信息";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.degrees = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)socialStatusSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"social_status"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"社会身份";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.socialstatus = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)eductionalSystmeSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"school_system"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"学制";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.eductionalSystme = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)workingLengthSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"service_year"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"工作年限";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.seniority = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)enrollmentYearSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-50];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
	 
		[ActionSheetDatePicker
			showPickerWithTitle:@""
			datePickerMode:UIDatePickerModeDate
			selectedDate:[NSDate date]
			minimumDate:minDate
			maximumDate:maxDate
			doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
				self.enrollmentYear = [NSDateFormatter msf_stringFromDate:selectedDate];
				[subscriber sendNext:nil];
				[subscriber sendCompleted];
			}
			cancelBlock:^(ActionSheetDatePicker *picker) {
				self.enrollmentYear = [NSDateFormatter msf_stringFromDate:[NSDate date]];
				[subscriber sendNext:nil];
				[subscriber sendCompleted];
			}
			origin:self.viewController.view];
		return nil;
	}];
}

- (RACSignal *)industrySignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"industry_category"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"行业类别";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.industry = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)natureSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"unit_nature"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"行业性质";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.nature = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)departmentSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"professional"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"部门";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.department = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)positionSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"position"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"职位";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		@weakify(selectionViewController)
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			@strongify(selectionViewController)
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.position = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

- (RACSignal *)startedDateSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *currentDate = [NSDate date];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:0];
		NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		[comps setYear:-50];
		NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
	 
		[ActionSheetDatePicker
			showPickerWithTitle:@""
			datePickerMode:UIDatePickerModeDate
			selectedDate:[NSDate date]
			minimumDate:minDate
			maximumDate:maxDate
			doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
				self.startedDate = [NSDateFormatter msf_stringFromDate:selectedDate];
				[subscriber sendNext:nil];
				[subscriber sendCompleted];
			}
			cancelBlock:^(ActionSheetDatePicker *picker) {
				self.startedDate = [NSDateFormatter msf_stringFromDate:[NSDate date]];
				[subscriber sendNext:nil];
				[subscriber sendCompleted];
			}
			origin:self.viewController.view];
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
  }
  else if ([self.model.socialStatus isEqualToString:@"SI01"]) {
    if ([self.model.universityName isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请输入学校名称",
        }]];
    }
    if ([self.model.enrollmentYear isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择入学年份",
      }]];
    }
    if ([self.model.programLength isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择学制",
                                                                                                  }]];
    }
  } else if ([self.model.socialStatus isEqualToString:@"SI02"]) {
    if ([self.model.workingLength isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择g工作年限",
                                                                                                  }]];
    }
    if ([self.model.company isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请输入单位全称",
                                                                                                  }]];
    }
    if ([self.model.industry isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择行业类别",
                                                                                                  }]];
    }
    
    if ([self.model.companyType isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择行业性质",
                                                                                                  }]];
    }
    if ([self.model.department isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择部门",
                                                                                                  }]];
    }
    if ([self.model.title isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择职位",
                                                                                                  }]];
    }
    if ([self.model.currentJobDate isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择入职时间",
                                                                                                  }]];
    }
    if (![[self.model.unitAreaCode stringByAppendingString:self.model.unitTelephone] isTelephone]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
                                                                                                 NSLocalizedFailureReasonErrorKey: @"请输正确的联系电话",
                                                                                                 }]];
    }
    if ([self.model.workProvince isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请选择入所在地区",
                                                                                                  }]];
    }
    if ([self.model.workTown isEqualToString:@""]) {
      return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"请输入详细地址",
                                                                                                  }]];
    }
  }
  
 
//	if ([self.model.socialStatus isEqualToString:@"SI02"] && ![[self.model.unitAreaCode stringByAppendingString:self.model.unitTelephone] isTelephone]) {
//		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
//			NSLocalizedFailureReasonErrorKey: @"请输正确的联系电话",
//		}]];
//	}
	
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
	] reduce:^id(
		NSString *socail,
		NSString *company,
		NSString *industry,
		NSString *companyType,
		NSString *department,
		NSString *title,
		NSString *currentJobDate,
		NSString *unitAreaCode,
		NSString *unitTelephone,
		NSString *unitExtensionTelephone,
		NSString *workProvinceCode,
		NSString *workCityCode,
		NSString *workCountryCode,
		NSString *workTown
	) {
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
