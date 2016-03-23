//
// MSFContact.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFContact : MSFObject

@property (nonatomic, copy, readonly) NSString *custId;
@property (nonatomic, copy, readonly) NSString *timeInst;
@property (nonatomic, copy, readonly) NSString *timeUpd;
@property (nonatomic, copy, readonly) NSString *uniqueId;

@property (nonatomic, copy, readwrite) NSString *contactRelation;
@property (nonatomic, copy, readonly) NSString *contactAddress;
@property (nonatomic, copy, readonly) NSString *contactName;
@property (nonatomic, copy, readonly) NSString *contactMobile;

@end
