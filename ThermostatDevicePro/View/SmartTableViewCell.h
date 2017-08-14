//
//  SmartTableViewCell.h
//  ThermostatDevicePro
//
//  Created by 聂自强 on 2017/6/11.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmartTableViewCell : UITableViewCell

- (void)setTitle:(NSString *)title andImageName:(NSString *)imgName andSwitch:(BOOL)isOn andInfoText:(NSString *)info andType:(NSInteger)type;


@end
