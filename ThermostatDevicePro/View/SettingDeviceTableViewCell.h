//
//  SettingDeviceTableViewCell.h
//  HotWindPro
//
//  Created by lyric on 2017/3/30.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SettingCellType) {
    SettingCellTypeSound,
    SettingCellTypeShake,
    SettingCellTypeLangue,
};

@class SettingDeviceTableViewCell;

@protocol SettingDeviceTableViewCellDelegate <NSObject>

@optional
//点击开关，或者语言选择
- (void)tapActionWithCell:(SettingDeviceTableViewCell *)cell;

@end

@interface SettingDeviceTableViewCell : UITableViewCell

@property(nonatomic , strong)UISwitch *switchButton;//开关按钮
@property(nonatomic , strong)UIButton *selectedButton;//国家选择按钮

@property (nonatomic ,assign)SettingCellType cellType;
@property(nonatomic , weak)id<SettingDeviceTableViewCellDelegate> delegate;

//设置cell类型和值
- (void)setImageName:(NSString *)imageName andSwitchValue:(BOOL)switchValue;
- (void)setImageName:(NSString *)imageName andLangueType:(LangueType)type;


@end
