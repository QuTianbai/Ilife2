//
// MSFCreditViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCreditViewController.h"
//#import <Masonry.h>
#import "MSFCreditCycleScrollView.h"
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface MSFCreditViewController ()
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) UIImage *backgroundImage;
@end

@implementation MSFCreditViewController

- (instancetype)initWithViewModel:(id)viewModel {
  //self = [super init];
    self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFCreditViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFCreditViewController class])];
  if (!self) {
    return nil;
  }
  
  return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navigationBar.tintColor = UIColor.whiteColor;
    self.shadowImage = navigationBar.shadowImage;
    self.backgroundImage = [navigationBar backgroundImageForBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];

    }

-(void)viewDidLoad
{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"马上贷";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"账单"
                                                                              style:UIBarButtonItemStyleDone target:nil action:nil];
    
   // self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.executeBillsCommand;

     //UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MSFCreditViewController" bundle:nil];
   // [self.storyboard instantiateViewControllerWithIdentifier:@"MSFCreditViewController"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setBackgroundImage:self.backgroundImage
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:self.shadowImage];

    
    
}

@end
