//
//  RoundShowView.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Finish)();

@interface RoundShowView : UIView

- (void)showTimeViewWithTime:(NSInteger)time andFinish:(Finish)block;

- (void)removeTimer;

//待机：参数。1环境温度，2环境湿度
- (void)showWaitingView:(float)ctemp andHumidity:(NSUInteger)ambientHumidity;

//展示情景下的View
- (void)showViewWithMode:(DeviceModelType)type andAmbient:(float)ctemp andHumidity:(NSUInteger)ambientHumidity andTemp:(float)temp;

//更新信息
- (void)updateCtemp:(float)ctemp;
- (void)updateHumidity:(NSUInteger)ambientHumidity;
- (void)updateTemp:(float)temp;

@end
