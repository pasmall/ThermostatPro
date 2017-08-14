//
//  AppUtil.h
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#ifndef AppUtil_h
#define AppUtil_h


// 屏幕宽度、高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//宽高适配(等比缩放)
#define WIDTH_FIT(_w) SCREEN_WIDTH * _w/1242
#define HEIGHT_FIT(_h)  SCREEN_HEIGHT * _h/2208

//流式布局（px转成pt,设计图是@3x,直接除以3,文字大小全部使用6plus的pt）
#define PX_TO_PT(_f) _f / 3

//rgb颜色的宏定义
#define COLOR(_r,_g,_b) [UIColor colorWithRed:_r / 255.0f green:_g / 255.0f blue:_b / 255.0f alpha:1]

//hex颜色值
#define COLOR_HEXSTRING(_s) [UIColor colorWithHexString:_s]

//导航栏背景色
#define NAVIGATIONBAR_COLOR  COLOR(0, 171, 224)

//按钮灰色
#define BUTTON_GRAY_COLOR COLOR(139, 214, 240)

//多语言
#define LANGUE_STRING(key) [[AppDataManager sharedAppDataManager] getLangueStringWithKey:(key)]

//Debug日志
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"^ %s line %d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//强弱引用转换
#define WeakObject(_o) autoreleasepool{} __weak typeof(_o) _o##Weak = _o;
#define StrongObject(_o) autoreleasepool{} __strong typeof(_o) _o = _o##Weak;




#endif /* AppUtil_h */
