//
//  UIColor+Add.h
//  HotWindPro
//
//  Created by lyric on 2017/3/27.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Add)

//从十六进制字符串获取颜色
+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
