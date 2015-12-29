//
// MSFLoanType.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 贷款产品群类型
@interface MSFLoanType : MSFObject

// 产品群类型ID
@property (nonatomic, copy, readonly) NSString *typeID;

// Create <MSFLoanType> instance with typeID
//
// 社保贷 1101 马上贷 4102 随借随还 4101 商品贷 3101
//
// typeID - 贷款产品群ID
//
// Returns a new loanType
- (instancetype)initWithTypeID:(NSString *)typeID;

@end
