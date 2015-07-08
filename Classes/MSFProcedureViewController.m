//
// MSFProcedureViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProcedureViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <REFormattedNumberField/REFormattedNumberField.h>
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"

@interface MSFProcedureViewController () <UITextFieldDelegate>

@end

@implementation MSFProcedureViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  @weakify(self)
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if ([textField isEqual:self.card]) {
    textField.text = [textField.text uppercaseString];
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSLog(@"textField:%@ shouldChangeCharactersInRange:%@ replacementString: %@",textField.text,NSStringFromRange(range),string);
  
  if ([textField isEqual:self.name]) {
    NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    
    return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
  }
  else if ([textField isEqual:self.card]) {
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
