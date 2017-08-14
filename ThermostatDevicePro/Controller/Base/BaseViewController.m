//
//  BaseViewController.m
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //自定义返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(tapBack)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -WIDTH_FIT(54), 0, WIDTH_FIT(54));

}

//不隐藏StatusBar
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

//设置StatusBar的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark Action

//返回
- (void)tapBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
