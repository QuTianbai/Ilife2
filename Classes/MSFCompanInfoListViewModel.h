//
//  MSFCompanInfoListViewModel.h
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFCompanInfoListViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *companName;
@property (nonatomic, copy, readonly) NSString *companCellphone;
@property (nonatomic, copy, readonly) NSString *companCertId;
@property (nonatomic, copy, readonly) NSString *companRelationship;

- (instancetype)initWithModel:(id)model;

@end
