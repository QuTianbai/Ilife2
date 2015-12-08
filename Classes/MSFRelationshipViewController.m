//
//	MSFFamilyInfoTableViewController.m
//	Cash
//
//	Created by xbm on 15/5/23.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationshipViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AddressBookUI/AddressBookUI.h>

#import "MSFSelectKeyValues.h"
#import "MSFSelectionViewController.h"
#import "MSFSelectionViewModel.h"

#import "MSFRelationshipViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"

#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

#import "MSFUserContact.h"
#import "MSFRelationHeadCell.h"
#import "MSFRelationTFCell.h"
#import "MSFRelationSwitchCell.h"
#import "MSFRelationSelectionCell.h"
#import "MSFRelationPhoneCell.h"
#import "MSFRelationAddCell.h"
#import "MSFRelationMarriageCell.h"

@interface MSFRelationshipViewController ()
<ABPeoplePickerNavigationControllerDelegate,
ABPersonViewControllerDelegate>

@property (nonatomic, strong) MSFRelationshipViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *tempContactList;
@property (weak, nonatomic) IBOutlet UIButton *nextPageBT;

@end

@implementation MSFRelationshipViewController

#pragma mark - MSFReactiveView

- (void)bindViewModel:(MSFRelationshipViewModel *)viewModel {
	
	_viewModel = viewModel;
	MSFApplicationForms *forms = self.viewModel.formsViewModel.model;
	_tempContactList = [NSMutableArray array];
	
	//遍历获取的联系人列表，将第一个家庭联系人添加到第一位置
	NSMutableArray *tempArray = [NSMutableArray arrayWithArray:forms.contrastList];
	for (int i = 0; i < tempArray.count; i++) {
		MSFUserContact *contract = tempArray[i];
		if (contract.isFamily) {
			[_tempContactList addObject:contract];
			[tempArray removeObjectAtIndex:i];
			break;
		}
	}
	//遍历无家庭联系人时，添加一个空联系人到第一位置
	if (_tempContactList.count == 0) {
		MSFUserContact *contact = [[MSFUserContact alloc] init];
		contact.contactAddress = viewModel.fullAddress;
		[_tempContactList addObject:contact];
	}
	//遍历获取的联系人列表，将第一个普通联系人添加到第二位置
	for (int i = 0; i < tempArray.count; i++) {
		MSFUserContact *contract = tempArray[i];
		if (!contract.isFamily) {
			[_tempContactList addObject:contract];
			[tempArray removeObjectAtIndex:i];
			break;
		}
	}
	//遍历无普通联系人时，添加一个空联系人到第二位置
	if (_tempContactList.count == 1) {
		[_tempContactList addObject:[[MSFUserContact alloc] init]];
	}
	//将剩余联系人依次添加进数组
	[_tempContactList addObjectsFromArray:tempArray];
	
	//遍历新的联系人数组，初始化开关及地址信息
	for (MSFUserContact *contact in _tempContactList) {
		if (contact.contactAddress.length > 0) {
			if ([contact.contactAddress isEqualToString:viewModel.fullAddress]) {
				contact.openDetailAddress = NO;
			} else {
				contact.openDetailAddress = YES;
			}
		} else {
			contact.openDetailAddress = YES;
		}
	}
}

#pragma mark - Lifecycle

- (instancetype)init {
	return [UIStoryboard storyboardWithName:@"relationship" bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.title = @"联系人信息";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	
	[self.nextPageBT setBackgroundColor:[MSFCommandView getColorWithString:POINTCOLOR]];
	[self.nextPageBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	@weakify(self)
	[[self.nextPageBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.formsViewModel.model.contrastList = [NSArray arrayWithArray:_tempContactList];
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
	if (!self.viewModel.edited) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定放弃联系人信息编辑？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
		if ([x integerValue] == 1) {
			self.viewModel.formsViewModel.model.contrastList = [NSArray arrayWithArray:_tempContactList];
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[alert show];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (_tempContactList.count >= 5) {
		return 6;
	} else {
		return _tempContactList.count + 2;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else if (section == _tempContactList.count + 1) {
		return 1;
	} else {
		if (self.viewModel.fullAddress.length == 0) {
			return 5;
		} else {
			MSFUserContact *contact = _tempContactList[section - 1];
			if (contact.openDetailAddress) {
				return 6;
			} else {
				return 5;
			}
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
	if (indexPath.section == 0) {
		MSFRelationMarriageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationMarriageCell"];
		cell.marriage = self.viewModel.formsViewModel.model.marriageTitle;
		return cell;
	}
	if (indexPath.section == _tempContactList.count + 1) {
		MSFRelationAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationAddCell"];
		return cell;
	}
	MSFUserContact *contact = self.tempContactList[indexPath.section - 1];
	switch (indexPath.row) {
		case 0: {
			MSFRelationHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationHeadCell"];
			cell.titleLabel.text = [NSString stringWithFormat:@"联系人%ld", (long)indexPath.section];
			cell.deleteButton.hidden = indexPath.section < 3;
			@weakify(self)
			[[[cell.deleteButton
				 rac_signalForControlEvents:UIControlEventTouchUpInside]
			 takeUntil:cell.rac_prepareForReuseSignal]
			 subscribeNext:^(id x) {
				 @strongify(self)
				 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除该联系人？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
				 [alert.rac_buttonClickedSignal subscribeNext:^(id x) {
					 if ([x integerValue] == 1) {
						 [self.tempContactList removeObjectAtIndex:indexPath.section - 1];
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
			if ([self.viewModel.formsViewModel.model.maritalStatus isEqualToString:@"20"] && indexPath.section == 1) {
				cell.tfInput.text = @"配偶";
				contact.contactRelation = @"RF01";
			} else {
				NSArray *professions = [MSFSelectKeyValues getSelectKeys:@"familyMember_type"];
				[professions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
					if ([obj.code isEqualToString:contact.contactRelation]) {
						cell.tfInput.text = obj.text;
						*stop = YES;
					}
					if (*stop == NO) {
						cell.tfInput.text = nil;
					}
				}];
				@weakify(self)
				[[[cell.selectionButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
					@strongify(self)
					NSString *familyKey = @"familyMember_type";
					if (indexPath.section == 1) {
						familyKey = @"familyMember_type1";
					} else if (indexPath.section == 2) {
						familyKey = @"familyMember_type2";
					}
					MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:familyKey]];
					[self.viewModel.services pushViewModel:viewModel];
					[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
						cell.tfInput.text = x.text;
						contact.contactRelation = x.code;
						if (contact.isFamily) {
							contact.openDetailAddress = NO;
							contact.contactAddress = self.viewModel.fullAddress;
						} else {
							contact.openDetailAddress = YES;
							contact.contactAddress = nil;
						}
						[tableView reloadData];
						[self.viewModel.services popViewModel];
					}];
				}];
			}
			return cell;
		}
		case 2: {
			MSFRelationPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationPhoneCell"];
			cell.tfInput.text = contact.contactMobile;
			cell.tfInput.tag = indexPath.section - 1;
			
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
		case 3: {
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
		case 4: {
			if (self.viewModel.fullAddress.length > 0) {
				MSFRelationSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationSwitchCell"];
				@weakify(self)
				cell.switchButton.on = !contact.openDetailAddress;
				[[cell.switchButton.rac_newOnChannel takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *x) {
					@strongify(self)
					if (x.boolValue) {
						contact.openDetailAddress = NO;
						contact.contactAddress = self.viewModel.fullAddress;
					} else {
						contact.openDetailAddress = YES;
						contact.contactAddress = nil;
					}
					[UIView animateWithDuration:0.3 animations:^{
						[tableView reloadData];
					}];
				}];
				return cell;
			} else {
				MSFRelationTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationTFCell"];
				cell.titleLabel.text = @"联系地址";
				cell.tfInput.placeholder = contact.isFamily ? @"请填写联系地址" : @"请填写联系地址（选填）";
				cell.tfInput.text = contact.contactAddress;
				[[cell.tfInput rac_signalForControlEvents:UIControlEventEditingChanged] subscribeNext:^(UITextField *textField) {
					if (textField.text.length > 60) {
						textField.text = [textField.text substringToIndex:60];
					}
					contact.contactAddress = textField.text;
				}];
				return cell;
			}
		}
		case 5: {
			MSFRelationTFCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFRelationTFCell"];
			cell.titleLabel.text = @"联系地址";
			cell.tfInput.placeholder = contact.isFamily ? @"请填写联系地址" : @"请填写联系地址（选填）";
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
	if (indexPath.section == 0) {
		[[self.viewModel.executeMarriageCommand execute:nil]
		 subscribeNext:^(id x) {
			 MSFUserContact *contact = _tempContactList[0];
			 contact.contactRelation = nil;
			 [tableView reloadData];
		 }];
	} else if (indexPath.section == _tempContactList.count + 1) {
		MSFUserContact *contact = [[MSFUserContact alloc] init];
		contact.contactAddress = self.viewModel.fullAddress;
		contact.openDetailAddress = NO;
		[_tempContactList addObject:contact];
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
	picker.displayedProperties = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty] , nil];
	[self presentViewController:picker animated:YES completion:nil];
	if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
		picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
	}
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
	NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
	phone = [[phone componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
	NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(person);
	MSFUserContact *contact = self.tempContactList[peoplePicker.view.tag];
	contact.contactMobile = phone;
	contact.contactName = fullName;
	[self.tableView reloadData];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	return YES;
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
	[peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
	NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
	NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
	phone = [[phone componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
	NSString *fullName = (__bridge NSString *)ABRecordCopyCompositeName(person);
	MSFUserContact *contact = self.tempContactList[peoplePicker.view.tag];
	contact.contactMobile = phone;
	contact.contactName = fullName;
	[self.tableView reloadData];
	[peoplePicker dismissViewControllerAnimated:YES completion:nil];
	return NO;
}

#pragma mark - ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
	return YES;
}

@end
