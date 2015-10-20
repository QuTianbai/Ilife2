//
//  NSObject+MSFValidItem.h
//  Finance
//
//  Created by 赵勇 on 10/20/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(MSFValidItem)

- (NSString *)validString;
- (NSArray *)validArray;
- (NSDictionary *)validDictionary;

- (NSString *)trimmedString;

@end

