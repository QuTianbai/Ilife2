//
//  MSFCreditFooterViewController.h
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@interface MSFCreditFooterViewController : UIViewController <MSFReactiveView>
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVIew;

@end
