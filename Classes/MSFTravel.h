//
// MSFTravel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFTravel : MSFObject

@property (nonatomic, copy, readonly) NSString *departureTime;
@property (nonatomic, copy, readonly) NSString *returnTime;
@property (nonatomic, copy, readonly) NSString *isNeedVisa;
@property (nonatomic, copy, readonly) NSString *origin;
@property (nonatomic, copy, readonly) NSString *destination;
@property (nonatomic, assign, readonly) int travelNum;
@property (nonatomic, assign, readonly) int travelKidsNum;
@property (nonatomic, copy, readonly) NSString *travelType;

@end
