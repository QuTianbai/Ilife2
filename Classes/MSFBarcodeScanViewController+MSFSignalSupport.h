//
// MSFBarcodeScanViewController+MSFSignalSupport.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBarcodeScanViewController.h"

@class RACDelegateProxy;
@class RACSignal;

@interface MSFBarcodeScanViewController (MSFSignalSupport)

@property (nonatomic, strong, readonly) RACDelegateProxy *msf_delegateProxy;

- (RACSignal *)msf_barcodeScannedSignal;

@end
