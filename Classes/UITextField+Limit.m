//
//  UITextField+Limit.m
//  Finance
//
//  Created by admin on 16/3/18.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "UITextField+Limit.h"
#import <objc/runtime.h>
static void *TextFieldLength = &TextFieldLength;
static void *TextFieldRex = &TextFieldRex;
static void *TextFieldLast = &TextFieldLast;

@implementation UITextField (Limit)
- (void)limitWitLength:(int)length {
    objc_setAssociatedObject(self, TextFieldLength, @(length), OBJC_ASSOCIATION_ASSIGN);
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSNumber *length = objc_getAssociatedObject(self, TextFieldLength);
        if (textField.text.length > [length integerValue]) {
            textField.text = [textField.text substringToIndex:[length integerValue]];
        }
}

- (void)limitWitRex:(NSString *)rex {
    objc_setAssociatedObject(self, TextFieldRex, rex, OBJC_ASSOCIATION_COPY);
    objc_setAssociatedObject(self, TextFieldLast, @"", OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(textFieldDidChangeForRex:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)textFieldDidChangeForRex:(UITextField *)textField {
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", objc_getAssociatedObject(self, TextFieldRex)];
    if ([numberPre evaluateWithObject:textField.text]) {
        objc_setAssociatedObject(self, TextFieldLast, textField.text, OBJC_ASSOCIATION_COPY);
    } else {
        textField.text = objc_getAssociatedObject(self, TextFieldLast);
    }
}

@end
