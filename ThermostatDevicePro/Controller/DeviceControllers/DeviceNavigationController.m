//
//  DeviceNavigationController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "DeviceNavigationController.h"

@interface DeviceNavigationController ()

@end

@implementation DeviceNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    CGSize imageSize = CGSizeMake(SCREEN_WIDTH, 64);
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc]initWithSize:imageSize];
    UIImage *image = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        UIColor *imageColor = NAVIGATIONBAR_COLOR;
        [imageColor setFill];
        [rendererContext fillRect:rendererContext.format.bounds];
    }];
    
    [self.navigationBar setBackgroundImage:image
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    
    [self.navigationBar lt_setBackgroundColor:NAVIGATIONBAR_COLOR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

//设置StatusBar的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
