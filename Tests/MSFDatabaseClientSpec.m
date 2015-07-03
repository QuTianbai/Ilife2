//
// MSFDatabaseClientSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLogClient.h"
#import <FMDB/FMDB.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFLSystem.h"
#import "MSFLDevice.h"
#import "MSFLChannel.h"
#import "MSFLEvent.h"
#import "MSFUser.h"
#import "MSFTestLogClient.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFServer.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

QuickSpecBegin(MSFDatabaseClientSpec)

__block NSString *path;
__block FMDatabase *db;

beforeEach(^{
  path = [NSTemporaryDirectory() stringByAppendingString:@"sqlite.db"];
  db = [[FMDatabase alloc] initWithPath:path];
  expect(@(db.open)).to(beTruthy());
  
  [db executeUpdate:@"drop table if exists sys"];
  NSMutableArray *params = NSMutableArray.new;
  [[MSFLSystem FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  NSString *sql = [NSString stringWithFormat:@"create table if not exists sys (%@)",[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  [db executeUpdate:@"drop table if exists device"];
  params = NSMutableArray.new;
  [[MSFLDevice FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",MSFLDevice.FMDBTableName,[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  [db executeUpdate:@"drop table if exists channel"];
  params = NSMutableArray.new;
  [[MSFLChannel FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",MSFLChannel.FMDBTableName,[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
  
  [db executeUpdate:@"drop table if exists events"];
  params = NSMutableArray.new;
  [[MSFLEvent FMDBColumnsByPropertyKey].allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [params addObject:[NSString stringWithFormat:@"%@ text",obj]];
  }];
  sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)",MSFLEvent.FMDBTableName,[params componentsJoinedByString:@","]];
  [db executeUpdate:sql];
});

afterEach(^{
  expect(@(db.close)).to(beTruthy());
  [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
});

it(@"should initialize", ^{
  // then
  expect(db).notTo(beNil());
});

it(@"should has system information table", ^{
  // then
  expect(@([db tableExists:@"sys"])).to(beTruthy());
});

it(@"should insert system instance to database", ^{
  // given
  MSFLSystem *mockSystem = [[MSFLSystem alloc] initWithDictionary:@{
    @"platform": @"1",
    @"version": @"2",
    @"sdkVersion": @"3",
    @"buildId": @"4",
  }
  error:nil];
  
  NSString *stmt = [MTLFMDBAdapter insertStatementForModel:mockSystem];
  NSArray *params = [MTLFMDBAdapter columnValues:mockSystem];
  
  // when
  [db executeUpdate:stmt withArgumentsInArray:params];
  NSString *sql = @"select * from sys";
  FMResultSet *rs = [db executeQuery:sql];
  
  // then
  expect(@(rs.next)).to(beTruthy());
  
  MSFLSystem *system = [MTLFMDBAdapter modelOfClass:MSFLSystem.class fromFMResultSet:rs error:nil];
  
  expect(system.platform).to(equal(@"1"));
  expect(system.version).to(equal(@"2"));
  expect(system.sdkVersion).to(equal(@"3"));
  expect(system.buildId).to(equal(@"4"));
});

it(@"should has device information table", ^{
  // then
  expect(@([db tableExists:@"device"])).to(beTruthy());
});

it(@"should insert devcie instance to database", ^{
  // given
  MSFLDevice *mockDevice = [[MSFLDevice alloc] initWithDictionary:@{
    @"manufacturer": @"1",
    @"brand": @"2",
    @"model": @"3",
    @"deviceID": @"4",
  }
  error:nil];
  
  NSString *stmt = [MTLFMDBAdapter insertStatementForModel:mockDevice];
  NSArray *params = [MTLFMDBAdapter columnValues:mockDevice];
  NSLog(@"%@",params.description);
  
  // when
  [db executeUpdate:stmt withArgumentsInArray:params];
  NSString *sql = @"select * from device";
  FMResultSet *rs = [db executeQuery:sql];
  
  // then
  expect(@(rs.next)).to(beTruthy());
  
  MSFLDevice *device = [MTLFMDBAdapter modelOfClass:MSFLDevice.class fromFMResultSet:rs error:nil];
  
  expect(device.manufacturer).to(equal(@"1"));
  expect(device.brand).to(equal(@"2"));
  expect(device.model).to(equal(@"3"));
  expect(device.deviceID).to(equal(@"4"));
});

it(@"should has channel information table", ^{
  // then
  expect(@([db tableExists:MSFLChannel.FMDBTableName])).to(beTruthy());
});

it(@"should insert chancel instance to database", ^{
  // given
  MSFLChannel *mockDevice = [[MSFLChannel alloc] initWithDictionary:@{
    @"channel": @"1",
    @"appVersion": @"2",
  }
  error:nil];
  
  NSString *stmt = [MTLFMDBAdapter insertStatementForModel:mockDevice];
  NSArray *params = [MTLFMDBAdapter columnValues:mockDevice];
  
  // when
  [db executeUpdate:stmt withArgumentsInArray:params];
  NSString *sql = @"select * from channel";
  FMResultSet *rs = [db executeQuery:sql];
  
  // then
  expect(@(rs.next)).to(beTruthy());
  
  MSFLChannel *channel = [MTLFMDBAdapter modelOfClass:MSFLChannel.class fromFMResultSet:rs error:nil];
  
  expect(channel.channel).to(equal(@"1"));
  expect(channel.appVersion).to(equal(@"2"));
});

it(@"should has events information table", ^{
  // then
  expect(@([db tableExists:MSFLChannel.FMDBTableName])).to(beTruthy());
});

it(@"should insert event instance to database", ^{
  // given
  MSFLEvent *mockEvent = [[MSFLEvent alloc] initWithDictionary:@{
    @"event": @"1",
    @"currentTime": @"2",
    @"networkType": @"3",
    @"userId": @"4",
    @"location": @"5",
    @"label": @"6",
    @"value": @"7",
  }
  error:nil];
  
  NSString *stmt = [MTLFMDBAdapter insertStatementForModel:mockEvent];
  NSArray *params = [MTLFMDBAdapter columnValues:mockEvent];
  
  // when
  [db executeUpdate:stmt withArgumentsInArray:params];
  NSString *sql = @"select * from events";
  FMResultSet *rs = [db executeQuery:sql];
  
  // then
  expect(@(rs.next)).to(beTruthy());
  
  MSFLEvent *event = [MTLFMDBAdapter modelOfClass:MSFLEvent.class fromFMResultSet:rs error:nil];
  
  expect(event.event).to(equal(@"1"));
  expect(event.currentTime).to(equal(@"2"));
  expect(event.networkType).to(equal(@"3"));
  expect(event.userId).to(equal(@"4"));
  expect(event.location).to(equal(@"5"));
  expect(event.label).to(equal(@"6"));
  expect(event.value).to(equal(@"7"));
});

describe(@"client", ^{

  __block MSFTestLogClient *client;

  beforeEach(^{
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"log.sqlite"];
    MSFLSystem *system = [[MSFLSystem alloc] initWithDictionary:@{
      @"platform" : @"ios",
      @"sdkVersion" : @"7.0",
      @"version" : @"2",
      @"buildId" : @"10"
    } error:nil];
    MSFLDevice *device = [[MSFLDevice alloc] initWithDictionary:@{
      @"manufacturer" : @"Apple",
      @"brand" : @"iPhone 5",
      @"model" : @"iPhone",
      @"deviceID" : @"123"
    } error:nil];
    MSFLChannel *channel = [[MSFLChannel alloc] initWithDictionary:@{
      @"channel" : @"msfinance",
      @"appVersion" : @"10001"
    } error:nil];
    client = [[MSFTestLogClient alloc] initWithPath:path system:system device:device channel:channel];
  });
  
  afterEach(^{
    NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"log.sqlite"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
  });
  
  it(@"should initialize", ^{
    // then
    expect(client).notTo(beNil());
    expect(client.system).notTo(beNil());
    expect(client.device).notTo(beNil());
    expect(client.channel).notTo(beNil());
   });

  it(@"should has client base information json", ^{
    // given
    NSDictionary *myDictionary = @{
      @"sys" : @{
        @"platform" : @"ios",
        @"sdkVersion" : @"7.0",
        @"version" : @"2",
        @"buildId" : @"10"
      },
      @"device" : @{
        @"manufacturer" : @"Apple",
        @"brand" : @"iPhone 5",
        @"model" : @"iPhone",
        @"id" : @"123"
      },
      @"app" : @{
        @"channel" : @"msfinance",
        @"appVersion" : @"10001"
      }
    };
    
    // then
    expect(client.infoDictionary).to(equal(myDictionary));
  });
  
  it(@"should add event in database", ^{
    // given
    MSFUser *user = mock([MSFUser class]);
    stubProperty(user, objectID, @"xxx");
    MSFLEvent *event = [[MSFLEvent alloc] initWithEvent:MSFEventTypePage
      date:[NSDate date] network:MSFNetworkType2G
      user:user latitude:10 longitude:10 label:@"label" value:@"value"];
     
    // when
    [client addEvent:event];
    NSArray *results = client.events;
    MSFLEvent *result = results.firstObject;
      
    // then
    expect(results).notTo(beNil());
    expect(result).to(beAKindOf([MSFLEvent class]));
    expect(result.label).to(equal(@"label"));
  });
  
  it(@"should send logs", ^{
    // given
    MSFUser *user = mock([MSFUser class]);
    stubProperty(user, objectID, @"xxx");
    stubProperty(user, server, MSFServer.dotComServer);
    MSFClient *httpClient = [MSFClient authenticatedClientWithUser:user token:@"" session:@""];
    [MSFTestLogClient setHTTPClient:httpClient];
     
    [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
       return [OHHTTPStubsResponse responseWithData:nil statusCode:200 responseTime:0 headers:@{
         @"Content-Type": @"application/json"
       }];
    }];
     
    NSError *error;
    BOOL success = NO;
    
    // when
    RACSignal *signal = [client sendLogs];
    [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    
    // then
    expect(@(success)).to(beTruthy());
    expect(error).to(beNil());
  });
});

QuickSpecEnd