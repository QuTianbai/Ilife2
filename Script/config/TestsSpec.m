#import <Nimble/Nimble.h>
#import <Quick/Quick.h>

QuickSpecBegin(TestsSpec)

it(@"should be false", ^{
  expect(@YES).to(beFalse());
});

QuickSpecEnd
