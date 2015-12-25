//
//  MSFCartLoanTermCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartLoanTermCell.h"
#import <Masonry/Masonry.h>
#import "MSFOrderEditViewModel.h"
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
@property (nonatomic, strong) MSFOrderEditViewModel *viewModel;

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

- (void)bindViewModel:(MSFOrderEditViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	_viewModel = viewModel;
	[self.collection reloadData];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.viewModel.loanTerms.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	MSFCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MSFCartCollectionViewCell" forIndexPath:indexPath];
	NSDictionary *term = self.viewModel.loanTerms[indexPath.row];
	NSString *content = [NSString stringWithFormat:@"￥%@×%@期", term[@"price"], term[@"term"]];
	cell.content = content;
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

@end
