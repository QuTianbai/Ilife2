//
//  MSFInfinityScroll.h
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFInfinityScroll : UIView

@property (nonatomic, copy) NSInteger (^numberOfPages)();
@property (nonatomic, copy) NSURL	 *(^imageUrlAtIndex) (NSInteger index);
@property (nonatomic, copy) NSString *(^imageNameAtIndex)(NSInteger index);
@property (nonatomic, copy) void (^selectedBlock)(NSInteger index);
@property (nonatomic, assign) BOOL openPageControl;
@property (nonatomic, assign) BOOL play;//5秒一次

- (void)reloadData;

@end