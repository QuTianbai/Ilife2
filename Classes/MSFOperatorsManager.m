//
//  MSFOperatorsManager.m
//  Finance
//
//  Created by administrator on 16/3/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFOperatorsManager.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation MSFOperatorsManager

+ (NSString *)checkCarrier {
    
    NSString *ret = @"";
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        return ret;
    }
    NSString *code = [carrier mobileNetworkCode];
    if ([code isEqual: @""]) {
        return ret;
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        ret = @"移动";
    }
    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"联通";
    }
    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"电信";;
    }
    return ret;
}

+ (NSString *)checkCarrierWithPhoneNum:(NSString *)phone {
    NSString *ret = @"";
    NSString *regex1 = @"^(134|135|136|137|138|139|150|151|157|158|159)[0-9]{8}";
    NSString *regex2 = @"^(?:13[0-2]|145|15[56]|176|18[56])\\d{8}";
    NSString *regex3 = @"^(?:133|153|177|18[019])\\d{8}";
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex3];
    if ([predicate1 evaluateWithObject:phone])
        ret = @"移动";
    if ([predicate2 evaluateWithObject:phone]) {
        ret = @"联通";
    }
    if ([predicate3 evaluateWithObject:regex3]) {
        ret = @"电信";
    }
    return ret;
}

@end
