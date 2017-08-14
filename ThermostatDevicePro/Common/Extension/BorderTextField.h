//
//  BorderTextField.h
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BorderTextField : UITextField

//获取焦点的位置
-(NSRange)selectedRange;
//设置焦点的位置
-(void)setSelectedRange:(NSRange)range;

@end
