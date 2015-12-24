//
// MSFViewModelServicesImpl.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFViewModelServicesImpl.h"
#import <CZPhotoPickerController/CZPhotoPickerController.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <AVFoundation/AVFoundation.h>
#import <CZPhotoPickerController/CZPhotoPickerPermissionAlert.h>

#import "MSFClient.h"
#import "MSFServer.h"
#import "MSFUser.h"
#import "UIWindow+PazLabs.h"

#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFLoginViewController.h"
#import "MSFSetTradePasswordTableViewController.h"

#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"

#import "MSFLifeInsuranceViewModel.h"
#import "MSFLifeInsuranceViewController.h"

#import "MSFWebViewModel.h"
#import "MSFWebViewController.h"

#import "MSFLocationModel.h"

#import "MSFInventoryViewModel.h"
#import "MSFInventoryViewController.h"
#import "MSFConfirmContactViewModel.h"
#import "MSFConfirmContractViewController.h"

#import "MSFApplyListViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFRepaymentPlanViewController.h"
#import "MSFLoanListViewController.h"

#import "MSFRelationshipViewModel.h"
#import "MSFRelationshipViewController.h"

#import "MSFPersonalViewModel.h"
#import "MSFPersonalViewController.h"

#import "MSFProfessionalViewModel.h"
#import "MSFProfessionalViewController.h"

#import "MSFDrawCashViewModel.h"
#import "MSFDrawCashTableViewController.h"

#import "MSFRepaymentSchedulesViewModel.h"

@interface MSFViewModelServicesImpl ()

@property (nonatomic, strong) MSFClient *client;

@end

@implementation MSFViewModelServicesImpl

#pragma mark - Lifecycle

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
	MSFUser *user = [MSFUser userWithServer:MSFServer.dotComServer];
	_client = [MSFClient unauthenticatedClientWithUser:user];
  
  return self;
}

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
		viewController = [[MSFInventoryViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFConfirmContactViewModel class]]) {
		viewController = [[MSFConfirmContractViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFApplyListViewModel.class]) {
		viewController = [[MSFLoanListViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFRepaymentViewModel.class]) {
		viewController = [[MSFRepaymentPlanViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFPersonalViewModel class]]) {
		viewController = [[MSFPersonalViewController alloc] init];
		[viewController bindViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFRelationshipViewModel class]]) {
		viewController = [[MSFRelationshipViewController alloc] init];
		[viewController bindViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFProfessionalViewModel class]]) {
		viewController = [[MSFProfessionalViewController alloc] init];
		[viewController bindViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFLifeInsuranceViewModel class]]) {
		viewController = [[MSFLifeInsuranceViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:[MSFAuthorizeViewModel class]]) {
		viewController = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:MSFDrawCashViewModel.class]) {
		viewController = [[MSFDrawCashTableViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
		viewController = [[MSFDrawCashTableViewController alloc] initWithViewModel:viewModel];
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
	} else {
    NSLog(@"an unknown ViewModel was present!");
  }
  
  [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Signals

- (RACSignal *)msf_takePictureSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
			[[CZPhotoPickerPermissionAlert sharedInstance] showAlert];
			[subscriber sendError:nil];
			return nil;
		}
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		} else {
			imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		[self.visibleViewController presentViewController:imagePickerController animated:YES completion:nil];
		[imagePickerController.rac_imageSelectedSignal subscribeNext:^(NSDictionary *imageInfoDict) {
			UIImage *image = imageInfoDict[UIImagePickerControllerEditedImage] ?: imageInfoDict[UIImagePickerControllerOriginalImage];
			[subscriber sendNext:image];
			[subscriber sendCompleted];
		} completed:^{
			[subscriber sendCompleted];
		}];
		return [RACDisposable disposableWithBlock:^{
			[imagePickerController dismissViewControllerAnimated:NO completion:nil];
		}];
	}];
}

#pragma mark - Custom Accessors

- (MSFClient *)httpClient {
	return self.client;
}

- (void)setHttpClient:(MSFClient *)client {
	self.client = client;
}

@end
