//
//  EnumListString.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/19.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "EnumListString.h"

@implementation EnumListString

//枚举转字符串
+(NSString *)getStringWithDeviceWindModelType:(DeviceWindModelType )type
{
    switch (type) {
        case DeviceWindModelTypeLow:
            return LANGUE_STRING(@"低风");
            break;
        case DeviceWindModelTypeMiddle:
            return LANGUE_STRING(@"中风");
            break;
        case DeviceWindModelTypeHigh:
            return LANGUE_STRING(@"高风");
            break;
            
        default:
            break;
    }
    
}

+(NSString *)getStringWithDeviceModelType:(DeviceModelType )type
{
    switch (type) {
        case DeviceModelTypeHot:
            return LANGUE_STRING(@"制热");
            break;
        case DeviceModelTypeCool:
            return LANGUE_STRING(@"制冷");
            break;
        case DeviceModelTypeChangeAir:
            return LANGUE_STRING(@"换气");
            break;
            
        default:
            break;
    }
    
}

+(NSString *)getStringWithDeviceSceneModelType:(DeviceSceneModelType )type
{
    switch (type) {
        case DeviceSceneModelTypeCTemp:
            return LANGUE_STRING(@"恒温");
            break;
        case DeviceSceneModelTypeEnergySaving:
            return LANGUE_STRING(@"节能");
            break;
        case DeviceSceneModelTypeLeaveHome:
            return LANGUE_STRING(@"离家");
            break;
            
        default:
            break;
    }
    
}

//字符串转枚举
+(DeviceWindModelType)getDeviceWindModelType:(NSString *)typeString
{
    if ([typeString isEqualToString:LANGUE_STRING(@"低风")]) {
        return DeviceWindModelTypeLow;
    }else if ([typeString isEqualToString:LANGUE_STRING(@"中风")]){
        return DeviceWindModelTypeMiddle;
    }else{
        return DeviceWindModelTypeHigh;
    }
}

+(DeviceModelType)getDeviceModelType:(NSString *)typeString
{
    if ([typeString isEqualToString:LANGUE_STRING(@"制热")]) {
        return DeviceModelTypeHot;
    }else if ([typeString isEqualToString:LANGUE_STRING(@"制冷")]){
        return DeviceModelTypeCool;
    }else{
        return DeviceModelTypeChangeAir;
    }
}
+(DeviceSceneModelType)getDeviceSceneModelType:(NSString *)typeString
{
    if ([typeString isEqualToString:LANGUE_STRING(@"恒温")]) {
        return DeviceSceneModelTypeCTemp;
    }else if ([typeString isEqualToString:LANGUE_STRING(@"节能")]){
        return DeviceSceneModelTypeEnergySaving;
    }else{
        return DeviceSceneModelTypeLeaveHome;
    }
}


@end
