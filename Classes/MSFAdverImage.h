//
//  MSFAdverImage.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAdverImage : MSFObject

@property (nonatomic, strong, readonly) NSNumber *width;
@property (nonatomic, strong, readonly) NSNumber *height;
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSString *type;

@end
