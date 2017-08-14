//
//  ZQLeftSlipManager.h
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZQLeftSlipManager : UIPercentDrivenInteractiveTransition

+ (instancetype)sharedManager;

//设置左滑视图及主视图
- (void)setLeftViewController:(UIViewController *)leftViewController coverViewController:(UIViewController *)coverViewController;

//显示侧滑视图
- (void)showLeftView;

//取消显示侧滑视图
- (void)dismissLeftView;

@property (nonatomic, assign) BOOL showLeft;//是否已经显示左滑视图


@end
