//
//	MSFSelectKeyValues.m
//	Cash
//
//	Created by xbm on 15/5/25.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSelectKeyValues.h"

@implementation MSFSelectKeyValues

+ (NSArray *)getSelectKeys:(NSString *)fileName {
	NSURL *url = [[NSBundle bundleForClass:self.class] URLForResource:fileName withExtension:@"json"];
	NSData *data = [NSData dataWithContentsOfURL:url];
	NSArray *reprentationArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	
	return [MTLJSONAdapter modelsOfClass:MSFSelectKeyValues.class fromJSONArray:reprentationArray error:nil];
}

#pragma mark - MSFSelectionItem

- (NSString *)title {
	return self.text;
}

- (NSString *)subtitle {
	return @"";
}

@end
