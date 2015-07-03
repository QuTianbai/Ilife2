//
// MSFBannersViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBannersViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFClient+MSFAdver.h"
#import "MSFAdver.h"

@interface MSFBannersViewModel ()

@property(nonatomic,strong) NSArray *banners;
@property(nonatomic,strong,readwrite) RACSubject *updateContentSignal;

@end

@implementation MSFBannersViewModel

#pragma mark - Lifecycle

- (instancetype)initWithClient:(MSFClient *)client {
  self = [super init];
  if (!self) {
    return nil;
  }
  _client = client;
  _updateContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFBannersViewModel updateContentSignal"];
  
  @weakify(self)
  [self.didBecomeActiveSignal subscribeNext:^(id x) {
    @strongify(self)
    [[[self.client
      fetchAdverWithCategory:@"1"]
      collect]
      subscribeNext:^(id x) {
        self.banners = x;
        [(RACSubject *)self.updateContentSignal sendNext:nil];
      }];
  }];
  
  return self;
}

#pragma mark - Public

- (NSInteger)numberOfSections {
  return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
  return self.banners.count;
}

- (NSURL *)imageURLAtIndexPath:(NSIndexPath *)indexPath {
  MSFAdver *ad = [self bannerItemModelAtIndexPath:indexPath];
  
  return ad.imgURL;
}

- (NSURL *)HTMLURLAtIndexPath:(NSIndexPath *)indexPath {
  MSFAdver *ad = [self bannerItemModelAtIndexPath:indexPath];
  
  return ad.adURL;
}

#pragma mark - Private

- (MSFAdver *)bannerItemModelAtIndexPath:(NSIndexPath *)indexPath {
  return self.banners[indexPath.item];
}

@end
