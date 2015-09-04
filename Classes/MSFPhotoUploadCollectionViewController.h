//
//  MSFPhotoUploadCollectionViewController.h
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFPhotoUploadCollectionViewController : UIViewController

@property (nonatomic, copy) void (^completionBlock) ();

- (void)bindViewModel:(id)viewModel;

@end
