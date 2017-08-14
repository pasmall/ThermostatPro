//
//  ThermostatDeviceModel.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumList.h"
#import "DeviceTimerModel.h"

typedef void(^FinishBlock)();


@interface ThermostatDeviceModel : NSObject

@property(nonatomic,assign)long long deviceSerialID;//设备序列号
@property(nonatomic,strong)NSString *deviceName;//设备昵称
@property(nonatomic,strong)NSString *devicePassWord;//设备密码

@property(nonatomic,assign)DeviceNetStateType deviceNetState;//设备网络状态
@property(nonatomic,assign)DeviceStateType deviceState;//设备状态（待机和开机）
@property(nonatomic,assign)DeviceModelType deviceMode;//设备Mode
@property(nonatomic,assign)DeviceWindModelType deviceWindMode;//设备风速档位模式
@property(nonatomic,assign)DeviceSceneModelType deviceSceneMode;//当前情景模式
@property(nonatomic,assign)DeviceLockModelType deviceLockMode;//当前童锁状态
    
@property(nonatomic,strong)NSDate *deviceTimer;//设备定时
@property(nonatomic,assign)NSUInteger ambientHumidity;//空气湿度（0~100）
@property(nonatomic,assign)float ambientTemp;//环境温度
@property(nonatomic,assign)float deviceTemp;//设备调节温度

@property(nonatomic,assign)BOOL deviceCTemp; //智能恒温是否开启
@property(nonatomic,assign)BOOL deviceTempGraph; //温度曲线是否开启

@property(nonatomic,strong)NSMutableArray *currentTimers;//设备定时器数组

//初始化设备
- (instancetype)initWithSerialID:(long long)sid andName:(NSString *)name andPassword:(NSString *)password ;

//点击设备开关按钮
- (void)tapDeviceOnOrOffAction;

//点击设备定时按钮
- (void)tapDeviceTimeActionBlock:(FinishBlock)block;

//点击Mode
- (void)tapDeviceModelAction;

//点击设备情景按钮
- (void)tapDeviceSceneAction;

//点击设备锁按钮
- (void)tapDeviceLockAction;

//点击设置风速按钮
- (void)tapDeviceWindModelAction;

//智能恒温开关
- (void)tapDeviceCTempSwitch;

//温度曲线开关
- (void)tapDeviceTempGraphSwitch;

//修改设备名称
- (void)changeDeviceName:(NSString *)name;

//修改设备密码
- (void)changeDevicePassword:(NSString *)password;

//修改温度值
- (void)changeTempValue:(float)value;

//添加定时器
- (void)addDeviceTimer:(DeviceTimerModel *)timer;

//修改定时器
- (void)updateDeviceTimer:(DeviceTimerModel *)timer;

//删除定时器
- (void)deleteDeviceTimerWithID:(NSInteger )timerID;

//根据timerId获取定时器
- (DeviceTimerModel *)getDeviceTimerWithID:(NSInteger )timerID;


@end
