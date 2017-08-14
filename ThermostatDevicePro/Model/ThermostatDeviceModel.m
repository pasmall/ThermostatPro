//
//  ThermostatDeviceModel.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "ThermostatDeviceModel.h"
#import "FMDB.h"

#define MAX_TEMP 35 //最大温度
#define MIN_TEMP 5 //最小温度

#define MAX_AFTERTIME 28800 //最大定时时间(单位秒)
#define TWO_HOURS 7200

@implementation ThermostatDeviceModel{
    FinishBlock finishBlock;
    FMDatabase  *_db;

}

//初始化设备
- (instancetype)initWithSerialID:(long long )sid andName:(NSString *)name andPassword:(NSString *)password
{
    if (self = [self init]) {
        self.deviceSerialID = sid;
        if (name == nil) {
            self.deviceName = [NSString stringWithFormat:@"设备[%lld]", sid % 10000];
        }else{
            self.deviceName = name;
        }
        self.devicePassWord = password;
    }
    
    return self;
    
}

- (instancetype)init
{
    if (self = [super init]) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"devices.sql"];
        _db = [FMDatabase databaseWithPath:filePath];
        
        [_db open];
        
        // 初始化数据表
        NSString *deviceSql = @"CREATE TABLE IF NOT EXISTS 'device' ('device_id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'device_serial_id' long,'device_name' VARCHAR(255) ,'device_password' VARCHAR(255),'device_model' INTEGER default 0,'device_wind' INTEGER default 0,'device_scene' INTEGER default 0,'device_lock' INTEGER default 0,'device_temp' FLOAT default 24,'device_smarttemp' INTEGER default 0,'device_smartline' INTEGER default 0)";
        
        [_db executeUpdate:deviceSql];
        
        [_db close];
        
    }
    return self;
}

- (void)setDeviceSerialID:(long long)deviceSerialID
{
    _deviceSerialID = deviceSerialID;
    NSString *seridString = [NSString stringWithFormat:@"%lld",(long long)deviceSerialID];
    _deviceTimer = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:seridString];
    _currentTimers = [self getAllTimers];
}

//修改设备名称
- (void)changeDeviceName:(NSString *)name
{
    _deviceName = name;
    [self updateThermostatDeviceName];
}

//修改设备密码
- (void)changeDevicePassword:(NSString *)password
{
    _devicePassWord = password;
    [self updateThermostatDevicePassword];
}

//修改温度值
- (void)changeTempValue:(float)value
{
    _deviceTemp = value;
    [self updateThermostatDeviceTemp];
}

//点击设备开关按钮
- (void)tapDeviceOnOrOffAction
{
    if (self.deviceState == DeviceStateTypeOn) {
        self.deviceState = DeviceStateTypeOff;
    }else{
        self.deviceState = DeviceStateTypeOn;
    }
    
    _deviceTimer = nil;
    NSString *seridString = [NSString stringWithFormat:@"%lld",(long long)_deviceSerialID];
    [[NSUserDefaults standardUserDefaults] setObject:_deviceTimer forKey:seridString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

//点击设备定时按钮
- (void)tapDeviceTimeActionBlock:(FinishBlock)block;
{
    finishBlock = block;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(setTimer) object:nil];
    [self performSelector:@selector(setTimer) withObject:nil afterDelay:.5f];

}

- (void)setTimer
{
    if (_deviceTimer == nil) {
        _deviceTimer = [NSDate dateWithTimeIntervalSinceNow:30];
        NSString *seridString = [NSString stringWithFormat:@"%lld",(long long)_deviceSerialID];
        [[NSUserDefaults standardUserDefaults] setObject:_deviceTimer forKey:seridString];
        [[NSUserDefaults standardUserDefaults]synchronize];
        finishBlock();
        return;
    }
    
    NSTimeInterval time = [_deviceTimer  timeIntervalSinceNow];
    
    if (time < MAX_AFTERTIME) {
        if (time < TWO_HOURS) {
            _deviceTimer = [NSDate dateWithTimeInterval:1800 sinceDate:_deviceTimer];
        }else{
            _deviceTimer = [NSDate dateWithTimeInterval:3600 sinceDate:_deviceTimer];
        }
        
    }else{
        _deviceTimer = nil;
    }
    
    
    NSString *seridString = [NSString stringWithFormat:@"%lld",(long long)_deviceSerialID];
    [[NSUserDefaults standardUserDefaults] setObject:_deviceTimer forKey:seridString];
    [[NSUserDefaults standardUserDefaults]synchronize];
    finishBlock();
    
}


//点击Mode
- (void)tapDeviceModelAction
{
    if (_deviceMode < DeviceModelTypeChangeAir) {
        _deviceMode = _deviceMode + 1;
    }else{
        _deviceMode = DeviceModelTypeHot;
    }
     [self updateThermostatDeviceModel];
}

//点击设备情景按钮
- (void)tapDeviceSceneAction
{
    
    if (_deviceSceneMode < DeviceSceneModelTypeLeaveHome) {
        _deviceSceneMode = _deviceSceneMode + 1;
    }else{
        _deviceSceneMode = DeviceSceneModelTypeCTemp;
    }
    [self updateThermostatDeviceScene];
}

//点击设备锁按钮
- (void)tapDeviceLockAction
{
    if (_deviceLockMode < DeviceLockModelTypeLimtAll) {
        _deviceLockMode = _deviceLockMode + 1;
    }else{
        _deviceLockMode = DeviceLockModelTypeNo;
    }
    [self updateThermostatDeviceLock];
}

//点击设置风速按钮
- (void)tapDeviceWindModelAction
{
    if (_deviceWindMode < DeviceWindModelTypeHigh) {
        _deviceWindMode = _deviceWindMode + 1;
    }else{
        _deviceWindMode = DeviceWindModelTypeLow;
    }
    
    [self updateThermostatDeviceWind];
}

//智能恒温开关
- (void)tapDeviceCTempSwitch
{
    _deviceCTemp = !_deviceCTemp;
    [self updateThermostatDeviceSmarttemp];
}

//温度曲线开关
- (void)tapDeviceTempGraphSwitch
{
    _deviceTempGraph = !_deviceTempGraph;
    [self updateThermostatDeviceSmartline];
}

#pragma mark 设备定时器

//添加定时器
- (void)addDeviceTimer:(DeviceTimerModel *)timer
{
    
    [_db open];
    [_db executeUpdate:@"INSERT INTO timer(device_serial_id,timer_begin,timer_end,timer_temp,timer_model,timer_wind,timer_scene,timer_weeks,timer_open,timer_type)VALUES(?,?,?,?,?,?,?,?,?,?)",@(timer.deviceSerialID),@(timer.beginTime),@(timer.endTime),@(timer.deviceTemp),@(timer.deviceMode),@(timer.deviceWindMode),@(timer.deviceSceneMode),@(timer.repeatWeeks),@(timer.timerIsOpen),@(timer.timerType)];
    
    FMResultSet *res = [_db executeQuery:@"SELECT timer_id FROM timer"];
    NSInteger timerID = 0;
    while ([res next]) {
        timerID = [res intForColumn:@"timer_id"];
    }
    [_db close];
    
    timer.timerID = timerID;
    
    [self.currentTimers addObject:timer];
    [self sortArrayWithTimers:_currentTimers];
}

//删除定时器
- (void)deleteDeviceTimerWithID:(NSInteger )timerID
{
    [_db open];
    [_db executeUpdate:@"DELETE FROM timer WHERE timer_id = ?",@(timerID)];
    [_db close];

}

//修改定时器
- (void)updateDeviceTimer:(DeviceTimerModel *)timer
{
    DeviceTimerModel *currentTimer  = [self getDeviceTimerWithID:timer.timerID];

    currentTimer.beginTime = timer.beginTime;
    currentTimer.endTime = timer.endTime;
    currentTimer.deviceTemp = timer.deviceTemp;
    currentTimer.deviceMode = timer.deviceMode;
    currentTimer.deviceWindMode = timer.deviceWindMode;
    currentTimer.deviceSceneMode = timer.deviceSceneMode;
    currentTimer.timerIsOpen = timer.timerIsOpen;
    currentTimer.repeatWeeks = timer.repeatWeeks;

    [_db open];
    [_db executeUpdate:@"UPDATE timer SET timer_begin = ?,timer_end = ?,timer_temp = ?,timer_model = ?,timer_wind = ?,timer_scene = ?,timer_weeks = ?,timer_open = ?,timer_type = ?  WHERE timer_id = ? ",@(timer.beginTime),@(timer.endTime),@(timer.deviceTemp),@(timer.deviceMode),@(timer.deviceWindMode),@(timer.deviceSceneMode),@(timer.repeatWeeks),@(timer.timerIsOpen),@(timer.timerType),@(timer.timerID)];
    [_db close];
    
}

//根据timerId获取定时器
- (DeviceTimerModel *)getDeviceTimerWithID:(NSInteger )timerID
{
    for (DeviceTimerModel *obj in _currentTimers) {
        if (obj.timerID == timerID) {
            return obj;
        }
    }
    return nil;
}

- (NSMutableArray *)getAllTimers
{
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM timer WHERE device_serial_id = ?",@(_deviceSerialID)];
    
    while ([res next]) {
        DeviceTimerModel *timer = [[DeviceTimerModel alloc] init];
        timer.timerID = [res intForColumn:@"timer_id"];
        timer.deviceSerialID = [[res stringForColumn:@"device_serial_id"] longLongValue];
        timer.beginTime = [res intForColumn:@"timer_begin"];
        timer.endTime = [res intForColumn:@"timer_end"];
        
        timer.deviceTemp = [res doubleForColumn:@"timer_temp"];
        timer.deviceMode = [res intForColumn:@"timer_model"];
        timer.deviceWindMode = [res intForColumn:@"timer_wind"];
        timer.deviceSceneMode = [res intForColumn:@"timer_scene"];
        timer.timerIsOpen = [res intForColumn:@"timer_open"];
        timer.timerType = [res intForColumn:@"timer_type"];
        timer.repeatWeeks = [res intForColumn:@"timer_weeks"];
        
        [dataArray addObject:timer];
    }
    [self sortArrayWithTimers:dataArray];
    [_db close];
    return dataArray;
}

//定时器数组排序
- (NSMutableArray *)sortArrayWithTimers:(NSMutableArray *)timers
{
    [timers sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(DeviceTimerModel *obj1, DeviceTimerModel *obj2) {
        if (obj1.beginTime > obj2.beginTime ) {
            return NSOrderedDescending;
        } else if (obj1.beginTime < obj2.beginTime) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
    return timers;
}


#pragma mark 设备
//更新设备昵称
- (void)updateThermostatDeviceName
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_name = ?  WHERE device_serial_id = ? ",_deviceName ,@(_deviceSerialID)];
    [_db close];
}

//更新设备密码
- (void)updateThermostatDevicePassword
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_password = ?  WHERE device_serial_id = ? ",_devicePassWord,@(_deviceSerialID)];
    [_db close];
}

//更新mode
- (void)updateThermostatDeviceModel
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_model = ?  WHERE device_serial_id = ? ",@(_deviceMode) ,@(_deviceSerialID)];
    [_db close];

}

//更新wind
- (void)updateThermostatDeviceWind
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_wind = ?  WHERE device_serial_id = ? ",@(_deviceWindMode) ,@(_deviceSerialID)];
    [_db close];

}

//更新Lock
- (void)updateThermostatDeviceLock
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_scene = ?  WHERE device_serial_id = ? ",@(_deviceLockMode) ,@(_deviceSerialID)];
    [_db close];

}

//更新Scene
- (void)updateThermostatDeviceScene
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_lock = ?  WHERE device_serial_id = ? ",@(_deviceSceneMode) ,@(_deviceSerialID)];
    [_db close];

}

//更新temp
- (void)updateThermostatDeviceTemp
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_temp = ?  WHERE device_serial_id = ? ",@(_deviceTemp) ,@(_deviceSerialID)];
    [_db close];
}

//智能恒温开关
- (void)updateThermostatDeviceSmarttemp
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_smarttemp = ?  WHERE device_serial_id = ? ",@(_deviceCTemp) ,@(_deviceSerialID)];
    [_db close];

}

//智能曲线
- (void)updateThermostatDeviceSmartline
{
    [_db open];
    [_db executeUpdate:@"UPDATE device SET device_smartline = ?  WHERE device_serial_id = ? ",@(_deviceTempGraph) ,@(_deviceSerialID)];
    [_db close];

}




@end
