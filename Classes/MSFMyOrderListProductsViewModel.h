//
//  MSFMyOrderListProductsViewModel.h
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFMyOrderDetailTravelViewModel.h"
#import "MSFOrderDetail.h"

@interface MSFMyOrderListProductsViewModel : RVMViewModel

@property (nonatomic, assign) id<MSFViewModelServices> services;
@property (nonatomic, strong) MSFOrderDetail *model;
@property (nonatomic, copy, readonly) NSString *isReload;
@property (nonatomic, copy, readonly) NSString *months;
@property (nonatomic, copy, readonly) NSString *inOrderId;
@property (nonatomic, copy, readonly) NSString *orderStatus;
@property (nonatomic, copy, readonly) NSString *orderTime;
@property (nonatomic, copy, readonly) NSString *txnTime;
@property (nonatomic, copy, readonly) NSString *compId;
@property (nonatomic, copy, readonly) NSString *empId;
@property (nonatomic, copy, readonly) NSString *compName;
@property (nonatomic, copy, readonly) NSString *compOfficePhone ;
@property (nonatomic, copy, readonly) NSString *empName;
@property (nonatomic, copy, readonly) NSString *outOrderId;
@property (nonatomic, copy, readonly) NSString *catId;
@property (nonatomic, copy, readonly) NSString *cartType;

@property (nonatomic, copy, readonly) NSString *totalAmt;
@property (nonatomic, copy, readonly) NSString *totalQuantity;
@property (nonatomic, copy, readonly) NSString *uniqueId;
@property (nonatomic, copy, readonly) NSString *custName;
@property (nonatomic, copy, readonly) NSString *cellphone;
@property (nonatomic, copy, readonly) NSString *appId;
@property (nonatomic, copy, readonly) NSString *contractId ;
@property (nonatomic, copy, readonly) NSString *crProdId;
@property (nonatomic, copy, readonly) NSString *crProdName;
@property (nonatomic, copy, readonly) NSString *curCode;
@property (nonatomic, copy, readonly) NSString *loanAmt;
@property (nonatomic, copy, readonly) NSString *loanTerm;
@property (nonatomic, copy, readonly) NSString *mthlyPmtAmt ;
@property (nonatomic, copy, readonly) NSString *isDownPmt;
@property (nonatomic, copy, readonly) NSString *downPmtPct;
@property (nonatomic, copy, readonly) NSString *downPmt;
@property (nonatomic, copy, readonly) NSString *valueAddedSvc;
@property (nonatomic, strong, readonly) NSArray *cmdtyList;
@property (nonatomic, strong, readonly) MSFMyOrderDetailTravelViewModel *orderTravelDto;
@property (nonatomic, strong, readonly) NSArray *travelCompanInfoList;

- (instancetype)initWithServices:(id)services appNo:(NSString *)appNo;

@end
