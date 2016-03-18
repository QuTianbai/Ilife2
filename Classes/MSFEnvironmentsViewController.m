//
// MSFUtilsViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEnvironmentsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFEnvironmentViewController.h"

@implementation MSFEnvironmentsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"环境切换";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:nil action:nil];
	@weakify(self)
	self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self dismissViewControllerAnimated:YES completion:nil];
		return RACSignal.empty;
	}];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:nil action:nil];
	self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		MSFEnvironmentViewController *detailsViewController = [[MSFEnvironmentViewController alloc] init];
		[self.navigationController pushViewController:detailsViewController animated:YES];
		return RACSignal.empty;
	}];
	
	[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDelegate UITableViewDataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[NSUserDefaults.standardUserDefaults objectForKey:@"test_urls"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = [[NSUserDefaults.standardUserDefaults objectForKey:@"test_urls"] objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否更换到当前环境?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *x) {
		if (x.integerValue == 1) {
			[NSUserDefaults.standardUserDefaults setObject:[[NSUserDefaults.standardUserDefaults objectForKey:@"test_urls"] objectAtIndex:indexPath.row] forKey:@"test_url"];
			[NSUserDefaults.standardUserDefaults synchronize];
		}
	}];
	[alertView show];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSMutableArray *URLs = [[NSUserDefaults.standardUserDefaults objectForKey:@"test_urls"] mutableCopy];
		[URLs removeObject:[[NSUserDefaults.standardUserDefaults objectForKey:@"test_urls"] objectAtIndex:indexPath.row]];
		[NSUserDefaults.standardUserDefaults setObject:URLs forKey:@"test_urls"];
		[NSUserDefaults.standardUserDefaults synchronize];
		[self.tableView reloadData];
  }
}

@end
