#import <XCTest/XCTest.h>
#import "NimbleSpecHelper.h"

@interface ObjCHaveCountTest : XCTestCase

@end

@implementation ObjCHaveCountTest

- (void)testHaveCountForNSArray {
    expect(@[@1, @2, @3]).to(haveCount(@3));
    expect(@[@1, @2, @3]).notTo(haveCount(@1));

    expect(@[]).to(haveCount(@0));
    expect(@[@1]).notTo(haveCount(@0));

    expectFailureMessage(@"expected to have (1,2,3) with count 3, got 1", ^{
        expect(@[@1, @2, @3]).to(haveCount(@1));
    });

    expectFailureMessage(@"expected to not have (1,2,3) with count 3, got 3", ^{
        expect(@[@1, @2, @3]).notTo(haveCount(@3));
    });

}

- (void)testHaveCountForNSDictionary {
    expect(@{@"1":@1, @"2":@2, @"3":@3}).to(haveCount(@3));
    expect(@{@"1":@1, @"2":@2, @"3":@3}).notTo(haveCount(@1));

    expectFailureMessage(@"expected to have {1 = 1;2 = 2;3 = 3;} with count 3, got 1", ^{
        expect(@{@"1":@1, @"2":@2, @"3":@3}).to(haveCount(@1));
    });

    expectFailureMessage(@"expected to not have {1 = 1;2 = 2;3 = 3;} with count 3, got 3", ^{
        expect(@{@"1":@1, @"2":@2, @"3":@3}).notTo(haveCount(@3));
    });
}

- (void)testHaveCountForNSHashtable {
    NSHashTable *const table = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    [table addObject:@1];
    [table addObject:@2];
    [table addObject:@3];

    expect(table).to(haveCount(@3));
    expect(table).notTo(haveCount(@1));

    expectFailureMessage(@"expected to have NSHashTable {[2] 2[12] 1[13] 3}with count 3, got 1", ^{
        expect(table).to(haveCount(@1));
    });

    expectFailureMessage(@"expected to not have NSHashTable {[2] 2[12] 1[13] 3}with count 3, got 3", ^{
        expect(table).notTo(haveCount(@3));
    });
}

- (void)testHaveCountForNSSet {
    NSSet *const set = [NSSet setWithArray:@[@1, @2, @3]];

    expect(set).to(haveCount(@3));
    expect(set).notTo(haveCount(@1));

    expectFailureMessage(@"expected to have {(3,1,2)} with count 3, got 1", ^{
        expect(set).to(haveCount(@1));
    });

    expectFailureMessage(@"expected to not have {(3,1,2)} with count 3, got 3", ^{
        expect(set).notTo(haveCount(@3));
    });
}

- (void)testHaveCountForUnsupportedTypes {
    expectFailureMessage(@"expected to get type of NSArray, NSSet, NSDictionary, or NSHashTable, got __NSCFConstantString", ^{
        expect(@"string").to(haveCount(@6));
    });

    expectFailureMessage(@"expected to get type of NSArray, NSSet, NSDictionary, or NSHashTable, got __NSCFNumber", ^{
        expect(@1).to(haveCount(@6));
    });
}

@end
