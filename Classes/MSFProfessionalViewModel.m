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

@interface MSFProfessionalViewModel ( )

@property(nonatomic,weak) UIViewController *viewController;
@property(nonatomic,readonly) MSFFormsViewModel *formsViewModel;

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
	
	@weakify(self)
	
	RACChannelTo(self, school) = RACChannelTo(self.model, universityName);
	RACChannelTo(self, enrollmentYear) = RACChannelTo(self.model, enrollmentYear);
	
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
		self.model.programLength = object.code;
		self.eductionalSystmeTitle = object.text;
	}];
	
	[RACObserve(self, seniority) subscribeNext:^(MSFSelectKeyValues *object) {
		self.model.workingLength = object.code;
		self.seniorityTitle = object.text;
	}];
	
	[RACObserve(self, industry) subscribeNext:^(MSFSelectKeyValues *object) {
		self.model.industry = object.code;
		self.industryTitle = object.text;
	}];
	
	[RACObserve(self, nature) subscribeNext:^(MSFSelectKeyValues *object) {
		self.model.companyType = object.code;
		self.natureTitle = object.text;
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
  
  return self;
}
/*

//TODO: refact to super class
- (instancetype)initWithModel:(MSFApplyInfo *)model {
  if (!(self = [super initWithModel:model])) {
    return nil;
  }
  self.date = [NSDateFormatter msf_dateFromString:model.currentJobDate];
  
  [self initialize];
  RAC(self.model,education) = [[RACObserve(self, degrees) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,socialStatus) = [[RACObserve(self, profession) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,workingLength) = [[RACObserve(self, seniority) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,industry) = [[RACObserve(self, industry) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,title) = [[RACObserve(self, position) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,companyType) = [[RACObserve(self, nature) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,currentJobDate) = [[RACObserve(self, date) ignore:nil] map:^id(NSDate *value) {
    return [NSDateFormatter msf_stringFromDate:value];
  }];
  RACChannelTo(self,company) = RACChannelTo(self.model,company);
  RACChannelTo(self,address) = RACChannelTo(self.model,workTown);
  RACChannelTo(self,areaCode) = RACChannelTo(self.model,unitAreaCode);
  RACChannelTo(self,telephone) = RACChannelTo(self.model,unitTelephone);
  RACChannelTo(self,extensionTelephone) = RACChannelTo(self.model,unitExtensionTelephone);
  
  @weakify(self)
  [[RACObserve(self, province) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.model.workProvinceCode = area.codeID;
    self.model.workProvince = area.name;
  }];
  [[RACObserve(self, city) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.model.workCityCode = area.codeID;
    self.model.workCity = area.name;
  }];
  [[RACObserve(self, area) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.model.workCountryCode = area.codeID;
    self.model.workCountry = area.name;
  }];
  
  _executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal
    signalBlock:^RACSignal *(id input) {
      @strongify(self)
      return self.executeRequestSignal;
    }];
  
  _executeIncumbencyRequest = [[RACCommand alloc] initWithEnabled:self.executeIncumbencyValidRequest
    signalBlock:^RACSignal *(id input) {
      @strongify(self)
      return self.executeIncumbencyRequestSignal;
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
      self.profession = obj;
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
  
  FMResultSet *rs;
  FMDatabase *fmdb = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"]];
  [fmdb open];
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.model.workProvinceCode]];
  if (rs.next) {
    self.province = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.model.workCityCode]];
  if (rs.next) {
    self.city = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.model.workCountryCode]];
  if (rs.next) {
    self.area = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  [fmdb close];
}

- (RACSignal *)executeRequestSignal {
  self.model.page = @"3";
  
  return [self.client applyInfoSubmit1:self.model];
}

- (RACSignal *)executeIncumbencyRequestSignal {
  self.model.page = @"3";
  
  return [self.client applyInfoSubmit1:self.model];
}

#pragma mark - Public

- (RACSignal *)requestValidSignal {
  return [RACSignal combineLatest:@[
    RACObserve(self, degrees),
    RACObserve(self, profession)
    ]
   reduce:^id(MSFSelectKeyValues *degress, MSFSelectKeyValues *profession){
     return @(degress != nil && profession != nil);
   }];
}

- (RACSignal *)executeIncumbencyValidRequest {
  return [RACSignal combineLatest:@[
    RACObserve(self, degrees),
    RACObserve(self, profession),
    RACObserve(self, seniority),
    RACObserve(self, company),
    RACObserve(self, industry),
    RACObserve(self, position),
    RACObserve(self, nature),
    RACObserve(self, date),
    RACObserve(self, areaCode),
    RACObserve(self, telephone),
    RACObserve(self, extensionTelephone),
    RACObserve(self, province),
    RACObserve(self, address),
    ]
   reduce:^id (
     MSFSelectKeyValues *degress,
     MSFSelectKeyValues *profession,
     MSFSelectKeyValues *seniority,
     NSString *company,
     MSFSelectKeyValues *industry,
     MSFSelectKeyValues *position,
     MSFSelectKeyValues *nature,
     NSDate *date,
     NSString *areaCode,
     NSString *telephone,
     NSString *extensionTelephone,
     MSFSelectKeyValues *province,
     NSString *address
     ) {
     NSString *tel = [NSString stringWithFormat:@"%@%@",areaCode,telephone];
     return @(
     position != nil &&
     seniority != nil &&
     degress != nil &&
     company.length > 0 &&
     industry != nil &&
     nature != nil &&
     date != nil &&
     areaCode != nil &&
     telephone != nil &&
     extensionTelephone != nil &&
     province != nil &&
     address.length > 0 &&
     tel.isTelephone
     );
   }];
}
*/

#pragma mark - Private

- (RACSignal *)educationSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		[self.viewController.view endEditing:YES];
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"edu_background"]];
		MSFSelectionViewController *selectionViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
		selectionViewController.title = @"教育信息";
		[self.viewController.navigationController pushViewController:selectionViewController animated:YES];
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
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
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
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
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
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
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
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
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
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
		[selectionViewController.selectedSignal subscribeNext:^(id x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.nature = x;
			[selectionViewController.navigationController popViewControllerAnimated:YES];
		}];
		return nil;
	}];
}

@end
