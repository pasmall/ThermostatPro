//
//  AppDataManager.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "AppDataManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import<SystemConfiguration/CaptiveNetwork.h>
#import<SystemConfiguration/SystemConfiguration.h>
#import<CoreFoundation/CoreFoundation.h>
#import "FMDB.h"


#define LANGUE_TYPE_STRING @"UserSettingLanguages"
#define SOUND_KEY @"soundkey"
#define SHAKE_KEY @"shakekey"


static AppDataManager *_dataManager;

@interface AppDataManager(){
    FMDatabase  *_db;
}
    
@property(nonatomic,assign)SystemSoundID soundID;//播放文件标识
    
@end

@implementation AppDataManager

+ (instancetype)sharedAppDataManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _dataManager = [[self alloc]init];
        
    });
    return _dataManager;
    
}

- (instancetype)init
{
    if (self == nil) {
        self = [super init];
    }
    [self initDataBase];
    self.currentLangueType = [[NSUserDefaults standardUserDefaults] integerForKey:LANGUE_TYPE_STRING];
    self.soundState = [[NSUserDefaults standardUserDefaults] boolForKey:SOUND_KEY];
    self.shakeStatue = [[NSUserDefaults standardUserDefaults] boolForKey:SHAKE_KEY];
    //初始化获取设备信息
    self.currentDevices =[NSMutableArray arrayWithArray:[self getAllThermostatDevice]];
    DLog(@"%@" ,self.currentDevices);
    
    return self;
}

//初始化数据库&建表
-(void)initDataBase
{
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"devices.sql"];
    DLog(@"数据库文件位置：%@" ,filePath);
    _db = [FMDatabase databaseWithPath:filePath];

}

- (NSArray *)getAllThermostatDevice
{
    [_db open];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM device"];
    
    while ([res next]) {
        ThermostatDeviceModel *device = [[ThermostatDeviceModel alloc] init];
        device.deviceSerialID = [[res stringForColumn:@"device_serial_id"] longLongValue];
        device.deviceName = [res stringForColumn:@"device_name"];
        device.devicePassWord = [res stringForColumn:@"device_password"];
        
        device.deviceMode = [res intForColumn:@"device_model"];
        device.deviceWindMode = [res intForColumn:@"device_wind"];
        device.deviceSceneMode = [res intForColumn:@"device_scene"];
        device.deviceLockMode = [res intForColumn:@"device_lock"];
        device.deviceTemp = [res doubleForColumn:@"device_temp"];
        
        device.deviceCTemp = [res intForColumn:@"device_smarttemp"];
        device.deviceTempGraph = [res intForColumn:@"device_smartline"];
        
        device.deviceState = DeviceStateTypeOn;
        device.deviceNetState = DeviceNetStateTypeOn;
        
        [dataArray addObject:device];
    }
    
    [_db close];
    
    return dataArray;

}

//获取对应key的语言
-(NSString *)getLangueStringWithKey:(NSString *)key
{
    
    NSString *langueTypeString = [self getLangueType:_currentLangueType];
    NSString *path = [[NSBundle mainBundle] pathForResource:langueTypeString ofType:@"lproj"];
    
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:@"Localizable"];
}

//语言扩展
- (NSString *)getLangueType:(LangueType )type
{
    switch (type) {
        case LangueTypeChinese:
        return @"zh-Hans";
        break;
        case LangueTypeEnglish:
        return @"en";
        break;
        
        default:
        break;
    }
    
}

#pragma mark 属性赋值重写,保存配置信息
- (void)setCurrentLangueType:(LangueType)currentLangueType
{
    
    _currentLangueType = currentLangueType;
    [[NSUserDefaults standardUserDefaults] setInteger:currentLangueType forKey:LANGUE_TYPE_STRING];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)setSoundState:(BOOL)soundState
{
    _soundState = soundState;
    [[NSUserDefaults standardUserDefaults]setBool:soundState forKey:SOUND_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setShakeStatue:(BOOL)shakeStatue
{
    _shakeStatue = shakeStatue;
    [[NSUserDefaults standardUserDefaults]setBool:shakeStatue forKey:SHAKE_KEY];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark 系统声音和震动
//播放声音
- (void)palySound
{
    
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received2",@"caf"];
    if(path){
        
        SystemSoundID theSoundID;
        OSStatus error =AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&theSoundID);
        if(error == kAudioServicesNoError){
            _soundID = theSoundID;
        }else{
            NSLog(@"Failed to create sound");
        }
    }
    AudioServicesPlaySystemSound(_soundID);
}

//震动一下
- (void)palyShake
{
    _soundID = kSystemSoundID_Vibrate;
    AudioServicesPlaySystemSound(_soundID);
}

//声音+震动
- (void)palySoundAndShake
{
    //获取到系统文件中的声音
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",@"sms-received2",@"caf"];
    if(path){//目标文件存在
        //创建声音对象
        SystemSoundID theSoundID;
        OSStatus error =AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&theSoundID);
        if(error == kAudioServicesNoError){//创建成功
            _soundID = theSoundID;
        }else{
            DLog(@"Failed to create sound");
        }
    }
    AudioServicesPlayAlertSound(_soundID);
    
}

// 获取wifi名称
- (NSString *)getWifiName
{
    
    NSString *wifiName = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
        }
        DLog(@"wifiName:%@", wifiName);
    }
    return wifiName;
}

//获取当前设备
- (ThermostatDeviceModel *)getCurrentDevice
{
    if (_currentDeviceSerialID ) {
        
        for (ThermostatDeviceModel *deviceObject in self.currentDevices) {
            if (deviceObject.deviceSerialID == _currentDeviceSerialID) {
                return deviceObject;
            }
        }
        return nil;
    }else{
        return nil;
    }
    
}

//获取当前设备
- (ThermostatDeviceModel *)getCurrentDeviceWithSerialID:(long long)serialID
{
    for (ThermostatDeviceModel *deviceObject in self.currentDevices) {
        if (deviceObject.deviceSerialID == serialID) {
            return deviceObject;
        }
    }
    return nil;
}



#pragma mark 设备
//添加设备
- (void)addThermostatDeviceWithName:(NSString *)name andPassword:(NSString *)passWord andSid:(long long)sid
{
    ThermostatDeviceModel *device = [[ThermostatDeviceModel alloc]initWithSerialID:sid andName:name andPassword:passWord];
    device.deviceNetState = DeviceNetStateTypeOn;
    device.deviceState = DeviceStateTypeOn;
    device.deviceTemp = 20;
    device.deviceMode = DeviceModelTypeHot;
    device.ambientTemp = 15;
    device.deviceWindMode = DeviceWindModelTypeLow;
    device.deviceSceneMode = DeviceSceneModelTypeCTemp;
    device.deviceLockMode = DeviceLockModelTypeNo;

    [_db open];
    [_db executeUpdate:@"INSERT INTO device(device_serial_id,device_name,device_password,device_model,device_wind,device_scene,device_lock,device_temp)VALUES(?,?,?,?,?,?,?,?)",@(device.deviceSerialID),device.deviceName,device.devicePassWord,@(device.deviceMode),@(device.deviceWindMode),@(device.deviceSceneMode),@(device.deviceLockMode),@(device.deviceTemp)];
    [_db close];
    
    [self.currentDevices addObject:device];
}


//删除设备
- (void)deleteThermostatDevice:(long long)deviceSerialID
{
    
    [self.currentDevices removeObject:[self getCurrentDeviceWithSerialID:deviceSerialID]];
    [_db open];
    BOOL isSucceed = [_db executeUpdate:@"DELETE FROM device WHERE device_serial_id = ?",@(deviceSerialID)];
    [_db close];
    if (isSucceed) {
        [MBProgressHUD showTextTip:@"设备删除成功"];
    }else{
        [MBProgressHUD showTextTip:@"设备删除失败"];
    }
}
















@end
