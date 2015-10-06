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
#import <KGModal/KGModal.h>
#import <Masonry/Masonry.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AppDelegate.h"
#import "MSFSelectKeyValues.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectionViewModel.h"
#import "MSFRelationshipViewModel.h"
#import "MSFCertificatesCollectionViewController.h"
#import "MSFApplicationForms.h"
#import "MSFApplicationResponse.h"
#import "MSFCommandView.h"
#import "MSFRelationshipViewModel.h"
#import "UIColor+Utils.h"
#import "MSFHeaderView.h"
#import "MSFSubmitAlertView.h"
#import "MSFSelectKeyValues.h"
#import "MSFXBMCustomHeader.h"
#import "MSFInventoryViewModel.h"

#import "MSFUserContact.h"
#import "MSFRelationHeadCell.h"
#import "MSFRelationTFCell.h"
#import "MSFRelationSwitchCell.h"
#import "MSFRelationSelectionCell.h"
#import "MSFRelationPhoneCell.h"
#import "MSFRelationAddCell.h"

typedef NS_ENUM(NSUInteger, MSFRelationshipViewSection) {
	MSFRelationshipViewSectionTitle,
	MSFRelationshipViewSectionMember1,
	MSFRelationshipViewSectionMember2,
	MSFRelationshipViewSectionContact1,
	MSFRelationshipViewSectionContact2,
};

@interface MSFRelationshipViewController ()
<ABPeoplePickerNavigationControllerDelegate,
ABPersonViewControllerDelegate>

@property (nonatomic, copy) NSString *currendAddress;
@property (nonatomic, strong) MSFRelationshipViewModel *viewModel;
@property (nonatomic, strong) MSFSelectKeyValues *selectKeyValues;
@property (nonatomic, strong) NSMutableArray *tempContactList;

@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;

@end

@implementation MSFRelationshipViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	
	self.viewModel = viewModel;
	
	_tempContactList = [NSMutableArray arrayWithArray:self.viewModel.model.contrastList];
	
	if (_tempContactList.count == 0) {
		MSFUserContact *contact = [[MSFUserContact alloc] init];
		[_tempContactList addObject:contact];
	}
//TODO:
	for (MSFUserContact *contact in _tempContactList) {
		if (!contact.openDetailAddress) {
			contact.contactAddress = self.viewModel.model.currentAddress;
		}
	}
}

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFRelationshipViewController dealloc");
}

- (instancetype)init {
	return [UIStoryboard storyboardWithName:@"relationship" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"联系人信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	/*
	 self.tableView.tableHeaderView = [MSFHeaderView headerViewWithIndex:2];
	 self.viewModel.model.memberAddress = self.viewModel.model.currentAddress;
	 self.viewModel.model.memberAddress2 = self.viewModel.model.currentAddress;
	 
	 @weakify(self)
	 [[self.addFamilyBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.hasMember2 = !self.viewModel.hasMember2;
		[self.addFamilyBT setTitle:self.viewModel.hasMember2 ? @"- 删除第二位家庭成员" : @"✚ 增加第二位家庭成员" forState:UIControlStateNormal];
		if (self.viewModel.hasMember2) {
	 if (self.num2IsSameCurrentSW.on) {
	 self.viewModel.model.memberAddress2 = self.currendAddress;
	 } else {
	 self.viewModel.model.memberAddress2 = nil;
	 }
		} else {
	 self.viewModel.model.memberName2 = nil;
	 self.viewModel.model.memberRelation2 = nil;
	 self.num2RelationTF.text = @"";
	 self.viewModel.model.memberCellNum2 = nil;
	 self.viewModel.model.memberAddress2 = nil;
		}
		[UIView animateWithDuration:.3 animations:^{
	 [self.tableView reloadData];
		}];
	 }];
	 [self.addFamilyBT setTitleColor:[MSFCommandView getColorWithString:POINTCOLOR] forState:UIControlStateNormal];
	 
	 [[self.addOtherBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.hasContact2 = !self.viewModel.hasContact2;
		[self.addOtherBT setTitle:self.viewModel.hasContact2 ? @"- 删除第二位联系人" : @"✚ 增加第二位其他联系人" forState:UIControlStateNormal];
		
		if (!self.viewModel.hasContact2) {
	 self.viewModel.model.name2 = nil;
	 self.viewModel.model.relation2 = nil;
	 self.viewModel.model.phone2 = nil;
	 self.num2_otherRelationTF.text = @"";
		}
		
		[UIView animateWithDuration:.3 animations:^{
	 [self.tableView reloadData];
		}];
	 }];
	 [self.addOtherBT setTitleColor:[MSFCommandView getColorWithString:POINTCOLOR] forState:UIControlStateNormal];
	 
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
	 if (textField.text.length > 11) {
	 textField.text = [textField.text substringToIndex:11];
	 }
	 }];
	 
	 [self.telTF.rac_textSignal subscribe:member1PhoneChannel];
	 
	 RACChannelTerminal *member1AddressChannel = RACChannelTo(self.viewModel.model, memberAddress);
	 RAC(self.diffCurrentTF, text) = member1AddressChannel;
	 self.currendAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", self.viewModel.model.currentProvince,self.viewModel.model.currentCity,self.viewModel.model.currentCountry,self.viewModel.model.currentTown,self.viewModel.model.currentStreet,self.viewModel.model.currentCommunity,self.viewModel.model.currentApartment];
	 self.diffCurrentTF.text = self.currendAddress;
	 [self.diffCurrentTF.rac_textSignal subscribe:member1AddressChannel];
	 self.diffCurrentTF.enabled = !self.isSameCurrentSW.on;
	 [self.isSameCurrentSW.rac_newOnChannel subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.diffCurrentTF.enabled = !value.boolValue;
		if (value.boolValue) {
	 self.diffCurrentTF.text = self.currendAddress;
	 self.viewModel.model.memberAddress = self.currendAddress;
	 //self.diffCurrentTF.text = self.viewModel.model.currentAddress;
		} else {
	 self.diffCurrentTF.text = @"";
	 self.viewModel.model.memberAddress = @"";
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
	 if (textField.text.length > 11) {
	 textField.text = [textField.text substringToIndex:11];
	 }
	 }];
	 [self.num2TelTF.rac_textSignal subscribe:member2PhoneChannel];
	 RACChannelTerminal *member2AddressChannel = RACChannelTo(self.viewModel.model, memberAddress2);
	 self.num2DiffCurrentTF.text = self.currendAddress;
	 RAC(self.num2DiffCurrentTF, text) = member2AddressChannel;
	 [self.num2DiffCurrentTF.rac_textSignal subscribe:member2AddressChannel];
	 self.num2DiffCurrentTF.enabled = !self.num2IsSameCurrentSW.on;
	 [self.num2IsSameCurrentSW.rac_newOnChannel subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.num2DiffCurrentTF.enabled = !value.boolValue;
		if (value.boolValue) {
	 self.num2DiffCurrentTF.text = self.currendAddress;
	 self.viewModel.model.memberAddress2 = self.currendAddress;
	 //self.num2DiffCurrentTF.text = self.viewModel.model.currentAddress;
		} else {
	 self.num2DiffCurrentTF.text = @"";
	 self.viewModel.model.memberAddress2 = @"";
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
	 if (textField.text.length > 11) {
	 textField.text = [textField.text substringToIndex:11];
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
	 if (textField.text.length > 11) {
	 textField.text = [textField.text substringToIndex:11];
	 }
	 }];
	 RACChannelTerminal *phone2Channel = RACChannelTo(self.viewModel.model, phone2);
	 RAC(self.num2_otherTelTF, text) = phone2Channel;
	 [self.num2_otherTelTF.rac_textSignal subscribe:phone2Channel];
	 */
	
	[self.nextPageBT setBackgroundColor:[MSFCommandView getColorWithString:POINTCOLOR]];
	[self.nextPageBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	@weakify(self)
	[[self.nextPageBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.model.contrastList = [NSArray arrayWithArray:_tempContactList];
		[self.viewModel.executeCommitCommand execute:nil];
	}];
	self.nextPageBT.rac_command = self.viewModel.executeCommitCommand;
	[self.viewModel.executeCommitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"申请提交中..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"提交成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.executeCommitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

#pragma mark - Private Method

- (void)back {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定放弃联系人信息编辑？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
		if ([x integerValue] == 1) {
			self.viewModel.model.contrastList = [NSArray arrayWithArray:_tempContactList];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[alert show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (_tempContactList.count == 5) {
		return 5;
	} else {
		return _tempContactList.count + 1;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == _tempContactList.count) {
		return 1;
	} else {
		MSFUserContact *contact = _tempContactList[section];
		if (contact.openDetailAddress) {
			return 6;
		} else {
			return 5;
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 13;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == _tempContactList.count) {
		MSFRelationAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationAddCell"];
		return cell;
	}
	MSFUserContact *contact = self.tempContactList[indexPath.section];
	switch (indexPath.row) {
		case 0: {
			MSFRelationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationHeadCell"];
			cell.titleLabel.text = [NSString stringWithFormat:@"联系人%ld", (long)indexPath.section + 1];
			cell.deleteButton.hidden = _tempContactList.count == 1 && indexPath.section == 0;
			@weakify(self)
			[[[cell.deleteButton
				 rac_signalForControlEvents:UIControlEventTouchUpInside]
			 takeUntil:cell.rac_prepareForReuseSignal]
			 subscribeNext:^(id x) {
				 @strongify(self)
				 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除该联系人？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
				 [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
					 if ([x integerValue] == 1) {
						 [self.tempContactList removeObjectAtIndex:indexPath.section];
						 [UIView animateWithDuration:.3 animations:^{
							 [tableView reloadData];
						 }];
					 }
				 }];
				 [alert show];
			 }];
			return cell;
		}
		case 1: {
			MSFRelationSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationSelectionCell"];
			NSArray *professions = [MSFSelectKeyValues getSelectKeys:@"familyMember_type"];
			[professions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
				if ([obj.code isEqualToString:contact.contactRelation]) {
					cell.tfInput.text = obj.text;
					*stop = YES;
				}
			}];
			@weakify(self)
			[[[cell.selectionButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
				@strongify(self)
				MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"familyMember_type"]];
				[self.viewModel.services pushViewModel:viewModel];
				[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
					cell.tfInput.text = x.text;
					contact.contactRelation = x.code;
					[self.viewModel.services popViewModel];
				}];
			}];
			return cell;
		}
		case 2: {
			MSFRelationTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationTFCell"];
			cell.titleLabel.text = @"姓名";
			cell.tfInput.placeholder = @"请填写联系人姓名";
			cell.tfInput.text = contact.contactName;
			[[cell.tfInput rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
				if (textField.text.length > 40) {
					textField.text = [textField.text substringToIndex:40];
				}
				contact.contactName = textField.text;
			}];
			return cell;
		}
		case 3: {
			MSFRelationPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationPhoneCell"];
			cell.tfInput.text = contact.contactMobile;
			cell.tfInput.tag = indexPath.section;
			
			[[cell.tfInput rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
				if (textField.text.length > 11) {
					textField.text = [textField.text substringToIndex:11];
				}
				contact.contactMobile = textField.text;
			}];
			
			@weakify(self)
			[[[cell.onContactBook rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
				@strongify(self)
				[self fetchAddressBook:cell.tfInput];
			}];
			return cell;
		}
		case 4: {
			MSFRelationSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationSwitchCell"];
			@weakify(self)
			[[cell.switchButton.rac_newOnChannel takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *x) {
				@strongify(self)
				if (x.boolValue) {
					contact.openDetailAddress = NO;
					contact.contactAddress = self.viewModel.model.currentAddress;
				} else {
					contact.openDetailAddress = YES;
					contact.contactAddress = nil;
				}
				[UIView animateWithDuration:.3 animations:^{
					[tableView reloadData];
				}];
			}];
			return cell;
		}
		case 5: {
			MSFRelationTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationTFCell"];
			cell.titleLabel.text = @"联系地址";
			cell.tfInput.placeholder = @"请填写联系地址";
			cell.tfInput.text = contact.contactAddress;
			[[cell.tfInput rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
				if (textField.text.length > 60) {
					textField.text = [textField.text substringToIndex:60];
				}
				contact.contactAddress = textField.text;
			}];
			return cell;
		}
		default: return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == _tempContactList.count) {
		[_tempContactList addObject:[[MSFUserContact alloc] init]];
		[UIView animateWithDuration:.3 animations:^{
			[self.tableView reloadData];
		}];
	}
}

#pragma mark - phone_button

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
		phone = [phones objectAtIndex:identifier];
		phone = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
	}
	MSFUserContact *contact = self.tempContactList[peoplePicker.view.tag];
	contact.contactMobile = phone;
	[self.tableView reloadData];
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
		[phones addObject:aPhone];
	}
	NSString *phone = @"";
	
	if (phones.count > 0) {
		phone = [phones objectAtIndex:identifier];
		phone = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
	}
	
	MSFUserContact *contact = self.tempContactList[peoplePicker.view.tag];
	contact.contactMobile = phone;
	[self.tableView reloadData];
	
 [peoplePicker dismissViewControllerAnimated:YES completion:nil];
	
	return NO;
	
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return YES;
}

@end
