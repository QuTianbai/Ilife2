//
// MSFObject.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>

@class MSFServer;

@interface MSFObject : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *objectID;
@property (nonatomic, strong, readonly) MSFServer *server;

@end
