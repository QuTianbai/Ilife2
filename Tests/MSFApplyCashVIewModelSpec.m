//
// MSFApplyCashVIewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFApplyCashVIewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFLoanType.h"

QuickSpecBegin(MSFApplyCashVIewModelSpec)

__block MSFApplyCashVIewModel *sut;

it(@"should has loantype", ^{
	// given
	MSFFormsViewModel *formsViewModel = mock([MSFFormsViewModel class]);
	MSFLoanType *loanType = mock([MSFLoanType class]);
	stubProperty(loanType, typeID, @"foo");
	
	// when
	sut = [[MSFApplyCashVIewModel alloc] initWithViewModel:formsViewModel loanType:loanType];
	
	// then
	expect(sut.loanType).notTo(beNil());
	expect(sut.loanType.typeID).to(equal(@"foo"));
});

QuickSpecEnd
