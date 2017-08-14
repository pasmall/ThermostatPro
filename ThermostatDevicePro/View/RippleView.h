//
//  RippleView.h
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RippleType) {
    RippleTypeLine,
    RippleTypeRing,
    RippleTypeCircle,
    RippleTypeMixed,
};

typedef void(^TapActionButtonBlock)();

@interface RippleView : UIView

@property (nonatomic , copy)TapActionButtonBlock callBack;
@property (nonatomic, strong) UIButton *rippleButton;

@property (nonatomic, strong) NSTimer *rippleTimer;//定时器
@property (nonatomic, assign) NSInteger mode;
@property (nonatomic, assign) RippleType type;//水波类型
@property (nonatomic, assign) NSInteger times;//定时时间

//显示波状类型
- (void)showWithRippleType:(RippleType)type andcall:(TapActionButtonBlock)callBack;

//移除控件
- (void)removeFromParentView;

//添加波纹Layer
- (void)addRippleLayer;

@end
