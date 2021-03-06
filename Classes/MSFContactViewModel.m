//
// MSFContactViewModel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFContactViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MSFContact.h"
#import "MSFProfessionalViewController.h"
#import "MSFSelectKeyValues.h"

@interface MSFContactViewModel ()

@property (nonatomic, strong, readwrite) MSFContact *model;
@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong, readwrite) RACCommand *executeNoFamilyRelationshipCommand;

@end

@implementation MSFContactViewModel

- (instancetype)initWithModel:(id)model Services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	_on = self.model.contactAddress.length == 0;
	_services = services;
	_executeRelationshipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
        NSString *s = [[input componentsSeparatedByString:@"_"] objectAtIndex:0];
        NSString *married = [[input componentsSeparatedByString:@"_"] lastObject];
        if ([s isEqualToString:@"0"]) {
            return [self.services msf_selectKeyValuesWithContent:@"familyMember_type1"];
        } else if (![married isEqualToString:@"20"])
           return  [self.services msf_selectKeyValuesWithContent:@"familyMember_married_type"];
        else return [self.services msf_selectKeyValuesWithContent:@"familyMember_type"];
	}];
    
	RAC(self, relationship) = [RACObserve(self, model.contactRelation) flattenMap:^id(id value) {
		return [self.services msf_selectValuesWithContent:@"familyMember_type" keycode:value];
	}];
	RAC(self, model.contactRelation) = [[self.executeRelationshipCommand.executionSignals
		switchToLatest]
		map:^id(MSFSelectKeyValues *x) {
				return x.code;
		}];
	
	_executeSelectContactCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services msf_selectContactSignal];
	}];
	RACChannelTo(self, name) = RACChannelTo(self, model.contactName);
	RACChannelTo(self, phone) = RACChannelTo(self, model.contactMobile);
	RACChannelTo(self, address) = RACChannelTo(self, model.contactAddress);
	@weakify(self)
	[self.executeSelectContactCommand.executionSignals subscribeNext:^(id x) {
		@strongify(self)
		[x subscribeNext:^(RACTuple *x) {
			self.name = x.first;
			self.phone = x.last;
		}];
	}];
	
	RAC(self, isValid) = [RACSignal combineLatest:@[
		RACObserve(self, name),
		RACObserve(self, phone),
		RACObserve(self, relationship),
        RACObserve(self, on),
        RACObserve(self, mainContact)
	]
	reduce:^id(NSString *name, NSString *phone, NSString *relationship,NSNumber *on, NSNumber *mainContact) {
        BOOL addIsValid = YES;
        if ([mainContact boolValue]) {
            if (![on boolValue]) {
                addIsValid =  self.address.length > 0 && self.address.length < 200;
            }
        }
        return @(name.length > 0 && phone.length > 0 && relationship.length > 0 && addIsValid);
	}];
	
  return self;
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else {
		return [self.model isEqual:[(MSFContactViewModel *)other model]];
	}
}

@end
