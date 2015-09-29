//
//  MSFUserInfoModel.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFUserBaseInfo.h"
#import "MSFUserOccupationInfo.h"
#import "MSFUserContact.h"
#import "MSFUserAdditional.h"

@interface MSFUserInfoModel : MSFObject

@property (nonatomic, assign) int infoType;
@property (nonatomic, copy) MSFUserBaseInfo *baseInfo;
@property (nonatomic, copy) MSFUserOccupationInfo *occupationInfo;
@property (nonatomic, copy) NSArray *contrastList;
@property (nonatomic, copy) NSArray *additionalList;

@end
