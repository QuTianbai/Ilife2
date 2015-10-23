//
//  MSFRelationCellViewModel.h
//  Finance
//
//  Created by 赵勇 on 10/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFUserContact;
@class RACCommand;

@interface MSFRelationCellViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACCommand *deleteCommand;
@property (nonatomic, strong, readonly) RACCommand *memberSelectionCommand;
//@property (nonatomic, strong, readonly) RACCommand *memberSelectionCommand;
//@property (nonatomic, strong, readonly) RACCommand *memberSelectionCommand;
//@property (nonatomic, strong, readonly) RACCommand *memberSelectionCommand;

- (instancetype)initWithService:(id<MSFViewModelServices>)services
												contact:(MSFUserContact *)contact;

@end
