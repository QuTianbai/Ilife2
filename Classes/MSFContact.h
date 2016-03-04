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

@property (nonatomic, copy) NSString *contactRelation;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;

@end
