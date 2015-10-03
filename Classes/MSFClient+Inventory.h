//
// MSFClient+Inventory.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplicationResponse;
@class MSFInventory;

@interface MSFClient (Inventory)

- (RACSignal *)fetchAttachmentsWithCredit:(MSFApplicationResponse *)credit __deprecated_msg("Unused");
- (RACSignal *)updateInventory:(MSFInventory *)inventory __deprecated_msg("Unused 2.0");

@end
