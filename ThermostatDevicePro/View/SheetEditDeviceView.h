//
//  SheetEditDeviceView.h
//  HotWindPro
//
//  Created by lyric on 2017/3/28.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TapViewEditType) {
    TapViewEditTypeName,
    TapViewEditTypePassword,
    TapViewEditTypeDelete,
};

@class SheetEditDeviceView;
@class ThermostatDeviceModel;

typedef void(^SheetEditDeviceViewBlock)(SheetEditDeviceView *editView ,TapViewEditType choiceType);
@interface SheetEditDeviceView : UIView


@property (nonatomic , copy)SheetEditDeviceViewBlock callBack;
@property (nonatomic , strong)ThermostatDeviceModel *currentDevice;

//设备编辑器
+ (instancetype)initWithThermostatDevice:(ThermostatDeviceModel *)device andcall:(SheetEditDeviceViewBlock)callBack;

//显示
-(void)showEditDeviceView;

//销毁
-(void)dismissEditDeviceView;



@end
