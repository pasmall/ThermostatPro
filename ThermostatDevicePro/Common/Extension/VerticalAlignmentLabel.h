//
//  VerticalAlignmentUILabel.h
//  HotWindPro
//
//  Created by lyric on 2017/3/30.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VerticalAlignmentTop = 0, //水平居上
    VerticalAlignmentMiddle,//水平居中
    VerticalAlignmentBottom,//水平居下
    
} VerticalAlignment;

@interface VerticalAlignmentLabel : UILabel


@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
