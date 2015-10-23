//
// MSFPosterSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPoster.h"
#import "MSFServer.h"

QuickSpecBegin(MSFPosterSpec)

NSDictionary *representation = @{
	@"id": @1,
	@"picUrl": @"http://sample.com/foo.png",
	@"timeStart": @"1445220000000",
	@"timeEnd": @"1445306400000",
	@"sizes": @"480_840$1280_1920$1600_2560",
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
	NSLog(@"%f", [expectStartDate timeIntervalSince1970]);
	NSLog(@"%f", [expectEndDate timeIntervalSince1970]);
	
  // then
	expect(poster.objectID).to(equal(@"1"));
	expect(poster.photoURL).to(equal([NSURL URLWithString:@"http://sample.com/foo.png"]));
	expect(poster.startDate).to(equal(expectStartDate));
	expect(poster.endDate).to(equal(expectEndDate));
});

it(@"should diffrent with id", ^{
	// given
	MSFPoster *poster1 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"1", @"server": MSFServer.dotComServer} error:nil];
	MSFPoster *poster2 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"2", @"server": MSFServer.dotComServer} error:nil];
	
	// then
	expect(poster1).notTo(equal(poster2));
});

it(@"should same with id", ^{
	// given
	MSFPoster *poster1 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"1", @"server": MSFServer.dotComServer} error:nil];
	MSFPoster *poster2 = [[MSFPoster alloc] initWithDictionary:@{@"objectID": @"1", @"server": MSFServer.dotComServer} error:nil];
	
	// when
	NSMutableSet *items = [NSMutableSet set];
	[items addObject:poster1];
	[items addObject:poster2];
	
	// then
	expect(poster1).to(equal(poster2));
	expect(@(items.count)).to(equal(@1));
	expect(@(poster1.hash)).to(equal(@(poster2.hash)));
});

it(@"should has sizes", ^{
	// then
	expect(poster.sizes).to(equal(@"480_840$1280_1920$1600_2560"));
});

it(@"should access imageURL", ^{
	// then
	expect(poster.imageURL).to(equal([NSURL URLWithString:@"http://sample.com/foo_1600_2560.png"]));
});

QuickSpecEnd
