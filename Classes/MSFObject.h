//
// MSFObject.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Mantle/Mantle.h>

@class MSFServer;

@interface MSFObject : MTLModel <MTLJSONSerializing>

// model id always parser json id key.
@property (nonatomic, copy, readonly) NSString *objectID;

// Model server URL.
@property (nonatomic, strong, readonly) MSFServer *server;

@end
