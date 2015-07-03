//
// MSFSelectionViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSelectionViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionTableViewCell.h"

@interface MSFSelectionViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) MSFSelectionViewModel *viewModel;
@property(nonatomic,strong,readwrite) RACSubject *selectedSignal;

@end

@implementation MSFSelectionViewController

#pragma mark - MSFReactiveView

- (instancetype)initWithViewModel:(id)viewModel {
  if (!(self = [super initWithStyle:UITableViewStylePlain])) {
    return nil;
  }
  self.viewModel = viewModel;
  self.selectedSignal = [[RACSubject subject] setNameWithFormat:@"MSFSelectionViewController `selectedSignal`"];
  
  return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableFooterView = UIView.new;
  self.tableView.tableHeaderView = UIView.new;
  [self.tableView registerClass:MSFSelectionTableViewCell.class forCellReuseIdentifier:@"Cell"];
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
  cell.accessoryType = self.accessoryType;
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [(RACSubject *)self.selectedSignal sendNext:[self.viewModel modelForIndexPath:indexPath]];
}

@end
