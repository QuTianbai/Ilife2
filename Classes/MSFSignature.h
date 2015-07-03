//
// MSFSignature.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MSFSignature : MTLModel

@property(nonatomic,copy,readonly) NSString *sign;
@property(nonatomic,copy,readonly) NSString *timestamp;
@property(nonatomic,readonly) NSString *query;

@end
