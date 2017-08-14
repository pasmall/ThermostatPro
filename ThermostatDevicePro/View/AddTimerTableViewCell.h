//
//  AddTimerTableViewCell.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/12.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TimerCellType) {
    TimerCellTypeWhite,                 //空白
    TimerCellTypeAngle,                 //普通
    TimerCellTypeWeek,                  //选择周
    TimerCellTypeSwitch,                //开关
};

@protocol AddTimerTableViewCellDelegate <NSObject>

@optional
- (void)settingSwitch:(BOOL)isOn;
- (void)getReWeeks:(WeekType)weekType;

@end


@interface AddTimerTableViewCell : UITableViewCell

@property(nonatomic,weak)id<AddTimerTableViewCellDelegate> delegate;

- (instancetype)initWithType:(TimerCellType )type;
- (void)setTitle:(NSString *)title;
- (void)setWeeks:(WeekType)weekType;
- (void)setSwitch:(BOOL) isOn;
- (void)setCellValue:(NSString *)value;


@end
