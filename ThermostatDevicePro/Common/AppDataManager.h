//
//  AppDataManager.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThermostatDeviceModel.h"

typedef NS_ENUM(NSUInteger, LangueType) {
    LangueTypeChinese,
    LangueTypeEnglish,
};

@interface AppDataManager : NSObject

@property(nonatomic , assign)LangueType currentLangueType; //当前所显示的语言
@property(nonatomic , assign)BOOL soundState ;//是否开启声音反馈
@property(nonatomic , assign)BOOL shakeStatue ;// 是否开启震动

@property(nonatomic , strong)NSMutableArray *currentDevices;//当前所有设备
@property(nonatomic , assign)long long currentDeviceSerialID; //正在操作的设备的序列号


+ (instancetype)sharedAppDataManager;

//对应key的String
-(NSString *)getLangueStringWithKey:(NSString *)key;

//获取wifi名称
- (NSString *)getWifiName;

//播放声音
- (void)palySound;

//震动一下
- (void)palyShake;

//声音+震动
- (void)palySoundAndShake;

//获取当前设备
- (ThermostatDeviceModel *)getCurrentDevice;

//添加设备
- (void)addThermostatDeviceWithName:(NSString *)name andPassword:(NSString *)passWord andSid:(long long)sid;

//删除设备
- (void)deleteThermostatDevice:(long long)deviceSerialID;



@end
