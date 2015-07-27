//
// MSFBannersViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBannersViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Adver.h"
#import "MSFAdver.h"

@interface MSFBannersViewModel ()

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong, readwrite) RACSubject *updateContentSignal;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFBannersViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_updateContentSignal = [[RACSubject subject] setNameWithFormat:@"MSFBannersViewModel updateContentSignal"];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[self.services.httpClient
			fetchAdverWithCategory:@"1"]
			collect]
			subscribeNext:^(id x) {
				self.banners = x;
				[(RACSubject *)self.updateContentSignal sendNext:nil];
			}
			error:^(NSError *error) {
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

- (NSString *)imageNameAtIndexPath:(NSIndexPath *)indexPath {
	MSFAdver *ad = [self bannerItemModelAtIndexPath:indexPath];
	return ad.imageName;
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
