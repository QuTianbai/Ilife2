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

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;

@end
