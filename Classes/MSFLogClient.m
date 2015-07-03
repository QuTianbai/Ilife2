//
// MSFLogClient.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLogClient.h"
#import "MSFLSystem.h"
#import "MSFLDevice.h"
#import "MSFLChannel.h"
#import "MSFLEvent.h"
#import <FMDB/FMDB.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFClient.h"
#import "MSFResponse.h"

@implementation MSFLogClient

#pragma mark - Lifecycle

+ (instancetype)sharedClient {
  static MSFLogClient *client;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    MSFLSystem *system = MSFLSystem.currentSystem;
    MSFLDevice *device = MSFLDevice.currentDevice;
    MSFLChannel *channel = MSFLChannel.currentChannel;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/logs.sqlite"];
    client = [[MSFLogClient alloc] initWithPath:path system:system device:device channel:channel];
  });
  
  return client;
}

- (instancetype)initWithPath:(NSString *)path
  system:(MSFLSystem *)system
  device:(MSFLDevice *)device
  channel:(MSFLChannel *)channel {
  self = [super init];
  if (!self) {
    return nil;
  }
  _system = system;
  _device = device;
  _channel = channel;
  _path = path;
  
  [self initialize];
  
  return self;
}

- (void)initialize {
  FMDatabase *db = [[FMDatabase alloc] initWithPath:self.path];
  [db open];
  
  if ([db tableExists:MSFLEvent.FMDBTableName]) {
    [db close];
    return;
  }
  
  NSMutableArray *params = NSMutableArray.new;
  [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",MSFLSystem.FMDBTableName]];
  [[MSFLSystem FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  NSString *sql = [NSString stringWithFormat:@"create table if not exists sys (%@)",[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",MSFLDevice.FMDBTableName]];
  params = NSMutableArray.new;
  [[MSFLDevice FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",MSFLDevice.FMDBTableName,[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",MSFLChannel.FMDBTableName]];
  params = NSMutableArray.new;
  [[MSFLChannel FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",MSFLChannel.FMDBTableName,[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  [db executeUpdate:[NSString stringWithFormat:@"drop table if exists %@",MSFLEvent.FMDBTableName]];
  params = NSMutableArray.new;
  [[MSFLEvent FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",MSFLEvent.FMDBTableName,[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  NSString *stmt = [MTLFMDBAdapter insertStatementForModel:self.system];
  NSArray *arguments = [MTLFMDBAdapter columnValues:self.system];
  [db executeUpdate:stmt withArgumentsInArray:arguments];
  
  stmt = [MTLFMDBAdapter insertStatementForModel:self.device];
  arguments = [MTLFMDBAdapter columnValues:self.device];
  [db executeUpdate:stmt withArgumentsInArray:arguments];
  
  stmt = [MTLFMDBAdapter insertStatementForModel:self.channel];
  arguments = [MTLFMDBAdapter columnValues:self.channel];
  [db executeUpdate:stmt withArgumentsInArray:arguments];
  
  [db close];
}

#pragma mark - Public

- (NSDictionary *)infoDictionary {
  FMDatabase *db = [[FMDatabase alloc] initWithPath:self.path];
  [db open];
  NSString *sql = [NSString stringWithFormat:@"select * from %@",MSFLSystem.FMDBTableName];
  FMResultSet *rs = [db executeQuery:sql];
  [rs next];
  MSFLSystem *system = [MTLFMDBAdapter modelOfClass:[MSFLSystem class] fromFMResultSet:rs error:nil];
  
  sql = [NSString stringWithFormat:@"select * from %@",MSFLDevice.FMDBTableName];
  rs = [db executeQuery:sql];
  [rs next];
  MSFLDevice *device = [MTLFMDBAdapter modelOfClass:[MSFLDevice class] fromFMResultSet:rs error:nil];
  
  sql = [NSString stringWithFormat:@"select * from %@",MSFLChannel.FMDBTableName];
  rs = [db executeQuery:sql];
  [rs next];
  MSFLChannel *channel = [MTLFMDBAdapter modelOfClass:[MSFLChannel class] fromFMResultSet:rs error:nil];
  
  [db close];
  
  return @{
    @"sys" : system.dictionaryValue,
    @"device": [MTLJSONAdapter JSONDictionaryFromModel:device],
    @"app": channel.dictionaryValue,
  };
}

- (void)addEvent:(MSFLEvent *)event {
  FMDatabase *db = [[FMDatabase alloc] initWithPath:self.path];
  [db open];
  
  NSString *stmt = [MTLFMDBAdapter insertStatementForModel:event];
  NSArray *arguments = [MTLFMDBAdapter columnValues:event];
  [db executeUpdate:stmt withArgumentsInArray:arguments];
  
  [db close];
}

- (NSArray *)events {
  NSMutableArray *events = [[NSMutableArray alloc] init];
  FMDatabase *db = [[FMDatabase alloc] initWithPath:self.path];
  [db open];
  
  NSString *sql = [NSString stringWithFormat:@"select * from %@",MSFLEvent.FMDBTableName];
  FMResultSet *rs = [db executeQuery:sql];
  while (rs.next) {
    [events addObject:[MTLFMDBAdapter modelOfClass:MSFLEvent.class fromFMResultSet:rs error:nil]];
  }
  
  [db close];
  
  return events;
}

- (void)cleanup {
  FMDatabase *db = [[FMDatabase alloc] initWithPath:self.path];
  [db open];
  NSString *sql = [NSString stringWithFormat:@"delete from %@",MSFLEvent.FMDBTableName];
  [db executeUpdate:sql];
  [db close];
}

- (RACSignal *)sendLogs {
  NSArray *events = self.events;
  NSMutableArray *logs = NSMutableArray.array;
  [events enumerateObjectsUsingBlock:^(MSFLEvent *obj, NSUInteger idx, BOOL *stop) {
    [logs addObject:obj.dictionaryValue];
  }];
  NSMutableDictionary *logInfo = [self.infoDictionary mutableCopy];
  [logInfo setObject:logs forKey:@"logs"];
  
  NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
  [parameters setObject:logInfo forKey:@"returnData"];
  [parameters setObject:@"1" forKey:@"type"];
  
  //TODO: 日志上传存在问题，无法上传成功
  NSMutableURLRequest *request = [self.client requestWithMethod:@"POST" path:@"data/statistic" parameters:parameters];
  @weakify(self)
  return [[[self.client enqueueRequest:request resultClass:nil]
    doCompleted:^{
      @strongify(self)
      [self cleanup];
    }] replay];
}

#pragma mark - Custom Accessors

- (MSFClient *)client {
  return  MSFUtils.httpClient;
}

@end
