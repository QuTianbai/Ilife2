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

@property (nonatomic, strong) MSFContact *model;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFContactViewModel

- (instancetype)initWithModel:(id)model Services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	_on = YES;
	_services = services;
	
	_executeRelationshipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self.services msf_selectKeyValuesWithContent:@"familyMember_type"];
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
	@weakify(self)
	[self.executeSelectContactCommand.executionSignals subscribeNext:^(id x) {
		@strongify(self)
		[x subscribeNext:^(RACTuple *x) {
			id obj;
			[x.second getValue:&obj];
			ABRecordRef person = (__bridge  ABRecordRef)obj;
			ABMultiValueIdentifier identifier = [x.last intValue];

			ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
			CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
			NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
			NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
			phone = [[phone componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
			NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(person);
			self.name = fullName;
			self.phone = phone;
		}];
	}];
	
  return self;
}

- (BOOL)isEqual:(id)other {
	if (other == self) {
		return YES;
	} else if (![super isEqual:other]) {
		return NO;
	} else {
		return [self.model.uniqueId isEqual:[(MSFContactViewModel *)other model].uniqueId];
	}
}

- (NSUInteger)hash {
	return self.model.uniqueId.integerValue ^ self.model.custId.integerValue;
}

@end
