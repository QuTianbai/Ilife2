//
//  MSFUserContact.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFUserContact : MSFObject

@property (nonatomic, copy) NSString *contactRelation;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, assign) BOOL openDetailAddress;

@end
