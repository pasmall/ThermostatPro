//
//  AddTimerViewController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/12.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "AddTimerViewController.h"
#import "AddTimerTableViewCell.h"
#import "EnumPickerView.h"
#import "EnumListString.h"

#define FIVE_CELLS 5
#define TEN_CELLS 10
#define NIGHT_CELLS 9
#define EIGHT_CELLS 8


@interface AddTimerViewController ()<UITableViewDelegate , UITableViewDataSource ,AddTimerTableViewCellDelegate>{

    NSArray *dataArr;
    DeviceTimerModel *_timerObject;
}

@property(nonatomic,strong)UITableView *selectTableView;

@end

@implementation AddTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    [self setUI];
}

- (void)getData
{
    ThermostatDeviceModel *device = [[AppDataManager sharedAppDataManager] getCurrentDevice];
    if (_timerID == 0) {
        //初始化一个timer
        
        //时间格式化
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        NSDate *currentDate = [NSDate date];
        NSString *currentDateString = [formatter stringFromDate:currentDate];
        NSDate *endDate = [NSDate dateWithTimeInterval:1800 sinceDate:currentDate];
        NSString *endDateSting = [formatter stringFromDate:endDate];
        
        _timerObject = [[DeviceTimerModel alloc]init];
        _timerObject.deviceSerialID = device.deviceSerialID;
        _timerObject.beginTime =[NSString getTimeIntWithTimeString:currentDateString];
        _timerObject.deviceTemp = device.deviceTemp;
        _timerObject.deviceMode = device.deviceMode;
        _timerObject.deviceWindMode = device.deviceWindMode;
        _timerObject.deviceSceneMode = device.deviceSceneMode;
        _timerObject.timerIsOpen = YES;
        _timerObject.repeatWeeks = WeekTypeNull;
        if (_viewType == 0) {
            _timerObject.endTime = [NSString getTimeIntWithTimeString:currentDateString];
            _timerObject.timerType = DeviceTimerModelTypeOff;
        }else{
            _timerObject.endTime = [NSString getTimeIntWithTimeString:endDateSting];
            _timerObject.timerType = DeviceTimerModelTypeStage;
        }
        
        
    }else{
        
        DeviceTimerModel *currentTimer = [device getDeviceTimerWithID:_timerID];
        _timerObject = [[DeviceTimerModel alloc]init];
        _timerObject.deviceSerialID = device.deviceSerialID;
        _timerObject.beginTime = currentTimer.beginTime;
        _timerObject.endTime = currentTimer.endTime;
        _timerObject.deviceTemp = currentTimer.deviceTemp;
        _timerObject.deviceMode = currentTimer.deviceMode;
        _timerObject.deviceWindMode = currentTimer.deviceWindMode;
        _timerObject.deviceSceneMode = currentTimer.deviceSceneMode;
        _timerObject.timerIsOpen = currentTimer.timerIsOpen;
        _timerObject.repeatWeeks = currentTimer.repeatWeeks;
        _timerObject.timerID = currentTimer.timerID;
    }
    
    [self judgeCellCountsWithMode:_timerObject.deviceMode];


}

- (void)setUI
{
    //导航栏设置
    if (_viewType) {
        self.navigationItem.title = LANGUE_STRING(@"阶段定时器设置");
    }else{
        self.navigationItem.title = LANGUE_STRING(@"开关定时器设置");
    }
  
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(132),  PX_TO_PT(132))];
    [rightButton setTitle:LANGUE_STRING(@"保存") forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, PX_TO_PT(24), 0, 0);
    [rightButton addTarget:self action:@selector(tapRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //创建设备tableView
    self.selectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    self.selectTableView.showsVerticalScrollIndicator = NO;
    self.selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.selectTableView];
    
    //不自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;

}


#pragma mark Action
- (void)tapRightAction
{
    ThermostatDeviceModel  *currentDevice = [[AppDataManager sharedAppDataManager]getCurrentDevice];
    //判断开始和结束时间的合理性
    if (_timerObject.beginTime > _timerObject.endTime) {
        [MBProgressHUD showTextTip:LANGUE_STRING(@"开始时间应小于结束时间")];
        return;
    }
    
    //判断定时器是否有冲突
    __block BOOL isClash = NO;
    
    for (DeviceTimerModel *object in currentDevice.currentTimers) {
        //修改定时器避免冲突
        if (object.timerID == _timerObject.timerID) {
            continue;
        }
        //去掉关闭的定时器
        if (!object.timerIsOpen) {
            continue;
        }
        
        BOOL changeWeekValue = NO;
        if (_timerObject.repeatWeeks&WeekTypeNull) {
            NSDate *nowDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comp = [calendar components:NSCalendarUnitWeekday fromDate:nowDate];
            _timerObject.repeatWeeks = 1 << ([comp weekday] - 1);
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

        if (_timerObject.repeatWeeks&WeekTypeMon && object.repeatWeeks&WeekTypeMon) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timerObject.repeatWeeks&WeekTypeTue && object.repeatWeeks&WeekTypeTue) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timerObject.repeatWeeks&WeekTypeWed && object.repeatWeeks&WeekTypeWed) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timerObject.repeatWeeks&WeekTypeThu && object.repeatWeeks&WeekTypeThu) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timerObject.repeatWeeks&WeekTypeFir && object.repeatWeeks&WeekTypeFir) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timerObject.repeatWeeks&WeekTypeSat && object.repeatWeeks&WeekTypeSat) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }else if (_timerObject.repeatWeeks&WeekTypeSun && object.repeatWeeks&WeekTypeSun) {
            isClash = [self isTimeClashWithBeginTime:_timerObject.beginTime andEndTime:_timerObject.endTime andCompareTime:object.beginTime andCompareEndTime:object.endTime];
        }
        
        if (changeWeekValue) {
            _timerObject.repeatWeeks = WeekTypeNull;
        }
        
        if (changeObjectValue) {
            object.repeatWeeks = WeekTypeNull;
        }
        
        if (isClash) {
            break;
        }
    
    }

    
    if (isClash) {
        [MBProgressHUD showTextTip:LANGUE_STRING(@"与其他定时器冲突")];
        return;
    }
    
    
    if (_timerObject.timerID != 0) {
        [currentDevice updateDeviceTimer:_timerObject];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [currentDevice addDeviceTimer:_timerObject];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [MBProgressHUD showTextTip:LANGUE_STRING(@"保存成功")];
    
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

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [self showTableView:tableView andIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_viewType == 0) {
        if (indexPath.row == 0 || indexPath.row == 3|| indexPath.row == 5 ) {
            return PX_TO_PT(108);
        }else if (indexPath.row == 2){
            return PX_TO_PT(264);
        }else{
            return PX_TO_PT(132);
        }
    }else{
        if (indexPath.row == 0 || indexPath.row == 4 ) {
            return PX_TO_PT(108);
        }else if (indexPath.row == 3){
            return PX_TO_PT(264);
        }else{
            return PX_TO_PT(132);
        }
    
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self didActionWithTableView:tableView andIndexPath:indexPath];

}

#pragma mark AddTimerTableViewCellDelegate
- (void)settingSwitch:(BOOL)isOn
{
    _timerObject.timerType = isOn;
    
    if (isOn) {
        if (_timerObject.deviceMode == DeviceModelTypeChangeAir){
            dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关"),@"",LANGUE_STRING(@"风速"),LANGUE_STRING(@"模式"),LANGUE_STRING(@"情景")];
        }else{
            dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关"),@"",LANGUE_STRING(@"温度"),LANGUE_STRING(@"风速"),LANGUE_STRING(@"模式"),LANGUE_STRING(@"情景")];
        }
   
    }else{
        dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关")];
    }
    [self.selectTableView reloadData];
}

- (void)getReWeeks:(WeekType)weekType
{
    if (weekType > 1) {
        weekType &= ~WeekTypeNull;
    }else{
        weekType = WeekTypeNull;
    }
    
    _timerObject.repeatWeeks = weekType;
}

#pragma mark UI呈现
- (UITableViewCell *)showTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = dataArr[indexPath.row];
    if ([title isEqualToString:@""]) {
        return [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeWhite];
    }else if ([title isEqualToString:LANGUE_STRING(@"时间")] || [title isEqualToString:LANGUE_STRING(@"开始时间")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeAngle];
        [cell setTitle:title];
        [cell setCellValue:[NSString getTimeStringWithTimeSecond:_timerObject.beginTime]];
        return cell;
    }else if ([title isEqualToString:LANGUE_STRING(@"重复")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeWeek];
        [cell setWeeks:_timerObject.repeatWeeks];
        [cell setTitle:title];
        cell.delegate = self ;
        return cell;
    
    }else if ([title isEqualToString:LANGUE_STRING(@"开关")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeSwitch];
        cell.delegate = self;
        [cell setTitle:title];
        [cell setSwitch:_timerObject.timerType];
        return cell;
    }else if ([title isEqualToString:LANGUE_STRING(@"温度")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeAngle];
        NSString *tempStr = [NSString stringWithFormat:@"%.1f℃",_timerObject.deviceTemp];
        [cell setTitle:title];
        [cell setCellValue:tempStr];
        return cell;
    }else if ([title isEqualToString:LANGUE_STRING(@"风速")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeAngle];
        cell.delegate = self;
        [cell setTitle:title];
        [cell setCellValue:[EnumListString getStringWithDeviceWindModelType:_timerObject.deviceWindMode]];
        return cell;
    }else if ([title isEqualToString:LANGUE_STRING(@"模式")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeAngle];
        cell.delegate = self;
        [cell setTitle:title];
        [cell setCellValue:[EnumListString getStringWithDeviceModelType:_timerObject.deviceMode]];
        return cell;
    }else if ([title isEqualToString:LANGUE_STRING(@"情景")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeAngle];
        cell.delegate = self;
        [cell setTitle:title];
        [cell setCellValue:[EnumListString getStringWithDeviceSceneModelType:_timerObject.deviceSceneMode]];
        return cell;
    }else if ([title isEqualToString:LANGUE_STRING(@"结束时间")]){
        AddTimerTableViewCell *cell = [[AddTimerTableViewCell alloc]initWithType:TimerCellTypeAngle];
        [cell setTitle:title];
        [cell setCellValue:[NSString getTimeStringWithTimeSecond:_timerObject.endTime]];
        return cell;
    }
    return [UITableViewCell new];
}


#pragma mark 事件处理
- (void)didActionWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *title = dataArr[indexPath.row];
    if ([title isEqualToString:LANGUE_STRING(@"时间")] || [title isEqualToString:LANGUE_STRING(@"开始时间")] || [title isEqualToString:LANGUE_STRING(@"结束时间")]){
        NSMutableArray *hours = [NSMutableArray array];
        NSMutableArray *seconds = [NSMutableArray array];
        for (int i = 0; i < 24; i ++) {
            NSString *hour = [NSString stringWithFormat:@"%2d",i];
            [hours addObject:hour];
        }
        for (int i = 0; i < 60; i ++) {
            NSString *second = [NSString stringWithFormat:@"%2d",i];
            [seconds addObject:second];
        }
        NSArray *dataArray = @[hours,seconds];
        NSArray *subObjectArr;
        if ([title isEqualToString:LANGUE_STRING(@"结束时间")]) {
            subObjectArr = [[NSString getTimeStringWithTimeSecond:_timerObject.endTime] componentsSeparatedByString:@":"];
        }else{
            subObjectArr = [[NSString getTimeStringWithTimeSecond:_timerObject.beginTime] componentsSeparatedByString:@":"];
        }
        NSInteger row0 = [subObjectArr[0] integerValue];
        NSInteger row1 = [subObjectArr[1] integerValue];
        @WeakObject(tableView);
        EnumPickerView *picker = [EnumPickerView sheetStringPickerWithTitleStrings:dataArray andHeaderTitle:LANGUE_STRING(@"时间") andSubObjectCom:row0 andSubObjectRow:row1 andPickerType:PickerViewTypeAngle andcall:^(NSInteger com, NSInteger row) {

            if ([title isEqualToString:LANGUE_STRING(@"结束时间")]) {
                NSString *timeStr = [NSString stringWithFormat:@"%ld:%ld",com,row];
                _timerObject.endTime = [NSString getTimeIntWithTimeString:timeStr];
            }else{
                NSString *timeStr = [NSString stringWithFormat:@"%ld:%ld",com,row];
                _timerObject.beginTime = [NSString getTimeIntWithTimeString:timeStr];
                if (_timerObject.timerType != DeviceTimerModelTypeStage) {
                    _timerObject.endTime = [NSString getTimeIntWithTimeString:timeStr];
                }else{
                    _timerObject.endTime = _timerObject.endTime;
                }
            }
            
            
            
            [tableViewWeak reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [picker showPicker];

    }else if ([title isEqualToString:LANGUE_STRING(@"温度")]){
        NSMutableArray *titles = [NSMutableArray array];
        float idx = 5;
        while (idx <= 35) {
            NSString *value = [NSString stringWithFormat:@"%.1f℃",idx];
            [titles addObject:value];
            idx += 0.5;
        }
        NSString *subObject = [NSString stringWithFormat:@"%.1f℃",_timerObject.deviceTemp];
        __block NSInteger index = 0;
        [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([subObject isEqualToString:obj]) {
                index = idx;
            }
        }];
        
        @WeakObject(tableView);
        EnumPickerView *picker = [EnumPickerView sheetStringPickerWithTitleStrings:@[titles] andHeaderTitle:LANGUE_STRING(@"温度") andSubObjectCom:index andSubObjectRow:index andPickerType:PickerViewTypeAngle andcall:^(NSInteger com, NSInteger row) {
            NSString *tempStr = titles[com];
            _timerObject.deviceTemp = [[tempStr substringToIndex:tempStr.length - 1] floatValue];
            [tableViewWeak reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }];
        [picker showPicker];

    }else if ([title isEqualToString:LANGUE_STRING(@"风速")]){
        NSArray *titles = @[@[LANGUE_STRING(@"低风"),LANGUE_STRING(@"中风"),LANGUE_STRING(@"高风")]];
        @WeakObject(tableView);
        EnumPickerView *picker = [EnumPickerView sheetStringPickerWithTitleStrings:titles andHeaderTitle:LANGUE_STRING(@"风速") andSubObjectCom:_timerObject.deviceWindMode andSubObjectRow:0 andPickerType:PickerViewTypeAngle andcall:^(NSInteger com, NSInteger row) {
            _timerObject.deviceWindMode = com;
            [tableViewWeak reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [picker showPicker];
    }else if ([title isEqualToString:LANGUE_STRING(@"模式")]){
        NSArray *titles = @[@[LANGUE_STRING(@"制热"),LANGUE_STRING(@"制冷"),LANGUE_STRING(@"换气")]];
        @WeakObject(tableView);
        
        EnumPickerView *picker = [EnumPickerView sheetStringPickerWithTitleStrings:titles andHeaderTitle:LANGUE_STRING(@"模式") andSubObjectCom:_timerObject.deviceMode andSubObjectRow:0 andPickerType:PickerViewTypeAngle andcall:^(NSInteger com, NSInteger row) {
            _timerObject.deviceMode = com;
            [self judgeCellCountsWithMode:_timerObject.deviceMode];
            [tableViewWeak reloadData];
        }];
        [picker showPicker];
    }else if ([title isEqualToString:LANGUE_STRING(@"情景")]){
        NSArray *titles = @[@[LANGUE_STRING(@"恒温"),LANGUE_STRING(@"节能"),LANGUE_STRING(@"离家")]];
        @WeakObject(tableView);
        EnumPickerView *picker = [EnumPickerView sheetStringPickerWithTitleStrings:titles andHeaderTitle:LANGUE_STRING(@"情景") andSubObjectCom:_timerObject.deviceSceneMode andSubObjectRow:0 andPickerType:PickerViewTypeAngle andcall:^(NSInteger com, NSInteger row) {
            _timerObject.deviceSceneMode = com;
            [tableViewWeak reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
        [picker showPicker];
    }

}

- (void)judgeCellCountsWithMode:(NSInteger)mode
{
    if (mode == DeviceModelTypeChangeAir) {
        if (_viewType == 0) {
            if (_timerObject.timerType == DeviceTimerModelTypeOn) {
                dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关"),@"",LANGUE_STRING(@"风速"),LANGUE_STRING(@"模式"),LANGUE_STRING(@"情景")];
            }else{
                dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关")];
            }
        }else{
            dataArr = @[@"",LANGUE_STRING(@"开始时间"),LANGUE_STRING(@"结束时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"风速"),LANGUE_STRING(@"模式"),LANGUE_STRING(@"情景")];
        }
        
    }else{
        if (_viewType == 0) {
            if (_timerObject.timerType == DeviceTimerModelTypeOn) {
                dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关"),@"",LANGUE_STRING(@"温度"),LANGUE_STRING(@"风速"),LANGUE_STRING(@"模式"),LANGUE_STRING(@"情景")];
            }else{
                dataArr = @[@"",LANGUE_STRING(@"时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"开关")];
            }
        }else{
            dataArr = @[@"",LANGUE_STRING(@"开始时间"),LANGUE_STRING(@"结束时间"),LANGUE_STRING(@"重复"),@"",LANGUE_STRING(@"温度"),LANGUE_STRING(@"风速"),LANGUE_STRING(@"模式"),LANGUE_STRING(@"情景")];
        }
    }

}



@end
