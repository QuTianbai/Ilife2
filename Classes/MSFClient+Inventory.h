//
// MSFClient+Inventory.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Inventory)

- (RACSignal *)submitInventoryWithApplicaitonNo:(NSString *)applicationNo accessories:(NSDictionary *)accessories;

@end
