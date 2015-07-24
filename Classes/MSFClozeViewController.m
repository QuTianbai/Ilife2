//
// MSFComplementViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClozeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClozeViewModel.h"
#import "MSFUtils.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectKeyValues.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <REFormattedNumberField/REFormattedNumberField.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"

@interface MSFClozeViewController () <UITextFieldDelegate>

@property (nonatomic, strong) MSFClozeViewModel *viewModel;

@end

@implementation MSFClozeViewController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MSFClozeViewController.class)];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.viewModel = [[MSFClozeViewModel alloc] initWithAuthorizedClient:MSFUtils.httpClient controller:self];
	RAC(self.viewModel, name) = self.name.rac_textSignal;
	RAC(self.viewModel, card) = self.card.rac_textSignal;
	RAC(self.viewModel, bankNO) = self.bankNO.rac_textSignal;
	
	// Submit
	self.submitButton.rac_command = self.viewModel.executeAuth;
	@weakify(self)
	[self.submitButton.rac_command.executionSignals subscribeNext:^(RACSignal *authSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[authSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self dismissViewControllerAnimated:YES completion:^{
				[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFClozeViewModelDidUpdateNotification" object:x];
			}];
		}];
	}];
	[self.submitButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
  //Identifier Card OutTime
 // RAC(self.expired,text) = RACObserve(self.viewModel, expired1);
  RAC(self.viewModel, expired1) = RACObserve(self.expired, text);
	// Identifier Card Lifelong
	RAC(self.permanentButton, selected) = RACObserve(self.viewModel, permanent);
	RAC(self.datePickerButton, enabled) = [RACSignal
		combineLatest:@[RACObserve(self.viewModel, permanent)]
		reduce:^id(NSNumber *permanent){
			return @(!permanent.boolValue);
	}];
	[RACObserve(self.viewModel, permanent) subscribeNext:^(NSNumber *permanent) {
		@strongify(self)
		if (permanent.boolValue) {
			self.expired.text = @"";
			[self.expired setBackgroundColor:[UIColor colorWithWhite:0.902 alpha:1.000]];
		} else {
			[self.expired setBackgroundColor:[UIColor whiteColor]];
		}
	}];
	self.permanentButton.rac_command = self.viewModel.executePermanent;
	
	// Left Bar button
	UIBarButtonItem *item = [[UIBarButtonItem alloc]
		initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:nil action:nil];
	item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self dismissViewControllerAnimated:YES completion:nil];
		
		return [RACSignal empty];
	}];
	self.navigationItem.leftBarButtonItem = item;
	
	// Bank name
	RAC(self.bankName, text) = RACObserve(self.viewModel, bankName);
	[[self.bankNameButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			[self.view endEditing:YES];
			MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"json_banks"]];
			MSFSelectionViewController *selectViewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
			selectViewController.title = @"选择银行";
			[self.navigationController pushViewController:selectViewController animated:YES];
			
			[selectViewController.selectedSignal subscribeNext:^(MSFSelectKeyValues *selectValue) {
				[selectViewController.navigationController popViewControllerAnimated:YES];
				self.viewModel.bankName = selectValue.text;
				self.viewModel.bankCode = selectValue.code;
			}];
		}];
	
	// Bank Address
	RAC(self.bankAddress, text) = RACObserve(self.viewModel, bankAddress);
	self.bankAddressButton.rac_command = self.viewModel.executeSelected;
	
	// Bank No button
	[[self.bankNOButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
				message:@"为保证账户资金安全,仅支持本人的储蓄卡(借记卡)收款"
				delegate:nil
				cancelButtonTitle:@"￼知道了"
				otherButtonTitles:nil];
			[alertView show];
		}];
	
	// common init
	[[self.datePickerButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			@strongify(self)
			[self.view endEditing:YES];
			NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
			NSDate *currentDate = [NSDate date];
			NSDateComponents *comps = [[NSDateComponents alloc] init];
			[comps setYear:50];
			NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
			[comps setYear:0];
			NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
		 
			[ActionSheetDatePicker
				showPickerWithTitle:@""
				datePickerMode:UIDatePickerModeDate
				selectedDate:[NSDate date]
				minimumDate:minDate
				maximumDate:maxDate
				doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
					self.expired.text = [NSDateFormatter msf_stringFromDate:selectedDate];
				}
				cancelBlock:^(ActionSheetDatePicker *picker) {
					self.expired.text = [NSDateFormatter msf_stringFromDate:[NSDate date]];
				}
				origin:self.view];
	}];
	
	self.name.delegate = self;
	self.card.delegate = self;
	self.card.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	[(REFormattedNumberField *)self.bankNO setFormat:@"XXXX XXXX XXXX XXXX XXX"];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField isEqual:self.card]) {
		textField.text = [textField.text uppercaseString];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField isEqual:self.name]) {
		NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSCharacterSet *blockedCharatersSquared = [NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒"];
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) || ([string rangeOfCharacterFromSet:blockedCharatersSquared].location != NSNotFound);
	} else if ([textField isEqual:self.card]) {
		if (range.location > 17) {
			return NO;
		}
		if (range.location == 17) {
			NSCharacterSet *blockedCharacters = [[NSCharacterSet identifyCardCharacterSet] invertedSet];
			
			return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
		}
		NSCharacterSet *blockedCharacters = [[NSCharacterSet numberCharacterSet] invertedSet];
		
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
	}
	
	return YES;
}

@end
