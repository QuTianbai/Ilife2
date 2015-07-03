//
// MSFReleaseNoteSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFReleaseNote.h"
#import "MSFVersion.h"

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
  
  // when
  
  // then
  expect(releasenote.version.code).to(equal(@"10001"));
  expect(releasenote.version.name).to(equal(@"1.0.0"));
  expect(releasenote.version.channel).to(equal(@""));
  expect(releasenote.version.iconURL).to(equal([NSURL URLWithString:@"http://icon.com"]));
  expect(releasenote.version.updateURL).to(equal([NSURL URLWithString:@"http://update.com"]));
  expect(releasenote.version.summary).to(equal(@"test"));
  expect(releasenote.version.date).to(equal(@"2015-05-03T15:38:45Z"));
});

QuickSpecEnd
