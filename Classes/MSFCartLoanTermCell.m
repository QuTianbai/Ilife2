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

@interface MSFCartCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSString *content;

@end

@implementation MSFCartCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.layer.borderColor = UIColor.borderColor.CGColor;
		self.layer.borderWidth = 1.f;
		self.layer.cornerRadius = 5.f;
		
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize:15];
		label.textAlignment = NSTextAlignmentCenter;
		label.tag = 100;
		label.textColor = UIColor.borderColor;
		[self.contentView addSubview:label];
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self.contentView);
		}];
	}
	return self;
}

- (void)setContent:(NSString *)content {
	_content = content;
	UILabel *label = (UILabel *)[self.contentView viewWithTag:100];
	label.text = content;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	UILabel *label = (UILabel *)[self.contentView viewWithTag:100];
	if (selected) {
		self.layer.borderColor = UIColor.themeColorNew.CGColor;
		label.textColor = UIColor.themeColorNew;
	} else {
		self.layer.borderColor = UIColor.borderColor.CGColor;
		label.textColor = UIColor.borderColor;
	}
}

@end

@interface MSFCartLoanTermCell ()
<UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) MSFCartViewModel *viewModel;

@end

@implementation MSFCartLoanTermCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont systemFontOfSize:15];
		title.text = @"贷款期数";
		[self.contentView addSubview:title];
		
		CGFloat margin = 15.f;
		CGFloat width = ([UIScreen mainScreen].bounds.size.width - margin * 3 - 40.f) / 3;
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
		layout.minimumInteritemSpacing = 0;
		layout.minimumLineSpacing = 10.f;
		layout.sectionInset = UIEdgeInsetsMake(0, margin, margin, margin);
		layout.itemSize = CGSizeMake(width, 40.f);
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
		collection.backgroundColor = UIColor.clearColor;
		collection.delegate = self;
		collection.dataSource = self;
		[collection registerClass:MSFCartCollectionViewCell.class forCellWithReuseIdentifier:@"MSFCartCollectionViewCell"];
		[self.contentView addSubview:collection];
		self.collection = collection;
		
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.contentView);
			make.left.equalTo(self.contentView).offset(15);
			make.height.equalTo(@44);
		}];
		[collection mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.right.equalTo(self.contentView);
			make.top.equalTo(title.mas_bottom);
			make.height.equalTo(@55);
		}];
	}
	return self;
}

- (void)bindViewModel:(MSFCartViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	_viewModel = viewModel;
	@weakify(self)
	[[RACObserve(self, viewModel.terms) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id x) {
		@strongify(self)
		[self.collection reloadData];
		NSInteger index = [self.viewModel.terms indexOfObject:self.viewModel.term];
		[self.collection selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
	}];
	RAC(self, viewModel.term) = [[RACObserve(self, collection.indexPathsForSelectedItems.firstObject) takeUntil:self.rac_prepareForReuseSignal] map:^id(NSIndexPath *value) {
		return self.viewModel.terms[value.row];
	}];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.viewModel.terms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSFCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFCartCollectionViewCell" forIndexPath:indexPath];
	NSString *term = self.viewModel.terms[indexPath.row];
	cell.content = [NSString stringWithFormat:@"%@期", term];
	return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//	NSString *term = self.viewModel.terms[indexPath.row];
//	self.viewModel.term = term;
//}

@end
