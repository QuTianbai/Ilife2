//
// MSFBarcodeScanViewController+MSFSignalSupport.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBarcodeScanViewController+MSFSignalSupport.h"
#import "RACDelegateProxy.h"
#import "RACSignal+Operations.h"
#import "NSObject+RACDeallocating.h"
#import "NSObject+RACDescription.h"
#import <objc/runtime.h>
#import <ZXingObjC/ZXingObjC.h>

@implementation MSFBarcodeScanViewController (MSFSignalSupport)

static void RACUseDelegateProxy(MSFBarcodeScanViewController *self) {
	if (self.delegate == self.msf_delegateProxy) return;
    
	self.msf_delegateProxy.rac_proxiedDelegate = self.delegate;
	self.delegate = (id)self.msf_delegateProxy;
}

- (RACDelegateProxy *)msf_delegateProxy {
	RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
	if (proxy == nil) {
		proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(MSFBarcodeScanViewControllerDelegate)];
		objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
    
	return proxy;
}

- (RACSignal *)msf_barcodeScannedSignal {
	RACSignal *pickerCancelledSignal = [[self.msf_delegateProxy
		signalForSelector:@selector(barcodeScanControllerDidCancel:)]
		merge:self.rac_willDeallocSignal];
		
	RACSignal *barcodeScannerSignal = [[[[self.msf_delegateProxy
		signalForSelector:@selector(barcodeScanController:didFinishScanningMediaWithResult:)]
		reduceEach:^(MSFBarcodeScanViewController *barcodeScanController, ZXResult *result) {
			return result;
		}]
		takeUntil:pickerCancelledSignal]
		setNameWithFormat:@"%@ -msf_barcodeScannedSignal", [self rac_description]];
    
	RACUseDelegateProxy(self);
    
	return barcodeScannerSignal;
}

@end
