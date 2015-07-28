//
// UITableView+MSFActivityIndicatorViewAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "UITableView+MSFActivityIndicatorViewAdditions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>

static UIView *backupView;
static UITableViewCellSeparatorStyle backupStyle;
static UIColor *backupColor;

@implementation UITableView (MSFActivityIndicatorViewAdditions)

- (UIView *)viewWithSignal:(RACSignal *)signal message:(NSString *)message {
	UIView *view = UIView.new;
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[view addSubview:activityIndicatorView];
	
	[activityIndicatorView startAnimating];
	[activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(view);
	}];
	
	UILabel *label = UILabel.new;
	label.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	label.textColor = UIColor.darkGrayColor;
	label.numberOfLines = 2;
	label.textAlignment = NSTextAlignmentCenter;
	label.hidden = NO;
	[view addSubview:label];
	[label mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(view);
		make.left.equalTo(view).offset(30);
		make.right.equalTo(view).offset(-30);
	}];
	
	backupView = self.backgroundView;
	backupStyle = self.separatorStyle;
	backupColor = self.separatorColor;
	self.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.separatorColor = [UIColor clearColor];
	
	[signal subscribeNext:^(id x) {
		[activityIndicatorView stopAnimating];
		if ([x count] == 0) {
			label.text = message;
		} else {
			self.backgroundView = backupView;
			self.separatorStyle = backupStyle;
			self.separatorColor = backupColor;
		}
	} error:^(NSError *error) {
		 [activityIndicatorView stopAnimating];
		 label.text = error.userInfo[NSLocalizedFailureReasonErrorKey];
	}];
	
	return view;
}

@end
