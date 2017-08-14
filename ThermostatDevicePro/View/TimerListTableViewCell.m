//
//  TimerListTableViewCell.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/13.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "TimerListTableViewCell.h"
#import "EnumListString.h"

@interface TimerListTableViewCell ()

@property(nonatomic , strong)UIImageView *iconImageView;
@property(nonatomic , strong)UILabel *time1Label;
@property(nonatomic , strong)UILabel *time2Label;
@property(nonatomic , strong)UILabel *zhiLabel;
@property(nonatomic , strong)UILabel *reWeekLabel;
@property(nonatomic , strong)UILabel *stateLabel;
@property(nonatomic , strong)UISwitch *switchButton;
@property(nonatomic , strong)UIView *hLine;

@end


@implementation TimerListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImageView = [[UIImageView alloc]init];
        [self addSubview:_iconImageView];
        
        _time1Label = [[UILabel alloc]init];
        _time1Label.font = [UIFont systemFontOfSize:WIDTH_FIT(54)];
        [self addSubview:_time1Label];
        
        _time2Label = [[UILabel alloc]init];
        _time2Label.font = [UIFont systemFontOfSize:WIDTH_FIT(54)];
        [self addSubview:_time2Label];
        
        _zhiLabel = [[UILabel alloc]init];
        _zhiLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(48)];
        _zhiLabel.textColor = COLOR(136, 136, 136);
        _zhiLabel.text = LANGUE_STRING(@"至");
        [self addSubview:_zhiLabel];
        
        _reWeekLabel = [[UILabel alloc]init];
        _reWeekLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(42)];
        _reWeekLabel.textColor = COLOR(136, 136, 136);
        [self addSubview:_reWeekLabel];
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(42)];
        _stateLabel.textColor = COLOR(136, 136, 136);
        [self addSubview:_stateLabel];
        
        _switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - WIDTH_FIT(48), 0, 51, 31)];
        [_switchButton addTarget:self action:@selector(tapSwitchAction) forControlEvents:UIControlEventTouchUpInside];
        _switchButton.centerY = WIDTH_FIT(120);
        [self addSubview:_switchButton];
        
        _hLine = [[UIView alloc]initWithFrame:CGRectMake(WIDTH_FIT(444), 0, WIDTH_FIT(3), WIDTH_FIT(102))];
        _hLine.backgroundColor = COLOR(203, 203, 203);
        _hLine.centerY = WIDTH_FIT(120);
        [self addSubview:_hLine];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH_FIT(171), WIDTH_FIT(240) - WIDTH_FIT(3), SCREEN_WIDTH - WIDTH_FIT(171), WIDTH_FIT(3))];
        lineView.backgroundColor = COLOR(235, 235, 235);
        [self addSubview:lineView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return self;
}

- (void)tapSwitchAction
{
    if (_timer.timerType == DeviceTimerModelTypeStage) {
        if (_switchButton.on) {
            if ([self judgeTimerClash]) {
                [MBProgressHUD showTextTip:LANGUE_STRING(@"与其他定时器冲突")];
                _switchButton.on = NO;
                return;
            }else{
                [_iconImageView setImage:[UIImage imageNamed:@"阶段定时开启3@"]];
                _time1Label.textColor = [UIColor blackColor];
                _time2Label.textColor = [UIColor blackColor];
            }
            
        }else{
            [_iconImageView setImage:[UIImage imageNamed:@"阶段定时关闭3@"]];
            _time1Label.textColor = COLOR(137, 137, 137);
            _time2Label.textColor = COLOR(137, 137, 137);
        }
    }else{
        if (_switchButton.on) {
            if ([self judgeTimerClash]) {
                [MBProgressHUD showTextTip:LANGUE_STRING(@"与其他定时器冲突")];
                _switchButton.on = NO;
                return;
            }else{
                [_iconImageView setImage:[UIImage imageNamed:@"定时开启3@"]];
                _time1Label.textColor = [UIColor blackColor];
            }
            
        }else{
            [_iconImageView setImage:[UIImage imageNamed:@"定时关闭3@"]];
            _time1Label.textColor = COLOR(137, 137, 137);
        }
    }

    _timer.timerIsOpen = _switchButton.on;
    
    
    //TODO 更新数据库信息
    ThermostatDeviceModel *currentDevice = [[AppDataManager sharedAppDataManager] getCurrentDevice];
    [currentDevice updateDeviceTimer:_timer];

}

//判断定时器开启的时候是否冲突
- (BOOL)judgeTimerClash
{
    ThermostatDeviceModel  *currentDevice = [[AppDataManager sharedAppDataManager]getCurrentDevice];

    //判断定时器是否有冲突
    __block BOOL isClash = NO;
    
    for (DeviceTimerModel *object in currentDevice.currentTimers) {
        //修改定时器避免冲突
        if (object.timerID == _timer.timerID) {
            continue;
        }
        //去掉关闭的定时器
        if (!object.timerIsOpen) {
            continue;
        }
        
        BOOL changeWeekValue = NO;
        if (_timer.repeatWeeks&WeekTypeNull) {
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:nowDate];
            _timer.repeatWeeks = 1 << ([comp weekday] - 1);
            changeWeekValue = YES;
        }
        BOOL changeObjectValue = NO;
        if (object.repeatWeeks&WeekTypeNull) {
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:nowDate];
            object.repeatWeeks = 1 << ([comp weekday] - 1);
            changeObjectValue = YES;
        }
        
        if (_timer.repeatWeeks&WeekTypeMon && object.repeatWeeks&WeekTypeMon) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timer.repeatWeeks&WeekTypeTue && object.repeatWeeks&WeekTypeTue) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timer.repeatWeeks&WeekTypeWed && object.repeatWeeks&WeekTypeWed) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timer.repeatWeeks&WeekTypeThu && object.repeatWeeks&WeekTypeThu) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timer.repeatWeeks&WeekTypeFir && object.repeatWeeks&WeekTypeFir) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timer.repeatWeeks&WeekTypeSat && object.repeatWeeks&WeekTypeSat) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timer.repeatWeeks&WeekTypeSun && object.repeatWeeks&WeekTypeSun) {
            isClash = [self isTimeClashWithBeginTime:_timer.beginTime andEndTime:_timer.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }
        
        if (changeWeekValue) {
            _timer.repeatWeeks = WeekTypeNull;
        }
        
        if (changeObjectValue) {
            object.repeatWeeks = WeekTypeNull;
        }
        
        if (isClash) {
            break;
        }
        
    }
    
    

    return isClash;
    
}

- (BOOL)isTimeClashWithBeginTime:(NSUInteger)nowFrom andEndTime:(NSUInteger)nowTo andCompareTime:(NSUInteger)compareFrom andCompareEndTime:(NSUInteger)compareTo
{
    
    if ( (nowFrom <= compareFrom) && nowTo > compareFrom) {
        return YES;
    }else if ((nowFrom >= compareFrom) && nowFrom <= compareTo){
        return YES;
    }else{
        return NO;
    }
    
}

- (void)setTimer:(DeviceTimerModel *)timer
{
    _timer = timer;
    
    //定时器状态
    switch (timer.timerType) {
        case DeviceTimerModelTypeOff:
            [self updateTimerModelOffUIWithTimer:timer];
            break;
        case DeviceTimerModelTypeOn:
            [self updateTimerModelOnUIWithTimer:timer];
            break;
        case DeviceTimerModelTypeStage:
            [self updateTimerModelStageUIWithTimer:timer];
            break;
            
        default:
            break;
    }
    
}

- (void)updateTimerModelOffUIWithTimer:(DeviceTimerModel *)timer
{
    _stateLabel.text = LANGUE_STRING(@"关");
    if (timer.timerIsOpen) {
        [_iconImageView setImage:[UIImage imageNamed:@"定时开启3@"]];
        _time1Label.textColor = [UIColor blackColor];
    }else{
        [_iconImageView setImage:[UIImage imageNamed:@"定时关闭3@"]];
        _time1Label.textColor = COLOR(137, 137, 137);
    }
    
    if (timer.repeatWeeks > 1) {
        _reWeekLabel.hidden = NO;
        if ([AppDataManager sharedAppDataManager].currentLangueType == LangueTypeChinese) {
                NSString *startStr = [self getOneWeekString:timer.repeatWeeks];
                NSString *endStr = [[self getWeeksString:timer.repeatWeeks] substringFromIndex:2];
                _reWeekLabel.text = [NSString stringWithFormat:@"%@%@",startStr,endStr];
        }else{
            _reWeekLabel.text = [self getEnglishWeekString:timer.repeatWeeks];
        }
        
        _reWeekLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _reWeekLabel.x = CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30);
        _reWeekLabel.height = [_stateLabel.text heightForFont:_stateLabel.font width:_stateLabel.width];
        
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.x = CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30);
        _stateLabel.height = [_stateLabel.text heightForFont:_stateLabel.font width:_stateLabel.width];
        
        CGFloat y = WIDTH_FIT(120) - _stateLabel.height - 5;
        _reWeekLabel.y = y;
        _stateLabel.y = CGRectGetMaxY(_reWeekLabel.frame) + 5;
        
    }else{
        _reWeekLabel.hidden = YES;
        _stateLabel.frame = CGRectMake(CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30), 0,0, 21);
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.centerY = WIDTH_FIT(120);
    }
    
    
    if (timer.repeatWeeks&1<<8) {
        _reWeekLabel.text = LANGUE_STRING(@"每日");
    }
    
    if (timer.repeatWeeks&1<<0) {
        _reWeekLabel.hidden = YES;
        _stateLabel.frame = CGRectMake(CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30), 0,0, 21);
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.centerY = WIDTH_FIT(120);
    }
    
    _time1Label.text = [NSString getTimeStringWithTimeSecond:timer.beginTime];
    _time2Label.hidden = YES;
    _zhiLabel.hidden = YES;
    _switchButton.on = timer.timerIsOpen;
    
    //更新控件位置
    _iconImageView.frame = CGRectMake(WIDTH_FIT(42), 0, WIDTH_FIT(72), WIDTH_FIT(72));
    _iconImageView.centerY = WIDTH_FIT(120);
    CGFloat time1Width = [_time1Label.text widthForFont:_time1Label.font];
    _time1Label.frame = CGRectMake(WIDTH_FIT(171), 0, time1Width + 3, 21);
    _time1Label.centerY = WIDTH_FIT(120);
}
- (void)updateTimerModelOnUIWithTimer:(DeviceTimerModel *)timer
{
    if (timer.timerIsOpen) {
        [_iconImageView setImage:[UIImage imageNamed:@"定时开启3@"]];
        _time1Label.textColor = [UIColor blackColor];
    }else{
        [_iconImageView setImage:[UIImage imageNamed:@"定时关闭3@"]];
        _time1Label.textColor = COLOR(137, 137, 137);
    }

    _time1Label.text = [NSString getTimeStringWithTimeSecond:timer.beginTime];
    _time2Label.hidden = YES;
    _zhiLabel.hidden = YES;
    _switchButton.on = timer.timerIsOpen;
    
    NSString *tempStr = [NSString stringWithFormat:@"%.1f℃",timer.deviceTemp];
    NSString *windStr = [EnumListString getStringWithDeviceWindModelType:timer.deviceWindMode];
    NSString *modeStr = [EnumListString getStringWithDeviceModelType:timer.deviceMode];
    NSString *sceneStr = [EnumListString getStringWithDeviceSceneModelType:timer.deviceSceneMode];
    
    if (timer.deviceMode == DeviceModelTypeChangeAir) {
        _stateLabel.text = [NSString stringWithFormat:@"%@  %@  %@",windStr,modeStr,sceneStr];
    }else{
        _stateLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",tempStr,windStr,modeStr,sceneStr];
    }
    
    
    if (timer.repeatWeeks > 1) {
        _reWeekLabel.hidden = NO;
        if ([AppDataManager sharedAppDataManager].currentLangueType == LangueTypeChinese) {
            NSString *startStr = [self getOneWeekString:timer.repeatWeeks];
            NSString *endStr = [[self getWeeksString:timer.repeatWeeks] substringFromIndex:2];
            _reWeekLabel.text = [NSString stringWithFormat:@"%@%@",startStr,endStr];
        }else{
            _reWeekLabel.text = [self getEnglishWeekString:timer.repeatWeeks];
        }
        
        _reWeekLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _reWeekLabel.x = CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30);
        _reWeekLabel.height = [_stateLabel.text heightForFont:_stateLabel.font width:_stateLabel.width];
        
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.x = CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30);
        _stateLabel.height = [_stateLabel.text heightForFont:_stateLabel.font width:_stateLabel.width];
        
        CGFloat y = WIDTH_FIT(120) - _stateLabel.height - 5;
        _reWeekLabel.y = y;
        _stateLabel.y = CGRectGetMaxY(_reWeekLabel.frame) + 5;
        
    }else{
        _reWeekLabel.hidden = YES;
        _stateLabel.frame = CGRectMake(CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30), 0,0, 21);
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.centerY = WIDTH_FIT(120);
    }
    
    if (timer.repeatWeeks&1<<8) {
        _reWeekLabel.text = LANGUE_STRING(@"每日");
    }
    
    if (timer.repeatWeeks&1<<0) {
        _reWeekLabel.hidden = YES;
        _stateLabel.frame = CGRectMake(CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30), 0,0, 21);
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.centerY = WIDTH_FIT(120);
    }
    
    //更新控件位置
    _iconImageView.frame = CGRectMake(WIDTH_FIT(42), 0, WIDTH_FIT(72), WIDTH_FIT(72));
    _iconImageView.centerY = WIDTH_FIT(120);
    CGFloat time1Width = [_time1Label.text widthForFont:_time1Label.font];
    _time1Label.frame = CGRectMake(WIDTH_FIT(171), 0, time1Width + 3, 21);
    _time1Label.centerY = WIDTH_FIT(120);
}

- (void)updateTimerModelStageUIWithTimer:(DeviceTimerModel *)timer
{
    if (timer.timerIsOpen) {
        [_iconImageView setImage:[UIImage imageNamed:@"阶段定时开启3@"]];
        _time1Label.textColor = [UIColor blackColor];
        _time2Label.textColor = [UIColor blackColor];
    }else{
        [_iconImageView setImage:[UIImage imageNamed:@"阶段定时关闭3@"]];
        _time1Label.textColor = COLOR(137, 137, 137);
        _time2Label.textColor = COLOR(137, 137, 137);
    }
    
    _time1Label.text = [NSString getTimeStringWithTimeSecond:timer.beginTime];
    _time2Label.text = [NSString getTimeStringWithTimeSecond:timer.endTime];
    _switchButton.on = timer.timerIsOpen;
    
    NSString *tempStr = [NSString stringWithFormat:@"%.1f℃",timer.deviceTemp];
    NSString *windStr = [EnumListString getStringWithDeviceWindModelType:timer.deviceWindMode];
    NSString *modeStr = [EnumListString getStringWithDeviceModelType:timer.deviceMode];
    NSString *sceneStr = [EnumListString getStringWithDeviceSceneModelType:timer.deviceSceneMode];
    if (timer.deviceMode == DeviceModelTypeChangeAir) {
        _stateLabel.text = [NSString stringWithFormat:@"%@  %@  %@",windStr,modeStr,sceneStr];
    }else{
        _stateLabel.text = [NSString stringWithFormat:@"%@  %@  %@  %@",tempStr,windStr,modeStr,sceneStr];
    }
    
    if (timer.repeatWeeks > 1) {
        _reWeekLabel.hidden = NO;
        if ([AppDataManager sharedAppDataManager].currentLangueType == LangueTypeChinese) {
            NSString *startStr = [self getOneWeekString:timer.repeatWeeks];
            NSString *endStr = [[self getWeeksString:timer.repeatWeeks] substringFromIndex:2];
            _reWeekLabel.text = [NSString stringWithFormat:@"%@%@",startStr,endStr];
        }else{
            _reWeekLabel.text = [self getEnglishWeekString:timer.repeatWeeks];
        }
        
        _reWeekLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _reWeekLabel.x = CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30);
        _reWeekLabel.height = [_stateLabel.text heightForFont:_stateLabel.font width:_stateLabel.width];
        
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.x = CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30);
        _stateLabel.height = [_stateLabel.text heightForFont:_stateLabel.font width:_stateLabel.width];
        
        CGFloat y = WIDTH_FIT(120) - _stateLabel.height - 5;
        _reWeekLabel.y = y;
        _stateLabel.y = WIDTH_FIT(120) + 5;
        
    }else{
        _reWeekLabel.hidden = YES;
        _stateLabel.frame = CGRectMake(CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30), 0,0, 21);
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.centerY = WIDTH_FIT(120);
    }
    
    if (timer.repeatWeeks&1<<8) {
        _reWeekLabel.text = LANGUE_STRING(@"每日");
    }
    
    if (timer.repeatWeeks&1<<0) {
        _reWeekLabel.hidden = YES;
        _stateLabel.frame = CGRectMake(CGRectGetMaxX(_hLine.frame) + WIDTH_FIT(30), 0,0, 21);
        _stateLabel.width = SCREEN_WIDTH - _stateLabel.x - _switchButton.width;
        _stateLabel.centerY = WIDTH_FIT(120);
    }
    
    
    //更新控件位置
    _iconImageView.frame = CGRectMake(WIDTH_FIT(42), 0, WIDTH_FIT(72), WIDTH_FIT(72));
    _iconImageView.centerY = WIDTH_FIT(120);
    CGFloat time1Width = [@"23:59" widthForFont:_time1Label.font];
    CGFloat height = [_time1Label.text heightForFont:_time1Label.font width:time1Width];
    _time1Label.frame = CGRectMake(WIDTH_FIT(171), 0, time1Width + 3, height);
    _time1Label.y = WIDTH_FIT(120) - height - 5;
    
    _time2Label.frame = CGRectMake(WIDTH_FIT(171), 0, time1Width + 3, height);
    _time2Label.y = WIDTH_FIT(120) + 5;
    
    _zhiLabel.frame = CGRectMake(0, 0, [_zhiLabel.text widthForFont:_zhiLabel.font], 21);
    _zhiLabel.x = _hLine.x - WIDTH_FIT(45) -_zhiLabel.width;
    _zhiLabel.centerY = WIDTH_FIT(120);
    _zhiLabel.hidden = NO;
    _time2Label.hidden = NO;
    
}


#pragma mark Tool

- (NSString *)getWeeksString:(WeekType)type
{
    NSMutableString *weeks = [NSMutableString string];
    if (type&1<<0) {
        return @"";
    }
    if (type&1<<1) {
        [weeks appendString:LANGUE_STRING(@"、一")];
    }
    if (type&1<<2) {
        [weeks appendString:LANGUE_STRING(@"、二")];
    }
    if (type&1<<3) {
        [weeks appendString:LANGUE_STRING(@"、三")];
    }
    if (type&1<<4) {
        [weeks appendString:LANGUE_STRING(@"、四")];
    }
    if (type&1<<5) {
        [weeks appendString:LANGUE_STRING(@"、五")];
    }
    if (type&1<<6) {
        [weeks appendString:LANGUE_STRING(@"、六")];
    }
    if (type&1<<7) {
        [weeks appendString:LANGUE_STRING(@"、日")];
    }
    return [weeks copy];
}

- (NSString *)getOneWeekString:(WeekType)type
{
    NSMutableString *weeks = [NSMutableString stringWithString:LANGUE_STRING(@"周")];
    if (type&1<<0) {
        return @"";
    }
    if (type&1<<1) {
        [weeks appendString:LANGUE_STRING(@"一")];
        return [weeks copy];
    }
    if (type&1<<2) {
        [weeks appendString:LANGUE_STRING(@"二")];
        return [weeks copy];
    }
    if (type&1<<3) {
        [weeks appendString:LANGUE_STRING(@"三")];
        return [weeks copy];
    }
    if (type&1<<4) {
        [weeks appendString:LANGUE_STRING(@"四")];
        return [weeks copy];
    }
    if (type&1<<5) {
        [weeks appendString:LANGUE_STRING(@"五")];
        return [weeks copy];
    }
    if (type&1<<6) {
        [weeks appendString:LANGUE_STRING(@"六")];
        return [weeks copy];
    }
    if (type&1<<7) {
        [weeks appendString:LANGUE_STRING(@"日")];
        return [weeks copy];
    }
    
    return [weeks copy];
}

- (NSString *)getEnglishWeekString:(WeekType)type
{
    NSMutableString *weeks = [NSMutableString string];
    if (type&1<<0) {
        return @"";
    }
    if (type&1<<1) {
        [weeks appendString:LANGUE_STRING(@"一")];
        [weeks appendString:@" "];
    }
    if (type&1<<2) {
        [weeks appendString:LANGUE_STRING(@"二")];
        [weeks appendString:@" "];
    }
    if (type&1<<3) {
        [weeks appendString:LANGUE_STRING(@"三")];
        [weeks appendString:@" "];
    }
    if (type&1<<4) {
        [weeks appendString:LANGUE_STRING(@"四")];
        [weeks appendString:@" "];
    }
    if (type&1<<5) {
        [weeks appendString:LANGUE_STRING(@"五")];
        [weeks appendString:@" "];
    }
    if (type&1<<6) {
        [weeks appendString:LANGUE_STRING(@"六")];
        [weeks appendString:@" "];
    }
    if (type&1<<7) {
        [weeks appendString:LANGUE_STRING(@"日")];
        [weeks appendString:@" "];
    }
    
    return [weeks copy];
}





@end
