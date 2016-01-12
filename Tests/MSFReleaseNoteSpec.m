//
// MSFReleaseNoteSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFReleaseNote.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFPoster.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

QuickSpecBegin(MSFReleaseNoteSpec)

__block MSFReleaseNote *releasenote;

beforeEach(^{
  NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"releasenote" withExtension:@"json"];
  expect(URL).notTo(beNil());
  
  NSData *data = [NSData dataWithContentsOfURL:URL];
  NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
  
  releasenote = [MTLJSONAdapter modelOfClass:MSFReleaseNote.class fromJSONDictionary:representation error:nil];
});


it(@"should has status", ^{
  expect(@(releasenote.status)).to(equal(@1));
});

it(@"should has version code", ^{
  // given
	NSDate *date = [NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"];
  
  // when
  
  // then
  expect(releasenote.versionCode).to(equal(@"200"));
  expect(releasenote.versionName).to(equal(@"2.0.0"));
  expect(releasenote.updatedURL).to(equal([NSURL URLWithString:@"http://objczl.com"]));
  expect(releasenote.summary).to(equal(@"foo"));
  expect(releasenote.updatedDate).to(equal(date));
});

it(@"should has posters", ^{
	// then
	expect(releasenote.posters).to(beAKindOf([NSArray class]));
	expect(releasenote.posters.firstObject).to(beAKindOf(MSFPoster.class));
});

it(@"should has builds number", ^{
	// given
	NSString *builds = @"1.0.0.1";
	
	// when
	NSArray *buildsNumbers = [builds componentsSeparatedByString:@"."];
	
	//NSString *string = @"10010";
	
	__block NSInteger x = 0 ;
	[buildsNumbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		x += (NSUInteger)pow(10, idx + 1) * [obj integerValue];
	}];
	
	// then
	NSInteger sum = 1 * 10000 + 0 * 1000 + 0 * 100 + 1 * 10;
	expect(@(x)).to(equal(@(sum)));
	expect(buildsNumbers).to(equal(@[@"1", @"0", @"0", @"1"]));
});

QuickSpecEnd
