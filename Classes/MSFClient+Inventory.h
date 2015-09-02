//
// MSFClient+Inventory.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplicationResponse;
@class MSFInventory;

@interface MSFClient (Inventory)

- (RACSignal *)fetchAttachmentsWithCredit:(MSFApplicationResponse *)credit;
- (RACSignal *)updateInventory:(MSFInventory *)inventory;

@end
