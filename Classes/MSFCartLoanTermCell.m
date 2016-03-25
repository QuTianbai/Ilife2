//
//  MSFCartLoanTermCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartLoanTermCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import "MSFCartViewModel.h"
#import "UIColor+Utils.h"
#import "MSFPlan.h"
#import "MSFPlanView.h"
#import "MSFTrial.h"
#import "MSFPlanViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFCartLoanTermCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) MSFCartViewModel *viewModel;

@end

@implementation MSFCartLoanTermCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.text = @"贷款期数     每月应还款（加入寿险计划）";
		[self.contentView addSubview:title];
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView);
			make.left.equalTo(self.contentView).offset(15);
			make.height.equalTo(@44);
		}];
		
		self.picker = [[UIPickerView alloc] init];
		self.picker.delegate = self;
		self.picker.dataSource = self;
		[self.contentView addSubview:self.picker];
		[self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self.contentView);
			make.top.equalTo(title.mas_bottom);
			make.height.equalTo(@100);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFCartViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	_viewModel = viewModel;
	@weakify(self)
	[[[RACObserve(self, viewModel.viewModels) ignore:nil] takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.trial = [(MSFPlanViewModel *)self.viewModel.viewModels.lastObject model];
		[self.picker reloadAllComponents];
		[self.picker selectRow:self.viewModel.viewModels.count - 1 inComponent:0 animated:YES];
	}];
}

#pragma mark - UIPickerViewDelegate UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.viewModel.viewModels.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 30.00;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	MSFPlanView *label = (MSFPlanView *)view;
	if (!label) label = [[MSFPlanView alloc] init];
	[label bindViewModel:self.viewModel.viewModels[row]];

	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.viewModel.trial = [(MSFPlanViewModel *)self.viewModel.viewModels[row] model];
}

@end
