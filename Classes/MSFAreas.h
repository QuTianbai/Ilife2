//
//  MSFAreas.h
//  Cash
//
//  Created by xbm on 15/5/24.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import "MSFSelectionItem.h"

@interface MSFAreas : MTLModel <MTLJSONSerializing,MTLFMDBSerializing,MSFSelectionItem>

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *codeID;
@property(strong,nonatomic) NSString *parentCodeID;

@end
