//
// MSFDimensionalCodeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFDimensionalCodeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ZXingObjC/ZXingObjC.h>
#import "NSString+Hashes.h"
#import "MSFPayment.h"
#import "MSFOrderDetail.h"
#import "NSDate+UTC0800.h"

@interface MSFDimensionalCodeViewModel ()

@property (nonatomic, strong, readwrite) NSURL *dismensionalCodeURL;
@property (nonatomic, strong, readwrite) NSString *timist;
@property (nonatomic, strong) MSFPayment *payment;
@property (nonatomic, strong) MSFOrderDetail *order;
@property (nonatomic, assign) BOOL counting;
@property (nonatomic, assign) int countLength;
@property (nonatomic, strong, readwrite) RACSubject *invalidSignal;

@end

@implementation MSFDimensionalCodeViewModel

- (instancetype)initWithPayment:(MSFPayment *)payment order:(MSFOrderDetail *)order {
  self = [super init];
  if (!self) {
    return nil;
  }
	_countLength = 180;
	_timist = @"";
	_payment = payment;
	_order = order;
	_invalidSignal = [RACSubject subject];
    _dismensionalCode = @"";
	
	RAC(self, dismensionalCode) = [RACObserve(self, payment.authId) ignore:nil];
	RAC(self, title) = [RACObserve(self, payment.downPmt) map:^id(id value) {
		return [NSString stringWithFormat:@"首付 ¥%@元", value];
	}];
	RAC(self, subtitle) = [RACObserve(self, order.totalAmt) map:^id(id value) {
		return [NSString stringWithFormat:@"扫描二维码，支付商品%@元", value];
	}];
	
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		NSError *error = nil;
		ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
		ZXBitMatrix *result = [writer encode:self.dismensionalCode
																	format:kBarcodeFormatCode128
																	 width:500
																	height:180
																	 error:&error];
		if (result) {
			CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];

			// This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
			NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
			NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
			NSData *data = UIImageJPEGRepresentation([UIImage imageWithCGImage:image], 1);
			[[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
			NSURL *fileURL = [NSURL fileURLWithPath:path];
			self.dismensionalCodeURL = fileURL;
		} else {
			// NSString *errorMessage = [error localizedDescription];
			self.dismensionalCodeURL = nil;
		}
		
		RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:self.countLength] takeUntil:self.didBecomeInactiveSignal];
		__block int repetCount = self.countLength;
		[repetitiveEventSignal subscribeNext:^(id x) {
			self.timist = [NSString stringWithFormat:@"%ds后条形码失效", --repetCount];
		} completed:^{
			self.timist = @"条形码已失效";
			self.counting = NO;
			[(RACSubject *)self.invalidSignal sendNext:nil];
			[(RACSubject *)self.invalidSignal sendCompleted];
		}];
	}];
	
  return self;

}

- (instancetype)initWithModel:(MSFPayment *)model {
  self = [super init];
  if (!self) {
    return nil;
  }
	RAC(self, dismensionalCode) = RACObserve(model, authCode);
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		NSError *error = nil;
		ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
		ZXBitMatrix *result = [writer encode:self.dismensionalCode
																	format:kBarcodeFormatCode128
																	 width:500
																	height:180
																	 error:&error];
		if (result) {
			CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];

			// This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
			NSString *name = [@([[NSDate date] timeIntervalSince1970]) stringValue].md5;
			NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", name]];
			NSData *data = UIImageJPEGRepresentation([UIImage imageWithCGImage:image], 1);
			[[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
			NSURL *fileURL = [NSURL fileURLWithPath:path];
			self.dismensionalCodeURL = fileURL;
		} else {
			// NSString *errorMessage = [error localizedDescription];
			self.dismensionalCodeURL = nil;
		}
	}];
	
  return self;
}

@end
