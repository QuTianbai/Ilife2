//
//  MSFCommodity.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCommodity : MSFObject

@property (nonatomic, copy, readonly) NSString *catId; // 品类编号
@property (nonatomic, copy, readonly) NSString *cmdtyId; // 商品编号
@property (nonatomic, copy, readonly) NSString *brandName; // 品牌编号
@property (nonatomic, copy, readonly) NSString *cmdtyName; // 商品名称
@property (nonatomic, copy, readonly) NSString *pcsCount; // 件数
@property (nonatomic, copy, readonly) NSString *cmdtyPrice; // 商品价格

@end
