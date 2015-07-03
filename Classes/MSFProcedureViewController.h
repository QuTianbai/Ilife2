//
// MSFProcedureViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFProcedureViewController : UITableViewController

@property(nonatomic,weak) IBOutlet UITextField *name;
@property(nonatomic,weak) IBOutlet UITextField *card;
@property(nonatomic,weak) IBOutlet UITextField *expired;
@property(nonatomic,weak) IBOutlet UIButton *permanentButton;
@property(nonatomic,weak) IBOutlet UIButton *datePickerButton;
@property(nonatomic,weak) IBOutlet UIButton *submitButton;
@property(nonatomic,weak) IBOutlet UITextField *bankName;
@property(nonatomic,weak) IBOutlet UITextField *bankNO;
@property(nonatomic,weak) IBOutlet UITextField *bankAddress;
@property(nonatomic,weak) IBOutlet UIButton *bankNameButton;
@property(nonatomic,weak) IBOutlet UIButton *bankNOButton;
@property(nonatomic,weak) IBOutlet UIButton *bankAddressButton;

@end
