//
//  MSFGroupTableViewController.m
//
//  Copyright © 2015 Zēng Liàng. All rights reserved.
//

#import "MSFGroupTableViewController.h"
#import "MSFGroupTableViewCell.h"

@interface MSFGroupTableViewController ()

@end

@implementation MSFGroupTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MSFGroupTableViewCell *cell = (MSFGroupTableViewCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
	
	if ([cell respondsToSelector:@selector(prepareForTableView:atIndexPath:)]) {
		[cell prepareForTableView:tableView atIndexPath:indexPath];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
