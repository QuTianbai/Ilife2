//
//	MSFFamilyInfoTableViewController.m
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationshipViewController.h"
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MSFSelectKeyValues.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectionViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFApplicationResponse.h"
#import "MSFCommandView.h"
#import "MSFRelationshipViewModel.h"
#import "UIColor+Utils.h"
#import "MSFHeaderView.h"
#import "MSFSubmitAlertView.h"
#define BLUECOLOR @"#007ee5"

typedef NS_ENUM(NSUInteger, MSFRelationshipViewSection) {
	MSFRelationshipViewSectionTitle,
	MSFRelationshipViewSectionMember1,
	MSFRelationshipViewSectionMember2,
	MSFRelationshipViewSectionContact1,
	MSFRelationshipViewSectionContact2,
};

@interface MSFRelationshipViewController ()<ABPeoplePickerNavigationControllerDelegate,
ABPersonViewControllerDelegate>

@property (nonatomic, strong) MSFRelationshipViewModel *viewModel;
/**
 *	婚姻状况，住房状况
 */
@property (weak, nonatomic) IBOutlet UITextField *marriageTF;
@property (weak, nonatomic) IBOutlet UIButton *marriageBT;
@property (weak, nonatomic) IBOutlet UITextField *houseTF;
@property (weak, nonatomic) IBOutlet UIButton *housesBT;

/**
 *	家庭联系人一
 */
@property (weak, nonatomic) IBOutlet UITextField *familyNameTF;
@property (weak, nonatomic) IBOutlet UIButton *relationBT;
@property (weak, nonatomic) IBOutlet UITextField *relationTF;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UISwitch *isSameCurrentSW;
@property (weak, nonatomic) IBOutlet UITextField *diffCurrentTF;
@property (weak, nonatomic) IBOutlet UIButton *addFamilyBT;
@property (weak, nonatomic) IBOutlet UILabel *relationAddressLabel;


/**
 *	家庭联系人二
 */
@property (weak, nonatomic) IBOutlet UITextField *num2FamilyNameTF;
@property (weak, nonatomic) IBOutlet UIButton *num2RelationBT;
@property (weak, nonatomic) IBOutlet UITextField *num2RelationTF;
@property (weak, nonatomic) IBOutlet UITextField *num2TelTF;
@property (weak, nonatomic) IBOutlet UISwitch *num2IsSameCurrentSW;
@property (weak, nonatomic) IBOutlet UITextField *num2DiffCurrentTF;
@property (weak, nonatomic) IBOutlet UILabel *num2RelationAddressLabel;

/**
 *	其他联系人一
 */
@property (weak, nonatomic) IBOutlet UITextField *otherNameTF;
@property (weak, nonatomic) IBOutlet UIButton *otherRelationBT;
@property (weak, nonatomic) IBOutlet UITextField *otherRelationTF;
@property (weak, nonatomic) IBOutlet UITextField *otherTelTF;

/**
 *	其他联系人二
 */
@property (weak, nonatomic) IBOutlet UITextField *num2_otherNameTF;
@property (weak, nonatomic) IBOutlet UIButton *num2_otherRelationBT;
@property (weak, nonatomic) IBOutlet UITextField *num2_otherRelationTF;
@property (weak, nonatomic) IBOutlet UITextField *num2_otherTelTF;
@property (weak, nonatomic) IBOutlet UIButton *addOtherBT;

/**
 *	下一步
 */
@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;

@property (nonatomic, assign) BOOL sameMember1Address;
@property (nonatomic, assign) BOOL sameMember2Address;

/**
 *	通讯录按钮
 */
- (IBAction)firstFamilyPhoneBtn:(id)sender;
- (IBAction)secondFamilyPhoneBtn:(id)sender;
- (IBAction)firstOtherContactBtn:(id)sender;
- (IBAction)secondOtherContactBtn:(id)sender;

#define RELATION_VIEW_MODEL self.viewModel.relationViewModel

@end

@implementation MSFRelationshipViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"家庭信息";
	self.tableView.tableHeaderView = [MSFHeaderView headerViewWithIndex:2];
	
	
	
	@weakify(self)
	[[self.addFamilyBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.hasMember2 = !self.viewModel.hasMember2;
		[self.addFamilyBT setTitle:self.viewModel.hasMember2 ? @"- 删除第二位家庭成员" : @"✚ 增加第二位家庭成员" forState:UIControlStateNormal];
		[UIView animateWithDuration:.3 animations:^{
			[self.tableView reloadData];
		}];
	}];
	[self.addFamilyBT setTitleColor:[MSFCommandView getColorWithString:BLUECOLOR] forState:UIControlStateNormal];
	
	[[self.addOtherBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.hasContact2 = !self.viewModel.hasContact2;
		[self.addOtherBT setTitle:self.viewModel.hasContact2 ? @"- 删除第二位联系人" : @"✚ 增加第二位其他联系人" forState:UIControlStateNormal];
		[UIView animateWithDuration:.3 animations:^{
			[self.tableView reloadData];
		}];
	}];
	[self.addOtherBT setTitleColor:[MSFCommandView getColorWithString:BLUECOLOR] forState:UIControlStateNormal];
	
	RAC(self.marriageTF, text) = RACObserve(self.viewModel, marryValuesTitle);
	self.marriageBT.rac_command = self.viewModel.executeMarryValuesCommand;
	RAC(self.houseTF, text) = RACObserve(self.viewModel, houseValuesTitle);
	self.housesBT.rac_command = self.viewModel.executeHouseValuesCommand;
	
	// 第一位家庭成员
	[[self.familyNameTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 20) {
			 textField.text = [textField.text substringToIndex:20];
		 }
	 }];
	
	RACChannelTerminal *memer1Channel = RACChannelTo(self.viewModel.model, memberName);
	RAC(self.familyNameTF, text) = memer1Channel;
	[self.familyNameTF.rac_textSignal subscribe:memer1Channel];
	RAC(self.relationTF, text) = RACObserve(self.viewModel, familyOneValuesTitle);
	self.relationBT.rac_command = self.viewModel.executeFamilyOneValuesCommand;
	RACChannelTerminal *member1PhoneChannel = RACChannelTo(self.viewModel.model, memberCellNum);
	RAC(self.telTF, text) = member1PhoneChannel;
	
	[[self.telTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 13) {
			 textField.text = [textField.text substringToIndex:13];
		 }
	 }];
	
	[self.telTF.rac_textSignal subscribe:member1PhoneChannel];
	RACChannelTerminal *member1AddressChannel = RACChannelTo(self.viewModel.model, memberAddress);
	RAC(self.diffCurrentTF, text) = member1AddressChannel;
	[self.diffCurrentTF.rac_textSignal subscribe:member1AddressChannel];
	self.diffCurrentTF.enabled = !self.isSameCurrentSW.on;
	[self.isSameCurrentSW.rac_newOnChannel subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.diffCurrentTF.enabled = !value.boolValue;
		if (value.boolValue) {
			self.diffCurrentTF.text = @"";
		}
		[UIView animateWithDuration:.3 animations:^{
			[self.tableView reloadData];
		}];
	}];
	
	// 第二位家庭成员
	[[self.num2FamilyNameTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 20) {
			 textField.text = [textField.text substringToIndex:20];
		 }
	 }];
	RACChannelTerminal *memer2Channel = RACChannelTo(self.viewModel.model, memberName2);
	RAC(self.num2FamilyNameTF, text) = memer2Channel;
	[self.num2FamilyNameTF.rac_textSignal subscribe:memer2Channel];
	RAC(self.num2RelationTF, text) = RACObserve(self.viewModel, familyTwoValuesTitle);
	self.num2RelationBT.rac_command = self.viewModel.executeFamilyTwoValuesCommand;
	RACChannelTerminal *member2PhoneChannel = RACChannelTo(self.viewModel.model, memberCellNum2);
	RAC(self.num2TelTF, text) = member2PhoneChannel;
	
	[[self.num2TelTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 13) {
			 textField.text = [textField.text substringToIndex:13];
		 }
	 }];
	[self.num2TelTF.rac_textSignal subscribe:member2PhoneChannel];
	RACChannelTerminal *member2AddressChannel = RACChannelTo(self.viewModel.model, memberAddress2);
	RAC(self.num2DiffCurrentTF, text) = member2AddressChannel;
	[self.num2DiffCurrentTF.rac_textSignal subscribe:member2AddressChannel];
	self.num2DiffCurrentTF.enabled = !self.num2IsSameCurrentSW.on;
	[self.num2IsSameCurrentSW.rac_newOnChannel subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.num2DiffCurrentTF.enabled = !value.boolValue;
		if (value.boolValue) {
			self.num2DiffCurrentTF.text = @"";
		}
		[UIView animateWithDuration:.3 animations:^{
			[self.tableView reloadData];
		}];
	}];
	
	// 其他联系人一
	[[self.otherNameTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 20) {
			 textField.text = [textField.text substringToIndex:20];
		 }
	 }];
	RACChannelTerminal *name1Channel = RACChannelTo(self.viewModel.model, name1);
	RAC(self.otherNameTF, text) = name1Channel;
	[self.otherNameTF.rac_textSignal subscribe:name1Channel];
	RAC(self.otherRelationTF, text) = RACObserve(self.viewModel, otherOneValuesTitle);
	self.otherRelationBT.rac_command = self.viewModel.executeOtherOneValuesCommand;
	RACChannelTerminal *phone1Channel = RACChannelTo(self.viewModel.model, phone1);
	
	[[self.otherTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 13) {
			 textField.text = [textField.text substringToIndex:13];
		 }
	 }];
	
	RAC(self.otherTelTF, text) = phone1Channel;
	[self.otherTelTF.rac_textSignal subscribe:phone1Channel];
	
	// 其他联系人二
	[[self.num2_otherNameTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 20) {
			 textField.text = [textField.text substringToIndex:20];
		 }
	 }];
	RACChannelTerminal *name2Channel = RACChannelTo(self.viewModel.model, name2);
	RAC(self.num2_otherNameTF, text) = name2Channel;
	[self.num2_otherNameTF.rac_textSignal subscribe:name2Channel];
	
	RAC(self.num2_otherRelationTF, text) = RACObserve(self.viewModel, otherTwoValuesTitle);
	self.num2_otherRelationBT.rac_command = self.viewModel.executeOtherTwoValuesCommand;
	
	[[self.num2_otherTelTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 13) {
			 textField.text = [textField.text substringToIndex:13];
		 }
	 }];
	RACChannelTerminal *phone2Channel = RACChannelTo(self.viewModel.model, phone2);
	RAC(self.num2_otherTelTF, text) = phone2Channel;
	[self.num2_otherTelTF.rac_textSignal subscribe:phone2Channel];
	
	[[self.nextPageBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		UIAlertView *alertView = [[UIAlertView alloc] init];
		alertView.title = @"提示";
		alertView.message = self.viewModel.confirmMessage;
		[alertView addButtonWithTitle:@"取消"];
		[alertView addButtonWithTitle:@"确认"];
		[alertView setCancelButtonIndex:0];
		//[alertView show];
		UIWindow *window = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
		 MSFSubmitAlertView *submitAlertView = [[[NSBundle mainBundle] loadNibNamed:@"MSFSubmitAlertView" owner:self options:nil] firstObject];
		 [submitAlertView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
		 //替换我写的假数据就可以了
		 submitAlertView.loanAccountLabel.text = @"100元";
		 submitAlertView.loanNper.text = @"3期";
		 submitAlertView.loanPayBack.text = @"35.27";
		 submitAlertView.loanUse.text = @"租赁";
		
		 [window addSubview:submitAlertView];
		 [self.view addSubview:window];
		
		[alertView.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
			if (index.integerValue == 1) {
				[self.viewModel.executeCommitCommand execute:nil];
			}
		}];
	}];
	[self.nextPageBT setBackgroundColor:[MSFCommandView getColorWithString:BLUECOLOR]];
	[self.nextPageBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showWithStatus:@"申请提交中..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"申请提交成功"];
			@strongify(self)
			self.tabBarController.selectedIndex = 0;
		}];
	}];
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == MSFRelationshipViewSectionMember2) {
		if (!self.viewModel.hasMember2) {
			return nil;
		}
	}
	if (section == MSFRelationshipViewSectionContact2) {
		if (!self.viewModel.hasContact2) {
			return nil;
		}
	}
	return [super tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == MSFRelationshipViewSectionMember2) {
		if (!self.viewModel.hasMember2) {
			return 0;
		}
	}
	if (section == MSFRelationshipViewSectionContact2) {
		if (!self.viewModel.hasContact2) {
			return 0;
		}
	}
	return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == MSFRelationshipViewSectionMember1 && indexPath.row == 4 ) {
		if (self.isSameCurrentSW.isOn) {
			[_relationAddressLabel setHidden:YES];
			[_diffCurrentTF setHidden:YES];
		} else {
			[_relationAddressLabel setHidden:NO];
			[_diffCurrentTF setHidden:NO];
			return [super tableView:tableView heightForRowAtIndexPath:indexPath];
		}
		return 0;
	}
	if (indexPath.section == MSFRelationshipViewSectionMember2 && indexPath.row == 4 ) {
		if (self.num2IsSameCurrentSW.isOn) {
			[_num2RelationAddressLabel setHidden:YES];
			[_num2DiffCurrentTF setHidden:YES];
		} else {
			[_num2RelationAddressLabel setHidden:NO];
			[_num2DiffCurrentTF setHidden:NO];
			return [super tableView:tableView heightForRowAtIndexPath:indexPath];
		}
		return 0;
	}
	return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	NSString *sectionTitle = [super tableView:tableView titleForHeaderInSection:section];
	if (sectionTitle == nil) {
		return  nil;
	}
	
	UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, self.view.frame.size.height)];
	sectionView.backgroundColor = [MSFCommandView getColorWithString:@"#f8f8f8"];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 110, 22)];
	
	titleLabel.text = sectionTitle;
	titleLabel.textColor = [MSFCommandView getColorWithString:BLUECOLOR];
	[titleLabel setFont:[UIFont systemFontOfSize:14]];
	titleLabel.backgroundColor = [UIColor clearColor];
	
	[sectionView addSubview:titleLabel];
	
	return sectionView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - phone_button

- (IBAction)firstFamilyPhoneBtn:(id)sender {
	[self fetchAddressBook:_telTF];
}

- (IBAction)secondFamilyPhoneBtn:(id)sender {
	[self fetchAddressBook:_num2TelTF];
}

- (IBAction)firstOtherContactBtn:(id)sender {
	[self fetchAddressBook:_otherTelTF];
}

- (IBAction)secondOtherContactBtn:(id)sender {
	[self fetchAddressBook:_num2_otherTelTF];
}

- (void)fetchAddressBook:(UITextField *)textField {
	ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
	picker.peoplePickerDelegate = self;
	picker.view.tag = textField.tag;
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty] , nil];
	picker.displayedProperties = displayedItems;
	[self presentViewController:picker animated:YES completion:^{
	}];
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
	}
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
		NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
		aPhone = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
		[phones addObject:aPhone];
	}
	NSString *phone = @"";
	
	if (phones.count > 0) {
		phone = [phones objectAtIndex:0];
	}
	
	switch (peoplePicker.view.tag) {
  case 10000:
			self.telTF.text = phone;
			break;
		case 10001:
			self.num2TelTF.text = phone;
			break;
		case 10002:
			self.otherTelTF.text = phone;
			break;
		case 10003:
			self.num2_otherTelTF.text = phone;
			break;
			
  default:
			break;
	}
	
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
			shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
			shouldContinueAfterSelectingPerson:(ABRecordRef)person
																property:(ABPropertyID)property
															identifier:(ABMultiValueIdentifier)identifier {
	
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
	for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
		NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
		aPhone = [aPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
		[phones addObject:aPhone];
	}
	NSString *phone = @"";
	
	if (phones.count > 0) {
		phone = [phones objectAtIndex:0];
	}
	
	switch (peoplePicker.view.tag) {
  case 10000:
			self.telTF.text = phone;
			break;
		case 10001:
			self.num2TelTF.text = phone;
			break;
		case 10002:
			self.otherTelTF.text = phone;
			break;
		case 10003:
			self.num2_otherTelTF.text = phone;
			break;
			
  default:
			break;
	}
 [peoplePicker dismissViewControllerAnimated:YES completion:nil];
	
	return NO;
	
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return YES;
}

@end