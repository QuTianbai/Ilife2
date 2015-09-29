//
//  MSFUserBaseInfo.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFUserBaseInfo : MSFObject

@property (nonatomic, copy) NSString *homePhone;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *abodeStateCode;
@property (nonatomic, copy) NSString *abodeCityCode;
@property (nonatomic, copy) NSString *abodeZoneCode;
@property (nonatomic, copy) NSString *abodeDetail;
@property (nonatomic, copy) NSString *houseCondition;
@property (nonatomic, copy) NSString *maritalStatus;

@end
