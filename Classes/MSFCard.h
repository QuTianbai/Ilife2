//
// MSFCard.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCard : MSFObject

@property (nonatomic, copy, readonly) NSString *cardID;
@property (nonatomic, copy, readonly) NSString *number;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *code;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *province;
@property (nonatomic, copy, readonly) NSString *master;

@end
