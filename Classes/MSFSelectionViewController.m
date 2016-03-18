//
// MSFSelectionViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionTableViewCell.h"

@interface MSFSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) MSFSelectionViewModel *viewModel;
@property (nonatomic, strong, readwrite) RACSignal *selectedSignal;

@end

@implementation MSFSelectionViewController

#pragma mark - MSFReactiveView

- (instancetype)initWithViewModel:(id)viewModel {
	if (!(self = [super initWithStyle:UITableViewStylePlain])) {
		return nil;
	}
	_viewModel = viewModel;
	self.selectedSignal = [[RACSubject subject] setNameWithFormat:@"MSFSelectionViewController -selectedSignal"];
	
	return self;
}

#pragma mark - Lifecycle

- (void)dealloc {
#if DEBUG
	NSLog(@"MSFSelectionViewController `-dealloc`");
#endif
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.tableFooterView = UIView.new;
	self.tableView.tableHeaderView = UIView.new;
	[self.tableView registerClass:MSFSelectionTableViewCell.class forCellReuseIdentifier:@"Cell"];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn-back-nav.png"] style:UIBarButtonItemStyleDone target:nil action:nil];
	@weakify(self)
	self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self.navigationController popViewControllerAnimated:YES];
		[(RACSubject *)self.viewModel.cancelSignal sendNext:nil];
		return [RACSignal empty];
	}];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.viewModel.numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.viewModel numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MSFSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	cell.textLabel.text = [self.viewModel titleForIndexPath:indexPath];
	cell.detailTextLabel.text = [self.viewModel subtitleForIndexPath:indexPath];
	
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[(RACSubject *)self.viewModel.selectedSignal sendNext:[self.viewModel modelForIndexPath:indexPath]];
	[(RACSubject *)self.selectedSignal sendNext:[self.viewModel modelForIndexPath:indexPath]];
}

@end
