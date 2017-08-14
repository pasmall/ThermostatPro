//
//  UITextField+NumberFormat.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/19.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    
    kIDCardNoTextFieldType, //身份证号
    kPhoneNumberTextFieldType, //手机号
    kBankCardNumberTextFieldType, //银行卡号
    kSerialNumberTextFieldType, //12位序列号
    
}kTextFieldType;

@interface UITextField (NumberFormat)

/**
 *  输入号码格式化
 *  参数 textField UITextField控件
 *  参数 range 文本范围
 *  参数 string 字符串
 *  参数 type 文本框输入号码类型（身份证，手机号，银行卡）
 */


+ (BOOL)numberFormatTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string textFieldType:(kTextFieldType)type;


@end
