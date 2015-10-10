//
//  MSFClient+Contacts.h
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Contacts)

- (RACSignal *)fetchContacts;
- (RACSignal *)fetchContactsInfoWithAppNO:(NSString *)appNO AndProductNO:(NSString *)productCode AndtemplateType:(NSString *)templateType;

@end
