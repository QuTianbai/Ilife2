//
//  MSFSelectKeyValues.h
//  Cash
//
//  Created by xbm on 15/5/25.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFSelectionItem.h"

@interface MSFSelectKeyValues : MSFObject <MSFSelectionItem>

@property(nonatomic,copy,readonly) NSString *typeId;
@property(nonatomic,copy,readonly) NSString *code;
@property(nonatomic,copy,readonly) NSString *text;

+ (NSArray *)getSelectKeys:(NSString *)fileName;

@end
