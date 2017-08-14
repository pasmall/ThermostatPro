//
//  EnumList.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#ifndef EnumList_h
#define EnumList_h

typedef NS_ENUM(NSUInteger, DeviceStateType) {
    DeviceStateTypeOff,     //设备待机
    DeviceStateTypeOn,      //设备开机
};

typedef NS_ENUM(NSUInteger, DeviceNetStateType) {
    
    DeviceNetStateTypeUnknow,   //登录中
    DeviceNetStateTypeOff,      //设备离线（登录超时）
    DeviceNetStateTypeOn,       //设备在线
};

typedef NS_ENUM(NSUInteger, DeviceModelType) {
    DeviceModelTypeHot,         //制热
    DeviceModelTypeCool,        //制冷
    DeviceModelTypeChangeAir,   //换气
    
    
};

typedef NS_ENUM(NSUInteger, DeviceWindModelType) {
    DeviceWindModelTypeLow,     //低风
    DeviceWindModelTypeMiddle,  //中风
    DeviceWindModelTypeHigh,    //高风
    
};

typedef NS_ENUM(NSUInteger, DeviceSceneModelType) {
    DeviceSceneModelTypeCTemp,              //恒温
    DeviceSceneModelTypeEnergySaving,       //节能
    DeviceSceneModelTypeLeaveHome,          //离家
};

typedef NS_ENUM(NSUInteger, DeviceLockModelType) {
    DeviceLockModelTypeNo,              //关闭
    DeviceLockModelTypeLimtOnAndOff,    //限制开关
    DeviceLockModelTypeLimtAll,         //限制所有
};


#endif /* EnumList_h */
