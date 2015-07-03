//
//  MSFClient+AccordToNperLists.h
//  Cash
//
//  Created by xutian on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import "MSFApplyList.h"

@interface MSFClient (AccordToNperLists)

- (RACSignal *)fetchAccordToNperLists:(MSFApplyList *)applyListID;

@end
