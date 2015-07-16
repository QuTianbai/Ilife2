//
// MSFAuthorizationView.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFAuthorizationView : UIView <MSFReactiveView>

@property (nonatomic, strong) UIButton *signInButton;
@property (nonatomic, strong) UIButton *signUpButton;

@end
