//
//  MSFAuthenticate.h
//  Finance
//
//  Created by xbm on 16/3/15.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFAuthenticate : MSFObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *uniqueId;
@property (nonatomic, copy, readwrite) NSString * hasChecked __deprecated_msg("Use MSFUser.isAuthenticated");

@end
