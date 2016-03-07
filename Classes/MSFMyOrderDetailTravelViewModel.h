//
//  MSFMyOrderDetailTravelViewModel.h
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFMyOrderDetailTravelViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *companName;
@property (nonatomic, copy, readonly) NSString *companCellphone;
@property (nonatomic, copy, readonly) NSString *companCertId;
@property (nonatomic, copy ,readonly) NSString *companRelationship;

- (instancetype)initWithModel:(id)model;

@end
