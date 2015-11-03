//
// MSFUtilsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUtilsViewController.h"
#import "MSFUtils.h"

NSString *const MSFUtilsURLDidUpdateNotification = @"MSFUtilsURLDidUpdateNotification";

@implementation MSFUtilsViewController {
	NSArray *URLs;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	URLs = @[
		@"https://192.168.2.41:8443",
		@"https://192.168.2.51:8443",
		@"https://192.168.7.28",
		@"https://i.msxf.uat",
		@"https://i.msxf.test",
		@"https://i.msxf.tp",
		@"https://i.msxf.com",
		@"https://192.168.2.61",
		@"http://10.16.18.36:8081",
	];
	
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
	label.text = @"更新后请结束进程，重新开启程序!";
	self.tableView.tableFooterView = label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return URLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.text = URLs[indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[NSNotificationCenter defaultCenter] postNotificationName:MSFUtilsURLDidUpdateNotification object:URLs[indexPath.row]];
	[MSFUtils setBaseURLString:URLs[indexPath.row]];
}

@end
