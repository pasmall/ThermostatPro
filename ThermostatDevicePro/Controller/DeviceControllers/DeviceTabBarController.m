//
//  DeviceTabBarController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "DeviceTabBarController.h"
#import "DeviceOperationViewController.h"
#import "SmartSettingViewController.h"
#import "DeviceNavigationController.h"

@interface DeviceTabBarController ()

@end

@implementation DeviceTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //tabarViewController 设置
    self.tabBar.tintColor = NAVIGATIONBAR_COLOR;
    [self addChildViewController:[DeviceOperationViewController new] andImageName:@"遥控面板@3x" andTitle:LANGUE_STRING(@"控制面板")];
    [self addChildViewController:[SmartSettingViewController new] andImageName:@"智能设置@3x" andTitle:LANGUE_STRING(@"智能设置") ];
}

//tabarViewController添加控制器
- (void)addChildViewController:(UIViewController *)childController andImageName:(NSString  *)name andTitle:(NSString *)title
{
    
    childController.tabBarItem.image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    childController.tabBarItem.title = title;
    
    [self addChildViewController:[[DeviceNavigationController alloc]initWithRootViewController:childController]];
}

@end
