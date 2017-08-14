//
//  Device_m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/6.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "DeviceTimerModel.h"
#import "FMDB.h"


@implementation DeviceTimerModel

- (instancetype)init
{
    if (self = [super init]) {
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"devices.sql"];
        FMDatabase  *_db = [FMDatabase databaseWithPath:filePath];
         [_db open];
        NSString *timerSql = @"CREATE TABLE IF NOT EXISTS 'timer' ('timer_id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'device_serial_id' INTEGER,'timer_begin' INTEGER ,'timer_end' INTEGER,'timer_temp' FLOAT,'timer_model' INTEGER,'timer_wind' INTEGER,'timer_scene' INTEGER,'timer_weeks' VARCHAR(255), 'timer_open' INTEGER , 'timer_type' INTEGER)";
        [_db executeUpdate:timerSql];
        [_db close];
    }
    return self;
}




@end
