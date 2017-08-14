//
//  BaseNavigationControllerViewController.m
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "BaseNavigationControllerViewController.h"


@interface BaseNavigationControllerViewController ()

@end

@implementation BaseNavigationControllerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //navigationBar 的设置
    self.navigationBar.barTintColor = NAVIGATIONBAR_COLOR;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
 
}

//设置StatusBar的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}


@end
