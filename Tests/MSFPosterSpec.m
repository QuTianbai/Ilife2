//
// MSFPosterSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPoster.h"

QuickSpecBegin(MSFPosterSpec)

NSDictionary *representation = @{
	@"id": @1,
	@"picUrl": @"http://foo.png",
	@"timeStart": @"2015-10-19 10:00:00",
	@"timeEnd": @"2015-10-20 10:00:00",
};

__block MSFPoster *poster;

beforeEach(^{
	poster = [MTLJSONAdapter modelOfClass:[MSFPoster class] fromJSONDictionary:representation error:nil];
	expect(poster).notTo(beNil());
});

it(@"should initialize", ^{
	// given
	NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
	dateformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	
	// when
	NSDate *expectStartDate = [dateformatter dateFromString:@"2015-10-19 10:00:00"];
	NSDate *expectEndDate = [dateformatter dateFromString:@"2015-10-20 10:00:00"];
  // then
	expect(poster.objectID).to(equal(@"1"));
	expect(poster.photoURL).to(equal([NSURL URLWithString:@"http://foo.png"]));
	expect(poster.startDate).to(equal(expectStartDate));
	expect(poster.endDate).to(equal(expectEndDate));
});

it(@"should diffrent with id", ^{
	// given
	MSFPoster *poster1 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"1"} error:nil];
	MSFPoster *poster2 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"2"} error:nil];
	
	// then
	expect(poster1).notTo(equal(poster2));
});

it(@"should same with id", ^{
	// given
	MSFPoster *poster1 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"1"} error:nil];
	MSFPoster *poster2 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"1"} error:nil];
	
	// then
	expect(poster1).to(equal(poster2));
});

QuickSpecEnd
