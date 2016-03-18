//
//  MSFCreditMiddleViewController.m
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditMiddleViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCreditViewModel.h"
#import "MSFSlider.h"
#import "MSFPeriodsCollectionViewCell.h"
#import "MSFSelectionViewModel.h"
#import "MSFApplyCashViewModel.h"
#import "MSFApplyCashViewController.h"

@interface MSFCreditMiddleViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, MSFSliderDelegate>

@property (nonatomic, weak) MSFCreditViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIView *groundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *logLabel;
@property (nonatomic, weak) IBOutlet UILabel *reasonLabel;
@property (nonatomic, weak) IBOutlet UILabel *termLabel;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet MSFSlider *moneySlider;
@property (weak, nonatomic) IBOutlet UICollectionView *monthCollectionView;

@property (nonatomic, strong) MSFSelectionViewModel *selectViewModel;

@end

@implementation MSFCreditMiddleViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	RAC(self.groundView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(!(status.integerValue == MSFApplicationActivated || status.integerValue == MSFApplicationNone));
	}];
	RAC(self.contentView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @((status.integerValue == MSFApplicationActivated || status.integerValue == MSFApplicationNone));
	}];
	
	RAC(self, numberLabel.text) = RACObserve(self, viewModel.reportNumber);
	RAC(self, amountLabel.text) = RACObserve(self, viewModel.reportAmounts);
	RAC(self, termLabel.text) = RACObserve(self, viewModel.reportTerms);
	RAC(self, logLabel.text) = RACObserve(self, viewModel.reportMessage);
	RAC(self, reasonLabel.text) = RACObserve(self, viewModel.reportReason);

	self.moneySlider.delegate = self;
	self.moneySlider.hiddenAmount = YES;
	RAC(self.moneySlider, minimumValue) = [RACObserve(self.viewModel, viewModel.minMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
    return value;
  }];
  RAC(self.moneySlider, maximumValue) = [RACObserve(self.viewModel, viewModel.maxMoney) map:^id(id value) {
    if (!value) {
      return @0;
    }
    return value;
  }];
	
	@weakify(self)
	[RACObserve(self.moneySlider, minimumValue) subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.viewModel.appLmt = [@([x integerValue]) stringValue];
	}];
	
	RAC(self.viewModel, viewModel.appLmt) = [[self.moneySlider rac_newValueChannelWithNilValue:@0] map:^id(NSString *value) {
		@strongify(self)
		self.viewModel.viewModel.product = nil;
		return [NSString stringWithFormat:@"%ld", value.integerValue < 100 ?(long)self.moneySlider.minimumValue : (long)value.integerValue / 100 * 100];
	}] ;

  UICollectionViewFlowLayout *collectionFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  [collectionFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
  self.monthCollectionView.collectionViewLayout = collectionFlowLayout;
  self.monthCollectionView.showsHorizontalScrollIndicator = NO;
  self.monthCollectionView.delegate = self;
  self.monthCollectionView.dataSource = self;
  [self.monthCollectionView setBackgroundColor:[UIColor clearColor]];
  self.monthCollectionView.showsVerticalScrollIndicator = NO;
  [self.monthCollectionView registerNib:[UINib nibWithNibName:@"MSFPeriodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MSFPeriodsCollectionViewCell"];
	
	self.applyButton.rac_command = self.viewModel.excuteActionCommand;
	
	[self.viewModel.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([self.selectViewModel numberOfItemsInSection:0] != 0) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectViewModel numberOfItemsInSection:0] - 1 inSection:0];
      [self.monthCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
      self.viewModel.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
		}
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.selectViewModel numberOfItemsInSection:section];
}

- (MSFPeriodsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MSFPeriodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPeriodsCollectionViewCell" forIndexPath:indexPath];
	
  cell.text = [self.selectViewModel titleForIndexPath:indexPath];
	cell.locked = self.moneySlider.tracking;
  return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.selectViewModel numberOfItemsInSection:0] > 4) {
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 15 * 2 - 5 * 5 ) / 4.5, self.monthCollectionView.frame.size.height / 2);
  }
  return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 15 * 2 - 5 * 5 ) / 4, self.monthCollectionView.frame.size.height / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(5, 15, 5, 15);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	self.viewModel.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
}

#pragma mark - MSFSlider Delegate

- (void)startSliding {
  if (self.moneySlider.maximumValue == 0) {
    [SVProgressHUD showInfoWithStatus:@"系统繁忙，请稍后再试"];
  }
	[self.monthCollectionView reloadData];
}

- (void)getStringValue:(NSString *)stringvalue {
  if (stringvalue.integerValue == 0) self.viewModel.viewModel.product = nil;
	
	self.selectViewModel = [MSFSelectionViewModel monthsVIewModelWithMarkets:self.viewModel.viewModel.markets total:stringvalue.integerValue];
  [self.monthCollectionView reloadData];
 
  if ([self.selectViewModel numberOfItemsInSection:0] != 0) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.selectViewModel numberOfItemsInSection:0] - 1 inSection:0];
		[self.monthCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
		self.viewModel.viewModel.product = [self.selectViewModel modelForIndexPath:indexPath];
  }
}

@end
