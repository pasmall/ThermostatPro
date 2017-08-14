//
//  DeviceTableViewCell.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/7.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThermostatDeviceModel;

@protocol DeviceTableViewCellDelegate <NSObject>

@optional
//点击编辑按钮
- (void)tapEditButtonWithDeviceModel:(ThermostatDeviceModel *)device;

@end


@interface DeviceTableViewCell : UITableViewCell

@property(nonatomic , strong)ThermostatDeviceModel *thermostatModel;
@property(nonatomic , weak)id<DeviceTableViewCellDelegate> delegate;
    
@end
