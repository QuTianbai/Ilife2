//
//  MSFCommodity.h
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCommodity : MSFObject

@property (nonatomic, copy, readonly) NSString *catLevel1Name; // 分类1
@property (nonatomic, copy, readonly) NSString *catLevel1Id; // 分类1
@property (nonatomic, copy, readonly) NSString *catLevel2Name; // 分类2
@property (nonatomic, copy, readonly) NSString *catLevel2Id; // 分类2
@property (nonatomic, copy, readonly) NSString *catLevel3Name; // 分类3
@property (nonatomic, copy, readonly) NSString *catLevel3Id; // 分类3

//new version
@property (nonatomic, copy, readonly) NSString *catId; // 品类编号
@property (nonatomic, copy, readonly) NSString *cmdtyId; // 商品编号
@property (nonatomic, copy, readonly) NSString *brandName; // 品牌名称
@property (nonatomic, copy, readonly) NSString *cmdtyName; // 商品名称
@property (nonatomic, copy, readonly) NSString *pcsCount; // 件数
@property (nonatomic, copy, readonly) NSString *cmdtyPrice; // 商品价格

// 旅游相关信息
@property (nonatomic, copy, readonly) NSString *departureTime;

@end
