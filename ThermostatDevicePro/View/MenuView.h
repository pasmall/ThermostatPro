//
//  MenuView.h
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/14.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MenuViewBlock)(NSInteger choiceIndex);

@interface MenuView : UIView

@property (nonatomic , copy) MenuViewBlock callBack;

//初始化一个菜单：NSArray为字典类型,格式为[image: , title: ] ,callBack 返回菜单的点击事件
+(instancetype)menuWithArray:(NSArray *)dataArray andcall:(MenuViewBlock)callBack;

//显示
- (void)showMenuWithPoint:(CGPoint)point andAnimate:(BOOL)isAnimate;



@end



