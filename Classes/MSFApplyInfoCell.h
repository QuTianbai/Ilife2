//
//  MSFApplyInfoCell.h
//  Finance
//
//  Created by 赵勇 on 12/3/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSFApplyInfoCellType) {
	MSFCellTypeContent				= 0,//输入框
	MSFCellTypeSelection			= 1,//选择
	MSFCellTypeCodePhone			= 2,//区号座机号
	MSFCellTypeCodePhoneExt		= 3,//区号座机号分机号
	MSFCellTypePhoneSelection = 4,//手机号电话本选择
	MSFCellTypeSwitch					= 5,//开关
	MSFCellTypeAddContact			= 6,//添加联系人
	MSFCellTypeConfirm				= 7,//确认
	MSFCellTypeBoldTitle			= 8,//粗体标题
	MSFCellTypeContentUnit		= 9,//输入框收入单位
	MSFCellTypeEduLength			= 10//学制
};

@interface MSFApplyInfoCell : UITableViewCell

@end
