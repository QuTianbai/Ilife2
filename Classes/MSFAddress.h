//
// MSFAddress.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAddress : MSFObject

// The province code
@property (nonatomic, copy, readonly) NSString *province;

// The city code
@property (nonatomic, copy, readonly) NSString *city;

// The country code
@property (nonatomic, copy, readonly) NSString *area;

@end
