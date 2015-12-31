//
// MSFDimensionalCodeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFDimensionalCodeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ZXingObjC/ZXingObjC.h>
#import "MSFOrderDetail.h"
#import "NSString+Hashes.h"

@interface MSFDimensionalCodeViewModel ()

@property (nonatomic, strong, readwrite) NSURL *dismensionalCodeURL;

@end

@implementation MSFDimensionalCodeViewModel

- (instancetype)initWithModel:(MSFOrderDetail *)model {
  self = [super init];
  if (!self) {
    return nil;
  }
	RAC(self, dismensionalCode) = RACObserve(model, inOrderId);
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		NSError *error = nil;
		ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
		ZXBitMatrix *result = [writer encode:@"A string to encode"
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