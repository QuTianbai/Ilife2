//
// NSString+Matches.m
//
// Copyright (c) 2014年 Zēng Liàng. All rights reserved.
//

#import "NSString+Matches.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"

@implementation NSString (Matches)

- (BOOL)isMobile {
	if (self.length == 0) return NO;
	if (self.length != 11) return NO;
	
	if (![[self substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
		return NO;
	}

	return YES;
}

- (BOOL)isScalar {
	NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
	[nf setNumberStyle:NSNumberFormatterNoStyle];
	
	NSNumber *number = [nf numberFromString:self];
	
	if (number) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)isMail {
	BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
	return [emailTest evaluateWithObject:self];
}

- (BOOL)isTelephone {
	NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0125-9])\\d{8}$";
	NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
	NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
	NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
	NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
	
	NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
	NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
	NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
	NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
	NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
	
	if (([regextestmobile evaluateWithObject:self] == YES)
			|| ([regextestcm evaluateWithObject:self] == YES)
			|| ([regextestct evaluateWithObject:self] == YES)
			|| ([regextestcu evaluateWithObject:self] == YES)
			|| ([regextestphs evaluateWithObject:self] == YES)) {
		
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)isIdentityCard {
	BOOL flag;
	if (self.length <= 0) {
		flag = NO;
		
		return flag;
	}
	NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
	NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	
	return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL)isPassword {
	BOOL lengValid = self.length > 7 && self.length < 17;
	if (!lengValid) {
		return NO;
	}
	
	BOOL formValid = [self isFormValid];
	return lengValid && formValid;
}

- (BOOL)isFormValid {
	NSString *digitTrimming  = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
	NSString *letter = [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
	NSString *upper = [letter stringByTrimmingCharactersInSet:[NSCharacterSet uppercaseLetterCharacterSet]];
	//BOOL b =  digitTrimming.length > 0 && digitTrimming.length < self.length;
	if (digitTrimming.length > 0 && digitTrimming.length < self.length) {
		return YES;
	} else if (upper.length > 0 && upper.length < self.length) {
		return YES;
	} else if (digitTrimming.length == self.length && upper.length == self.length) {
		return YES;
	}
	return NO;
}

- (BOOL)isCaptcha {
	return self.length == 4;
}

- (BOOL)isChineseName {
	NSString *nameRegex = @"^[\\u4E00-\\u9FA5]([\\u4E00-\\u9FA5]|\\u002e|\\u3002|\\\\ub7|\\u25aa){0,18}[\\u4E00-\\u9FA5]$";
	NSPredicate *nameText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
	return [nameText evaluateWithObject:self];
}

- (BOOL)isNum {
 NSScanner *scan = [NSScanner scannerWithString:self];
	int val;
	return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - Custom Accessors

- (BOOL)isValidName {
	NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
	NSCharacterSet *blockedCharatersSquared = [NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒"];
	return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) || ([self rangeOfCharacterFromSet:blockedCharatersSquared].location != NSNotFound);
}

- (BOOL)isValidIDCardRange:(NSRange)range {
	if (range.location > 17) return NO;
	if (range.location == 17) {
		NSCharacterSet *blockedCharacters = [[NSCharacterSet identifyCardCharacterSet] invertedSet];
		return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
	}
	NSCharacterSet *blockedCharacters = [[NSCharacterSet numberCharacterSet] invertedSet];
	return ([self rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
}

- (BOOL)isValidUsername {
	if (self.length == 0) return NO;
	if (self.length != 11) return NO;
	if (![[self substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
		return NO;
	}
	return YES;
}

- (BOOL)isValidPassword {
	BOOL lengValid = self.length > 7 && self.length < 17;
	BOOL formValid = NO;
	NSString *digitTrimming  = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
	NSString *letter = [self stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
	NSString *upper = [letter stringByTrimmingCharactersInSet:[NSCharacterSet uppercaseLetterCharacterSet]];
	if (digitTrimming.length > 0 && digitTrimming.length < self.length) {
		formValid = YES;
	} else if (upper.length > 0 && upper.length < self.length) {
		formValid = YES;
	} else if (digitTrimming.length == self.length && upper.length == self.length) {
		formValid = YES;
	}
	return lengValid && formValid;
}

- (BOOL)isValidCaptcha {
	return self.length == 4;
}

- (BOOL)isSimplePWD {
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 0; i<10; i++) {
		NSString *str = @"";
		for (int j = 0; j<6; j++) {
			str = [str stringByAppendingString:[NSString stringWithFormat:@"%d", i]];
		}
		[array addObject:str];
	}
	
	for (NSString *str in array) {
		if ([str isEqualToString:self]) {
			return YES;
			break;
		}
	}
	
	return NO;
}

- (BOOL)isShortAreaCode {
	if ([@[@"010", @"020", @"021" ,@"022" ,@"023" ,@"024" ,@"025" ,@"027" ,@"028", @"029"] containsObject:self]) {
		return YES;
	}
	return NO;
}

@end
