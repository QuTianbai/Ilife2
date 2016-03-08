//
// MSFPersonal.h
//
// copy, readonlyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFPersonal : MSFObject

@property (nonatomic, copy, readonly) NSString *idNo;
@property (nonatomic, copy, readonly) NSString *idType;
@property (nonatomic, copy, readonly) NSString *birth;
@property (nonatomic, copy, readonly) NSString *abodeState;
@property (nonatomic, copy, readonly) NSString *custSource;
@property (nonatomic, copy, readonly) NSString *idLastDate;
@property (nonatomic, copy, readonly) NSString *abodeCityCode;
@property (nonatomic, copy, readonly) NSString *maritalStatus;
@property (nonatomic, copy, readonly) NSString *homePhone;
@property (nonatomic, copy, readonly) NSString *abodeDetail;
@property (nonatomic, copy, readonly) NSString *houseCondition;
@property (nonatomic, copy, readonly) NSString *abodeStateCode;
@property (nonatomic, copy, readonly) NSString *abodeZoneCode;
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *cellphone;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *gender;
@property (nonatomic, copy, readonly) NSString *abodeZone;
@property (nonatomic, copy, readonly) NSString *abodeCity;

@end
