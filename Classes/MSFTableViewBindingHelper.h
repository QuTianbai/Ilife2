//
//  RWTableViewBindingHelper.h
//  RWTwitterSearch
//
//  Created by Colin Eberhardt on 24/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

/// A helper class for binding view models with NSArray properties to a UITableView.
@interface MSFTableViewBindingHelper : NSObject

// forwards the UITableViewDelegate methods
@property (weak, nonatomic) id<UITableViewDelegate> delegate;

// Create MSFTableViewBindingHelper instance with custom xib cell file
//
// tableView       - The UITableView instance
// source	         - The singal will send array
// selection		   - The select action
// templateCellNib - the xib file
//
// Returns a instance of MSFTableViewBindingHelper
- (instancetype)initWithTableView:(UITableView *)tableView
										 sourceSignal:(RACSignal *)source
								 selectionCommand:(RACCommand *)selection
										 templateCell:(UINib *)templateCellNib;

// Create MSFTableViewBindingHelper instance from custom cell class
//
// tableView         - The UITableView instance
// source	           - The singal will send array
// selection		     - The select action
// templateCellClass - the custom cell class
//
// Returns a instance of MSFTableViewBindingHelper
- (instancetype)initWithTableView:(UITableView *)tableView
										 sourceSignal:(RACSignal *)source
								 selectionCommand:(RACCommand *)selection
										registerClass:(Class)templateCellClass;

+ (instancetype)bindingHelperForTableView:(UITableView *)tableView
														 sourceSignal:(RACSignal *)source
												 selectionCommand:(RACCommand *)selection
														 templateCell:(UINib *)templateCellNib;

@end
