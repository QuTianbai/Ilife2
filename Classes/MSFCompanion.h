//
// MSFCompanion.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 同行人
@interface MSFCompanion : MSFObject

@property (nonatomic, copy, readonly) NSString *companName;
@property (nonatomic, copy, readonly) NSString *companCellphone;
@property (nonatomic, copy, readonly) NSString *companCertId;
@property (nonatomic, copy, readonly) NSString *companRelationship;

@end
