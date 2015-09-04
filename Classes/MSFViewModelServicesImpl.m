//
// MSFViewModelServicesImpl.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFViewModelServicesImpl.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

#import "MSFClient.h"
#import "MSFUtils.h"
#import "UIWindow+PazLabs.h"

#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFLoginViewController.h"

#import "MSFClozeViewModel.h"
#import "MSFClozeViewController.h"

#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"

#import "MSFWebViewModel.h"
#import "MSFWebViewController.h"

#import "MSFLocationModel.h"

#import "MSFInventoryViewModel.h"
#import "MSFCertificatesCollectionViewController.h"
#import "MSFConfirmContactViewModel.h"
#import "MSFConfirmContractViewController.h"

#import <CZPhotoPickerController/CZPhotoPickerController.h>

@implementation MSFViewModelServicesImpl

#pragma mark - Private

- (UIViewController *)visibleViewController {
	return [[[UIApplication sharedApplication] delegate] window].visibleViewController;
}

- (UINavigationController *)navigationController {
	return [[[[UIApplication sharedApplication] delegate] window].visibleViewController navigationController];
}

#pragma mark - MSFViewModelServices

- (void)pushViewModel:(id)viewModel {
	id viewController;
  
  if ([viewModel isKindOfClass:MSFSelectionViewModel.class]) {
    viewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
  } else if ([viewModel isKindOfClass:MSFLoanAgreementViewModel.class]) {
    viewController = [[MSFLoanAgreementController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
  } else if ([viewModel isKindOfClass:MSFWebViewModel.class]) {
		viewController = [[MSFWebViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
  } else if ([viewModel isKindOfClass:MSFInventoryViewModel.class]) {
		viewController = [[MSFCertificatesCollectionViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFConfirmContactViewModel class]]) {
		viewController = [[MSFConfirmContractViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else {
    NSLog(@"an unknown ViewModel was pushed!");
  }
  
  [self.navigationController pushViewController:viewController animated:YES];
}

- (void)popViewModel {
	if ([self.navigationController.topViewController isKindOfClass:MSFSelectionViewController.class]) {
		[[self.navigationController.viewControllers reverseObjectEnumerator].allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if (![obj isKindOfClass:MSFSelectionViewController.class]) {
				[self.navigationController popToViewController:obj animated:YES];
				*stop = YES;
			}
		}];
  } else {
    NSLog(@"an unknown ViewModel was pop!");
  }
}

- (void)presentViewModel:(id)viewModel {
	id viewController;
  
	if ([viewModel isKindOfClass:MSFAuthorizeViewModel.class]) {
		MSFLoginViewController *loginViewController = [[MSFLoginViewController alloc] initWithViewModel:viewModel];
		viewController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
	} else if ([viewModel isKindOfClass:MSFClozeViewModel.class]) {
    MSFClozeViewController *clozeViewController = [[MSFClozeViewController alloc] initWithViewModel:viewModel];
		viewController = [[UINavigationController alloc] initWithRootViewController:clozeViewController];
	} else {
    NSLog(@"an unknown ViewModel was present!");
  }
  
  [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (MSFClient *)httpClient {
	return MSFUtils.httpClient;
}

- (MSFServer *)server {
	return MSFUtils.server;
}

- (RACSignal *)fetchLocationWithLatitude:(double)latitude longitude:(double)longitude {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?ak=sTLArkR5mCiQrGcflln8li7c&location=%f,%f&output=json&pois=1", latitude, longitude]];
		[[NSURLConnection rac_sendAsynchronousRequest:[NSURLRequest requestWithURL:URL]] subscribeNext:^(id x) {
			RACTupleUnpack(NSHTTPURLResponse *response, NSData *data) = x;
			if (response.statusCode != 200) {
				[subscriber sendCompleted];
			} else {
				NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
				MSFLocationModel *model = [MTLJSONAdapter modelOfClass:MSFLocationModel.class fromJSONDictionary:representation	error:nil];
				[subscriber sendNext:model];
				[subscriber sendCompleted];
			}
		}];
	
		return nil;
	}];
	return nil;
}

- (RACSignal *)takePicture {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		CZPhotoPickerController *pickerController =
			[[CZPhotoPickerController alloc] initWithPresentingViewController:self.navigationController withCompletionBlock:^(UIImagePickerController *imagePickerController, NSDictionary *imageInfoDict) {
				UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage] ?: imageInfoDict[UIImagePickerControllerOriginalImage];
				if (image) {
					[subscriber sendNext:image];
				}
				[subscriber sendCompleted];
		}];
		[pickerController showFromTabBar:[self navigationController].tabBarController.tabBar];
		return [RACDisposable disposableWithBlock:^{
			[pickerController dismissAnimated:YES];
		}];
	}];
}

@end
