//
//	MSFReactiveView.h
//	Cash
//
//	Created by xbm on 15/5/31.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MSFReactiveView <NSObject>

// MSFReactiveView protocol for viewModel send from previous view to next view
//
// viewModel - The viewModel use to pass to next view
- (void)bindViewModel:(id)viewModel;

@end
