//
// MSFElementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFElementViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *thumbURL;
@property (nonatomic, assign) BOOL validity;

@property (nonatomic, strong) NSArray *attachments;

@property (nonatomic, strong, readonly) RACCommand *executeUploadCommand;
@property (nonatomic, strong, readonly) RACCommand *executeDownloadCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services model:(id)element;

@end
