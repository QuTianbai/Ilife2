//
// MSFSocialProfile.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFSocialProfile : MSFObject

@property (nonatomic, copy,readonly) NSString *custId;
@property (nonatomic, copy,readonly) NSString *timeInst;
@property (nonatomic, copy,readonly) NSString *timeUpd;
@property (nonatomic, copy,readonly) NSString *additionalValue;
@property (nonatomic, copy,readonly) NSString *additionalType;
@property (nonatomic, copy,readonly) NSString *uniqueId;

@end
