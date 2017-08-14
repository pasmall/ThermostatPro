//
//  DeviceTimerModel.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumList.h"

typedef NS_ENUM(NSUInteger, DeviceTimerModelType) {
    DeviceTimerModelTypeOff,                //关定时
    DeviceTimerModelTypeOn,                 //开定时
    DeviceTimerModelTypeStage,              //阶段性定时
};

typedef NS_OPTIONS(NSUInteger, WeekType) {

    WeekTypeNull       = 1 << 0,   //默认    0001  '<<'左移运算
    WeekTypeMon        = 1 << 1,   //周一    0010
    WeekTypeTue        = 1 << 2,   //周二    0100
    WeekTypeWed        = 1 << 3,   //周三    1000
    WeekTypeThu        = 1 << 4,   //周四
    WeekTypeFir        = 1 << 5,   //周五
    WeekTypeSat        = 1 << 6,   //周六
    WeekTypeSun        = 1 << 7,   //周日
    WeekTypeAll        = 1 << 8,   //每天
};


@interface DeviceTimerModel : NSObject

@property(nonatomic,assign)BOOL timerIsOpen;//定时器当前状态（表示开关）

@property(nonatomic,assign)WeekType repeatWeeks;//重复时间(8位二进制数据，1代表重复，0代表不重复)
@property(nonatomic,assign)long long deviceSerialID;//定时器绑定的设备
@property(nonatomic,assign)NSUInteger timerID;//定时器的唯一标示
@property(nonatomic,assign)NSUInteger beginTime; //开始时间（字符串）
@property(nonatomic,assign)NSUInteger endTime;   //结束时间（开关定时无结束时间）
@property(nonatomic,assign)float deviceTemp;//设备调节温度

@property(nonatomic,assign)DeviceTimerModelType timerType;//定时器类型
@property(nonatomic,assign)DeviceModelType deviceMode;//设备Mode
@property(nonatomic,assign)DeviceWindModelType deviceWindMode;//设备风速档位模式
@property(nonatomic,assign)DeviceSceneModelType deviceSceneMode;//当前情景模式




@end
