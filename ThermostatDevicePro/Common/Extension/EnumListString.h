//
//  EnumListString.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/19.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumList.h"

@interface EnumListString : NSObject

//枚举转字符串
+(NSString *)getStringWithDeviceWindModelType:(DeviceWindModelType )type;
+(NSString *)getStringWithDeviceModelType:(DeviceModelType )type;
+(NSString *)getStringWithDeviceSceneModelType:(DeviceSceneModelType )type;

//字符串转枚举
+(DeviceWindModelType)getDeviceWindModelType:(NSString *)typeString;
+(DeviceModelType)getDeviceModelType:(NSString *)typeString;
+(DeviceSceneModelType)getDeviceSceneModelType:(NSString *)typeString;


@end
