//
// MSFSelectionViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RACSignal;

@interface MSFSelectionViewController : UITableViewController

@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

- (instancetype)initWithViewModel:(id)viewModel;

@property (nonatomic, strong, readonly) RACSignal *selectedSignal;

@end
