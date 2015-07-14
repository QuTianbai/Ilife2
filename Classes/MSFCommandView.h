//
//	MSFCommandView.h
//	Cash
//
//	Created by xbm on 15/5/18.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSFCommandView : UIView

//根据16进制数获得颜色
+ (UIColor *)getColorWithString:(NSString *)stringToConvert;
//创建button
+ (UIButton *)createButtonWithTitle:(NSString *)title backgroundClolr:(UIColor *)bgColor titleColor:(UIColor *)titleColor frame:(CGRect)frame selectedTitleColor:(UIColor *)seletTitleColor tag:(int)tag backImg:(UIImage *)img delegate:(id)delegate titleFont:(UIFont *)font;
//创建label
+ (UILabel *)createLabelWithTitle:(NSString *)title backgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor frame:(CGRect)frame tag:(int)tag;

+ (UITextField *)createTextFiled:(NSString *)text placeTitle:(NSString *)placeTitle frame:(CGRect)frame backgroungColor:(UIColor *)bgColor tag:(int)tag delegate:(id)delegate;

@end
