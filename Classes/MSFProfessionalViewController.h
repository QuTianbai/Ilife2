//
//  MSFPersonInfoTableViewController.h
//  Cash
//
//  Created by xbm on 15/5/23.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

// 职业信息
@interface MSFProfessionalViewController : UITableViewController <MSFReactiveView>

// 社会身份
@property(nonatomic,weak) IBOutlet UITextField *education;//教育程度code
@property(nonatomic,weak) IBOutlet UITextField *socialStatus;//社会身份
@property(nonatomic,weak) IBOutlet UITextField *workingLength;//工作年限 工作年限

@property(nonatomic,weak) IBOutlet UIButton *educationButton;
@property(nonatomic,weak) IBOutlet UIButton *socialStatusButton;
@property(nonatomic,weak) IBOutlet UIButton *workingLengthButton;

// 学校信息
@property(nonatomic,weak) IBOutlet UITextField *universityName;//学校名称 学校名称
@property(nonatomic,weak) IBOutlet UITextField *enrollmentYear;//入学年份 入学年份
@property(nonatomic,weak) IBOutlet UITextField *programLength;//学制 学制

@property(nonatomic,weak) IBOutlet UIButton *enrollmentYearButton;//入学年份 入学年份
@property(nonatomic,weak) IBOutlet UIButton *programLengthButton;//学制 学制

// 单位信息
@property(nonatomic,weak) IBOutlet UITextField *company;//单位/个体全称 单位/个体名称
@property(nonatomic,weak) IBOutlet UITextField *companyType;//单位性质code
@property(nonatomic,weak) IBOutlet UITextField *industry;//行业类别code

@property(nonatomic,weak) IBOutlet UIButton *companyTypeButton;//单位性质code
@property(nonatomic,weak) IBOutlet UIButton *industryButton;//行业类别code

// 职位信息
@property(nonatomic,weak) IBOutlet UITextField *department;//任职部门 任职部门
@property(nonatomic,weak) IBOutlet UITextField *position;//职位 title
@property(nonatomic,weak) IBOutlet UITextField *currentJobDate;//现工作开始时间 工作开始时间

@property(nonatomic,weak) IBOutlet UIButton *departmentButton;//任职部门 任职部门
@property(nonatomic,weak) IBOutlet UIButton *positionButton;//职位 title
@property(nonatomic,weak) IBOutlet UIButton *currentJobDateButton;//现工作开始时间 工作开始时间

// 单位联系方式
@property(nonatomic,weak) IBOutlet UITextField *unitAreaCode;//办公/个体电话区号
@property(nonatomic,weak) IBOutlet UITextField *unitTelephone;//办公/个体电话
@property(nonatomic,weak) IBOutlet UITextField *unitExtensionTelephone;//办公/个体电话分机号

@property(nonatomic,weak) IBOutlet UITextField *address;
@property(nonatomic,weak) IBOutlet UIButton *addressButton;

@property(nonatomic,weak) IBOutlet UITextField *workTown;// 单位所在镇 单位地址镇

@property(nonatomic,weak) IBOutlet UIButton *nextButton;

@end
