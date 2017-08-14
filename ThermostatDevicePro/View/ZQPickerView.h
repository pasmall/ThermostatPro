//
//  ZQPickerView.h
//  ThermostatDevicePro
//
//  Created by 聂自强 on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//
//横向的选择器

#import <UIKit/UIKit.h>

@protocol ZQPickerViewDelegate <NSObject>

@optional
- (void)didSelectValue:(float)value;

@end


@interface ZQPickerView : UIView

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,assign) float scrollItem;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,weak) id<ZQPickerViewDelegate> delegate;


@end
