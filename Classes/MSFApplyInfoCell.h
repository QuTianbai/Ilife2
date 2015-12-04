//
//  MSFApplyInfoCell.h
//  Finance
//
//  Created by 赵勇 on 12/3/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSFApplyInfoCellType) {
	MSFCellTypeUnknown = 0, //未知
	MSFCellTypeContent = 1, //输入框
	MSFCellTypeSelection = 2, //选择
	MSFCellTypeCodePhone = 3, //区号座机号
	MSFCellTypeCodePhoneExt = 4, //区号座机号分机号
	MSFCellTypePhoneSelection = 5, //手机号电话本选择
	MSFCellTypeSwitch = 6, //开关
	MSFCellTypeAddContact = 7, //添加联系人
	MSFCellTypeConfirm = 8, //确认
	MSFCellTypeBoldTitle = 9, //粗体标题
	MSFCellTypeContentUnit = 10, //输入框收入单位
	MSFCellTypeEduLength = 11 //学制
};

@interface MSFApplyInfoCell : UITableViewCell

@property (nonatomic, assign) MSFApplyInfoCellType type;

@end
