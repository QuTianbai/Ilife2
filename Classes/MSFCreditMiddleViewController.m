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
#import "MSFPlanViewModel.h"
#import "MSFTrial.h"

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
		return @(!(status.integerValue == MSFApplicationNone));
	}];
	RAC(self.contentView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @((status.integerValue == MSFApplicationNone));
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
	
	RAC(self, viewModel.viewModel.appLmt) = [[self.moneySlider rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(UISlider *slider) {
    self.viewModel.viewModel.isPush = NO;
    self.viewModel.viewModel.isChangTerm = NO;
    if (slider.value == slider.minimumValue) {
      return [NSString stringWithFormat:@"%d", (int)slider.minimumValue];
    }
    if (slider.value > slider.maximumValue-((int)slider.maximumValue % 500) || slider.value == slider.maximumValue) {
      return [NSString stringWithFormat:@"%d", (int)slider.maximumValue];
    }
		return [NSString stringWithFormat:@"%d", slider.value == slider.minimumValue? (int)slider.minimumValue : ((int)slider.value / 500 + 1) * 500];
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
	
	[RACObserve(self, viewModel.viewModel.viewModels) subscribeNext:^(id x) {
		@strongify(self)
		[self.monthCollectionView reloadData];
		if ([self.viewModel.viewModel viewModels].count > 0) {
      //if (self.viewModel.viewModel.trial == nil) {
      if (!self.viewModel.viewModel.isPush) {
        [self.viewModel.viewModel setTrial:[(MSFPlanViewModel *)[self.viewModel.viewModel viewModels].lastObject model]];
        if (!self.viewModel.viewModel.isChangTerm) {
          self.viewModel.viewModel.homepageIndex = [self.viewModel.viewModel viewModels].count - 1;
        }
      }
      //}
			
			[self.monthCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.viewModel.viewModel.homepageIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
		}
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [self.viewModel.viewModel viewModels].count;
}

- (MSFPeriodsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MSFPeriodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFPeriodsCollectionViewCell" forIndexPath:indexPath];
	
	MSFPlanViewModel *viewModel = [self.viewModel.viewModel viewModels][indexPath.item];
  cell.text = [NSString stringWithFormat:@"%@个月", viewModel.model.loanTerm];
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
	self.viewModel.viewModel.homepageIndex = indexPath.row;
	self.viewModel.viewModel.trial = [(MSFPlanViewModel *)[self.viewModel.viewModel viewModels][indexPath.item] model];
}

#pragma mark - MSFSlider Delegate

- (void)startSliding {
  if (self.moneySlider.maximumValue == 0) {
    [SVProgressHUD showInfoWithStatus:@"系统繁忙，请稍后再试"];
  }
	[self.monthCollectionView reloadData];
}

- (void)getStringValue:(NSString *)stringvalue {
}

@end
