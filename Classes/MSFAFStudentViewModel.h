//
// MSFAFStudentViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFormsViewModel.h"

@class MSFSelectKeyValues;
@class RACCommand;

@interface MSFAFStudentViewModel : MSFFormsViewModel

@property(nonatomic,strong) NSString *school;
@property(nonatomic,strong) NSDate *year;
@property(nonatomic,strong) MSFSelectKeyValues *length;

@property(nonatomic,strong) RACCommand *executeRequest;

@end
