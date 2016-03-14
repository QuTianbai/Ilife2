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
#import <Masonry/Masonry.h>
#import <ZXingObjC/ZXingObjC.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ABPeoplePickerNavigationController+RACSignalSupport.h"

#import "MSFClient.h"
#import "MSFServer.h"
#import "MSFUser.h"
#import "UIWindow+PazLabs.h"

#import "MSFSelectKeyValues.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFSetTradePasswordTableViewController.h"

#import "MSFLoanAgreementViewModel.h"
#import "MSFLoanAgreementController.h"

#import "MSFWebViewModel.h"
#import "MSFWebViewController.h"

#import "MSFInventoryViewModel.h"
#import "MSFInventoryViewController.h"
#import "MSFConfirmContractViewModel.h"
#import "MSFConfirmContractViewController.h"

#import "MSFApplyListViewModel.h"
#import "MSFRepaymentPlanViewModel.h"
#import "MSFRepaymentPlanViewController.h"

#import "MSFPersonalViewModel.h"
#import "MSFPersonalViewController.h"

#import "MSFProfessionalViewModel.h"
#import "MSFProfessionalViewController.h"

#import "MSFBarcodeScanViewController.h"
#import "MSFBarcodeScanViewController+MSFSignalSupport.h"

#import "MSFCommodityCashViewModel.h"
#import "MSFUserInfomationViewController.h"
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFCartViewModel.h"
#import "MSFCartViewController.h"
#import "MSFBankCardListViewModel.h"
#import "MSFBankCardListTableViewController.h"

#import "MSFPaymentViewModel.h"
#import "MSFRepaymentViewModel.h"
#import "MSFDrawingsViewModel.h"
#import "MSFTransactionsViewController.h"

#import "MSFInputTradePasswordViewController.h"

#import "MSFSignInViewController.h"

#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFSocialCaskApplyTableViewController.h"

#import "MSFAddBankCardViewModel.h"
#import "MSFAddBankCardTableViewController.h"

#import "MSFOrderListViewModel.h"
#import "MSFOrderListViewController.h"

#import "MSFSignUpViewController.h"
#import "MSFAuthenticateViewController.h"
#import "MSFMyOderListsViewModel.h"
#import "MSFMyOrderListContainerViewController.h"
#import "MSFMyRepaysViewModel.h"
#import "MSFMyRepayContainerViewController.h"
#import "MSFCommodityViewModel.h"

#import "MSFApplyListViewModel.h"
#import "MSFLoanListViewController.h"

#import "MSFApplyCashViewModel.h"
#import "MSFMSFApplyCashViewController.h"

@interface MSFViewModelServicesImpl () <MSFInputTradePasswordDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) MSFClient *client;

@property (nonatomic, strong) UIImagePickerController *imagePickerController DEPRECATED_ATTRIBUTE;

@property (nonatomic, strong) MSFInputTradePasswordViewController *passcodeViewController;

@end

@implementation MSFViewModelServicesImpl

#pragma mark - Lifecycle

- (instancetype)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	[self setHttpClient:[MSFClient unauthenticatedClientWithUser:[MSFUser userWithServer:MSFServer.dotComServer]]];
	_passcodeViewController = [[MSFInputTradePasswordViewController alloc] init];
	
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
	} else if ([viewModel isKindOfClass:[MSFConfirmContractViewModel class]]) {
		viewController = [[MSFConfirmContractViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFRepaymentPlanViewModel.class]) {
		viewController = [[MSFRepaymentPlanViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFPersonalViewModel class]]) {
		viewController = [[MSFPersonalViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:[MSFProfessionalViewModel class]]) {
		viewController = [[MSFProfessionalViewController alloc] initWithViewModel:viewModel];
		[viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFAuthorizeViewModel class]]) {
		if ([(MSFAuthorizeViewModel *)viewModel loginType] == MSFLoginSignUp) {
			viewController = [[MSFSignUpViewController alloc] initWithViewModel:viewModel];
		} else {
			viewController = [[MSFSetTradePasswordTableViewController alloc] initWithViewModel:viewModel];
		}
	} else if ([viewModel isKindOfClass:MSFBankCardListViewModel.class]) {
		viewController = [[MSFBankCardListTableViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:MSFRepaymentViewModel.class] || [viewModel isKindOfClass:MSFPaymentViewModel.class] || [viewModel isKindOfClass:MSFDrawingsViewModel.class]) {
		viewController = [[MSFTransactionsViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
		viewController = [[MSFSocialCaskApplyTableViewController alloc] initWithViewModel:viewModel];
		[(UIViewController *)viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFOrderListViewModel.class]) {
		viewController = [[MSFOrderListViewController alloc] initWithViewModel:viewModel];
		[(UIViewController *)viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFAddBankCardViewModel.class]) {
		viewController = [UIStoryboard storyboardWithName:@"AddBankCard" bundle:nil].instantiateInitialViewController;
		((MSFAddBankCardTableViewController *)viewController).viewModel = viewModel;
		[(UIViewController *)viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFMyOderListsViewModel.class]) {
		viewController = [[MSFMyOrderListContainerViewController alloc] initWithViewModel:viewModel];
		[(UIViewController *)viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:MSFMyRepaysViewModel.class]) {
		viewController = [[MSFMyRepayContainerViewController alloc] initWithViewModel:viewModel];
		[(UIViewController *)viewController setHidesBottomBarWhenPushed:YES];
	} else if ([viewModel isKindOfClass:[MSFCartViewModel class]]) {
		viewController = [[MSFCartViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:MSFApplyListViewModel.class]) {
		viewController = [[MSFLoanListViewController alloc] initWithViewModel:viewModel];
	} else if ([viewModel isKindOfClass:MSFApplyCashViewModel.class]) {
		viewController = [[MSFMSFApplyCashViewController alloc] initWithViewModel:viewModel];
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
		MSFAuthenticateViewController *loginViewController = [[MSFAuthenticateViewController alloc] initWithViewModel:viewModel];
		viewController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
		view.backgroundColor = UIColor.blackColor;
		[[(UIViewController *)viewController view] addSubview:view];
	} else {
		NSLog(@"an unknown ViewModel was present!");
	}
	
	[self.navigationController presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - Signals

- (RACSignal *)msf_takePictureSignal:(BOOL)frontOnly {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
			[[CZPhotoPickerPermissionAlert sharedInstance] showAlert];
			[subscriber sendError:nil];
			return nil;
		}
		
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
			imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
			if (frontOnly) {
				imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
				UIView *view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 80, 40)];
				view.backgroundColor = UIColor.blackColor;
				[imagePickerController.view addSubview:view];
				
				UIImage *avatar = [UIImage imageNamed:@"faceMask_bg"];
				UIImageView *img = [[UIImageView alloc] initWithImage:avatar];
				[imagePickerController.view addSubview:img];
				[img mas_makeConstraints:^(MASConstraintMaker *make) {
					make.center.mas_equalTo(imagePickerController.view);
					make.size.mas_equalTo(CGSizeMake(297, 360));
				}];
			}
		} else {
			UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
			view.backgroundColor = UIColor.blackColor;
			[imagePickerController.view addSubview:view];
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

- (void)ImagePickerControllerWithImage:(id)iamge {
}

- (RACSignal *)msf_barcodeScanSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
		if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
			[[CZPhotoPickerPermissionAlert sharedInstance] showAlert];
			[subscriber sendError:nil];
			return nil;
		}
		MSFBarcodeScanViewController *vc = [[MSFBarcodeScanViewController alloc] init];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
		[self.visibleViewController presentViewController:navigationController animated:YES completion:nil];
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
		view.backgroundColor = UIColor.blackColor;
		[navigationController.view addSubview:view];
		@weakify(vc)
		[vc.msf_barcodeScannedSignal subscribeNext:^(ZXResult *x) {
			@strongify(vc)
			[vc.navigationController dismissViewControllerAnimated:YES completion:^{
				[subscriber sendNext:x.text];
				[subscriber sendCompleted];
			}];
		} completed:^{
			@strongify(vc)
			[vc.navigationController dismissViewControllerAnimated:YES completion:^{
				[subscriber sendCompleted];
			}];
		}];
		
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

- (RACSignal *)msf_gainPasscodeSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		self.passcodeViewController = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
		self.passcodeViewController.delegate = self;
		[[UIApplication sharedApplication].keyWindow addSubview:self.passcodeViewController.view];
		
		[[self rac_signalForSelector:@selector(getTradePassword:type:) fromProtocol:@protocol(MSFInputTradePasswordDelegate)] subscribeNext:^(id x) {
			[subscriber sendNext:[x first]];
			[subscriber sendCompleted];
		}];
		[[self rac_signalForSelector:@selector(cancel) fromProtocol:@protocol(MSFInputTradePasswordDelegate)] subscribeNext:^(id x) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFViewModelServicesDomain" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入正确的交易密码",
			}]];
		}];
		return [RACDisposable disposableWithBlock:^{
			[self.passcodeViewController.view removeFromSuperview];
		}];
	}];
}

- (RACSignal *)msf_selectKeyValuesWithContent:(NSString *)content {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:content]];
		[self pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:x];
			[subscriber sendCompleted];
			[self popViewModel];
		}];
		[viewModel.cancelSignal subscribeNext:^(id x) {
			[subscriber sendCompleted];
		}];
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

- (RACSignal *)msf_selectValuesWithContent:(NSString *)content keycode:(NSString *)keycode {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSArray *keyvalues = [MSFSelectKeyValues getSelectKeys:content];
		[keyvalues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
			if ([obj.code isEqualToString:keycode]) {
				[subscriber sendNext:obj.text];
				*stop = YES;
			}
		}];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)msf_selectContactSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
		picker.peoplePickerDelegate = self;
		picker.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty] , nil];
		[self.visibleViewController presentViewController:picker animated:YES completion:nil];
		if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
			picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
		}
		[[[self rac_signalForSelector:@selector(peoplePickerNavigationControllerDidCancel:)
			fromProtocol:@protocol(ABPeoplePickerNavigationControllerDelegate)] takeUntil:picker.rac_willDeallocSignal]
			subscribeNext:^(id x) {
				[subscriber sendCompleted];
		}];
		
		[[[self rac_signalForSelector:@selector(peoplePickerNavigationController:didSelectPerson:property:identifier:)
			fromProtocol:@protocol(ABPeoplePickerNavigationControllerDelegate)] takeUntil:picker.rac_willDeallocSignal]
			subscribeNext:^(RACTuple *x) {
			[subscriber sendNext:x];
			[subscriber sendCompleted];
		}];
		
		[[[self rac_signalForSelector:@selector(peoplePickerNavigationController:shouldContinueAfterSelectingPerson:property:identifier:) fromProtocol:@protocol(ABPeoplePickerNavigationControllerDelegate)] takeUntil:picker.rac_willDeallocSignal]
			subscribeNext:^(RACTuple *x) {
			[subscriber sendNext:x];
			[subscriber sendCompleted];
		}];
		return [RACDisposable disposableWithBlock:^{
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

#pragma mark - MSFInputTradePasswordDelegate

- (void)getTradePassword:(NSString *)pwd type:(int)type {
}

- (void)cancel {
}

@end
