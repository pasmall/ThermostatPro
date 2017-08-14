//
//  AddTimerViewController.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/12.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "BaseViewController.h"

@interface AddTimerViewController : BaseViewController

@property(nonatomic,assign)NSInteger viewType;//0.表示开关定时，1表示阶段定时
@property(nonatomic,assign)NSUInteger timerID;//修改定时器信息的时候传入定时器ID

@end
