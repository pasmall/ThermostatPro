//
//  EnumPickerView.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/13.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PickerViewType) {
    PickerViewTypeAngle,                 //普通
    PickerViewTypeHaveImage,             //带图片
    PickerViewTypeHaveTitle,             //带标示文字

};


typedef void(^EnumPickerViewBlock)(NSInteger com,NSInteger row);


@interface EnumPickerView : UIView

@property (nonatomic , copy)EnumPickerViewBlock choiceBack;
@property (nonatomic , assign)PickerViewType pickerType;

//选择器
+(instancetype)sheetStringPickerWithTitleStrings:(NSArray *)strings andHeaderTitle:(NSString *)headerTitle andSubObjectCom:(NSInteger)subValueCom andSubObjectRow:(NSInteger)subValueRow andPickerType:(PickerViewType)type  andcall:(EnumPickerViewBlock)callBack;

//显示
-(void)showPicker;

//销毁
-(void)dismissPicker;

@end





