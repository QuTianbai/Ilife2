//
// MSFBarcodeScanViewControllerDelegate.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZXResult;
@class MSFBarcodeScanViewController;

@protocol MSFBarcodeScanViewControllerDelegate <NSObject>

- (void)barcodeScanControllerDidCancel:(MSFBarcodeScanViewController *)barcodeViewController;
- (void)barcodeScanController:(MSFBarcodeScanViewController *)barcodeViewController didFinishScanningMediaWithResult:(ZXResult *)barcodeViewController;

@end
