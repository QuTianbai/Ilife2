//
//  MSFCartSwitchCell.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartSwitchCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <ZSWTappableLabel/ZSWTappableLabel.h>
#import <ZSWTaggedString/ZSWTaggedString.h>
#import <KGModal/KGModal.h>
#import "MSFCartViewModel.h"
#import "UIColor+Utils.h"

@interface MSFCartSwitchCell ()<ZSWTappableLabelTapDelegate>

@property (nonatomic, strong) MSFCartViewModel *viewModel;

@end

@implementation MSFCartSwitchCell

- (void)dealloc {
	NSLog(@"dealloc : MSFCartSwitchCell");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UILabel *label = [[UILabel alloc] init];
		label.font = [UIFont systemFontOfSize:15];
		label.text = @"是否加入寿险计划";
		[self.contentView addSubview:label];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setBackgroundImage:[UIImage imageNamed:@"icon-cloze-question.png"] forState:UIControlStateNormal];
		[self.contentView addSubview:button];
		
		UISwitch *switchInsurance = [[UISwitch alloc] init];
		switchInsurance.on = YES;
		switchInsurance.tag = 100;
		[self.contentView addSubview:switchInsurance];
		
		[label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.contentView).offset(15);
			make.centerY.equalTo(self.contentView);
		}];
		[button mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(label.mas_right).offset(5);
			make.centerY.equalTo(self.contentView);
			make.width.height.equalTo(@20);
		}];
		[switchInsurance mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.contentView).offset(-8);
			make.centerY.equalTo(self.contentView);
		}];
		
		[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
			UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 390)];
			contentView.backgroundColor = [UIColor whiteColor];
			
			UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 80, 20)];
			titleLabel.textColor = [UIColor themeColorNew];
			titleLabel.font = [UIFont boldSystemFontOfSize:18];
			titleLabel.text = @"寿险条约";
			[contentView addSubview:titleLabel];
			
			UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 40, contentView.frame.size.width-16, 1)];
			line.backgroundColor = [UIColor themeColorNew];
			[contentView addSubview:line];
			
			NSString *path = [[NSBundle mainBundle] pathForResource:@"life-insurance" ofType:nil];
			NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
			ZSWTappableLabel *label = [[ZSWTappableLabel alloc] initWithFrame:CGRectMake(8, 40, contentView.frame.size.width-8, contentView.frame.size.height-40)];
			label.numberOfLines = 0;
			label.font = [UIFont systemFontOfSize:15];
			label.tapDelegate = self;
			
			ZSWTaggedStringOptions *options = [ZSWTaggedStringOptions defaultOptions];
			[options setAttributes:@{ZSWTappableLabelTappableRegionAttributeName: @YES,
															 ZSWTappableLabelHighlightedBackgroundAttributeName: [UIColor lightGrayColor],
															 ZSWTappableLabelHighlightedForegroundAttributeName: [UIColor whiteColor],
															 NSForegroundColorAttributeName: [UIColor themeColorNew],
															 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
															 @"URL": [NSURL URLWithString:@"http://www.msxf.com/msfinance/page/about/insuranceInfo.htm"],
															 } forTagName:@"link"];
			label.attributedText = [[ZSWTaggedString stringWithString:string] attributedStringWithOptions:options];
			[contentView addSubview:label];
			[[KGModal sharedInstance] setCloseButtonLocation:KGModalCloseButtonLocationRight];
			[[KGModal sharedInstance] setModalBackgroundColor:[UIColor whiteColor]];
			[[KGModal sharedInstance] showWithContentView:contentView andAnimated:YES];
		}];
		
	}
	return self;
}

- (void)bindViewModel:(MSFCartViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath {
	_viewModel = viewModel;
	UISwitch *switchInsurance = (UISwitch *)[self.contentView viewWithTag:100];
	RACChannelTerminal *insurance = RACChannelTo(viewModel, joinInsurance);
	RAC(switchInsurance, on) = insurance;
	[[switchInsurance.rac_newOnChannel takeUntil:self.rac_prepareForReuseSignal] subscribe:insurance];
}

- (void)tappableLabel:(ZSWTappableLabel *)tappableLabel tappedAtIndex:(NSInteger)idx withAttributes:(NSDictionary *)attributes {
	[[KGModal sharedInstance] hideWithCompletionBlock:^{
		[self.viewModel.executeInsuranceCommand execute:nil];
	}];
}

@end
