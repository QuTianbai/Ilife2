//
// Cipher.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCipher.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFResponse.h"
#import "MSFSignature.h"
#import "MSFClient+Cipher.h"
#import "NSURL+QueryDictionary.h"
#import <NSString-Hashes/NSString+Hashes.h>

static NSString *const kEncrpytinoKey = @"34569E09FE7A0AF8E01FB1258B9BCAF2";
static NSString *const kDisparityIntervalKey = @"timestamp";
static NSString *const kParametersSignKey = @"sign";

@implementation MSFCipher {
  // 服务器本地时间差
  long long disparityInterval;
}

- (instancetype)initWithSession:(long long)contestant {
  self = [super init];
  if (!self) {
    return nil;
  }
  _sessionId = contestant;
  _serialization = [self bumpstamp];
  _signKey = kEncrpytinoKey;
  
  return self;
}

- (long long)bumpstamp {
  return (long long)([[NSDate date] timeIntervalSince1970] * 1000);
}

- (MSFSignature *)signatureWithPath:(NSString *)path parameters:(NSDictionary *)params {
  if (!params) {
    params = @{};
  }
  NSParameterAssert([params isKindOfClass:NSDictionary.class]);
  NSMutableDictionary *parameters = params.mutableCopy;
  disparityInterval = self.sessionId - self.serialization + [self bumpstamp];
  NSString *sign = [self signWithPath:path query:params];
  [parameters setObject:sign forKey:kParametersSignKey];
  [parameters setObject:@(disparityInterval) forKey:kDisparityIntervalKey];
  
  return [[MSFSignature alloc] initWithDictionary:@{
    kParametersSignKey: sign,
    kDisparityIntervalKey: @(disparityInterval)}
   error:nil];
}

#pragma mark - Private

- (NSString *)encodeFromPercentEscapeString:(NSString *)string {
  return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
   NULL,
   (__bridge CFStringRef) string,
   CFSTR(""),
   kCFStringEncodingUTF8);
}

- (NSString *)signWithPath:(NSString *)path query:(NSDictionary *)query {
  NSMutableDictionary *parameters = query.mutableCopy;
  [parameters addEntriesFromDictionary:@{kDisparityIntervalKey: @(disparityInterval)}];
  NSArray *sortedKeys = [parameters.allKeys sortedArrayUsingSelector:@selector(compare:)];
  NSMutableArray *sorted = NSMutableArray.new;
  for (NSString *key in sortedKeys) {
    NSString *keyAndValue = [NSString stringWithFormat:@"%@=%@", key,
     [parameters[key] isKindOfClass:NSString.class] ? [self encodeFromPercentEscapeString:parameters[key]] : parameters[key]];
    [sorted addObject:keyAndValue];
  }
  [sorted addObject:[@"key=" stringByAppendingString:self.signKey]];
  
  [sorted insertObject:path atIndex:0];
  NSString *string = [sorted componentsJoinedByString:@"&"];
  
  return [string.md5 uppercaseString];
}

@end
