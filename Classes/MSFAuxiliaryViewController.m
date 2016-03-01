//
// MSFAuxiliaryViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFAuxiliaryViewController.h"

@implementation MSFAuxiliaryViewController

#pragma mark - NSObject

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFAuxiliaryViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFAuxiliaryViewController class])];
  if (!self) {
    return nil;
  }
	
	//TODO: 待完善接口内容
  return self;
}

@end
