//
//  MSFUserContact.h
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <Mantle/Mantle.h>

// 用户联系人信息
@interface MSFUserContact : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *contactRelation;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, assign) BOOL openDetailAddress;
@property (nonatomic, assign, readonly) BOOL isFamily;

@end
