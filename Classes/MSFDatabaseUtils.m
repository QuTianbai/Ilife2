//
//  MSFDatabaseUtils.m
//  Cash
//
//  Created by xbm on 15/5/24.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFDatabaseUtils.h"
#import <FMDB/FMDatabase.h>

@implementation MSFDatabaseUtils

+ (void)findDatabase {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
  FMDatabase *db = [FMDatabase databaseWithPath:path];
  if (![db open]) {
    return;
  }
  FMResultSet *s = [db executeQuery:@"select count(*) from basic_dic_area"];
  if ([s next]) {
    int totalCount = [ s intForColumnIndex:0];
    NSLog(@"%d",totalCount);
  }
  [db close];
}

@end
