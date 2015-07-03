//
// MSFUserViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClient+Users.h"
#import "MSFUser.h"
#import "NSString+Matches.h"
#import "MSFAuthorizeViewModel.h"

static const int kPasswordMaxLength = 16;
static const int kPasswordMinLength = 8;

@interface MSFUserViewModel ()

@property(nonatomic,strong,readwrite) RACSubject *contentUpdateSignal;

@end

@implementation MSFUserViewModel

#pragma mark - Lifecycle

- (instancetype)initWithClient:(MSFClient *)client {
  self = [super init];
  if (!self) {
    return nil;
  }
  _client = client;
  _usedPassword = @"";
  _updatePassword = @"";
  
  @weakify(self)
  _executeUpdatePassword =
  [[RACCommand alloc] initWithEnabled:self.updateValidSignal signalBlock:^RACSignal *(id input) {
    @strongify(self)
    if (![self.updatePassword isPassword]) {
      return [RACSignal
        error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{
          NSLocalizedFailureReasonErrorKey:@"请输入8位以上数字和字母混合密码"
        }]];
    }
    
    return [self executeUpdatePasswordSignal];
  }];
  
  self.contentUpdateSignal = [[RACSubject subject] setNameWithFormat:@"MSFUserViewModel `contentUpdateSignal`"];
  [self.didBecomeActiveSignal subscribeNext:^(id x) {
    @strongify(self)
    [[self.client fetchUserInfo] subscribeNext:^(MSFUser *user) {
      self.username = user.name;
      self.mobile = user.phone;
      self.identifyCard = user.idcard;
      [(RACSubject *)self.contentUpdateSignal sendNext:nil];
    }];
  }];
  
  return self;
}

#pragma mark - Public

- (RACSignal *)updateValidSignal {
  return [[RACSignal combineLatest:@[
      RACObserve(self, usedPassword),
      RACObserve(self, updatePassword)
    ]]
    reduceEach:^id(NSString *password1, NSString *password2){
      return @(
        password1.length > kPasswordMinLength - 1 &&
        password1.length < kPasswordMaxLength + 1 &&
        password2.length > kPasswordMinLength - 1 &&
        password2.length < kPasswordMaxLength + 1 &&
        ![password1 isEqualToString:password2]
      );
  }];
}

#pragma mark - Private

- (RACSignal *)executeUpdatePasswordSignal {
  return [self.client updateUserPassword:self.usedPassword password:self.updatePassword];
}

@end
