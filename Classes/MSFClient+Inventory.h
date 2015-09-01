//
// MSFClient+Inventory.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplicationResponse;
@class MSFInventory;

@interface MSFClient (Inventory)

- (RACSignal *)fetchInventoryWithApplicaitonResponse:(MSFApplicationResponse *)response;
- (RACSignal *)updateInventory:(MSFInventory *)inventory;

@end
