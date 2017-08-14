//
//  RippleView.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "RippleView.h"

@interface RippleView ()

@end

@implementation RippleView

//移除所有控件
- (void)removeFromParentView
{
    if (self.superview) {

        [self closeRippleTimer];
        [self.layer removeAllAnimations];
        [self removeAllSubLayers];
    }
}

//移除所有layer
- (void)removeAllSubLayers
{
    for (NSInteger i = 0; [self.layer sublayers].count > 1; i++) {
        if ([[self.layer sublayers] firstObject] != _rippleButton.layer) {
            [[[self.layer sublayers] firstObject] removeFromSuperlayer];
        }
    }
}

//设置显示的RippleType
- (void)showWithRippleType:(RippleType)type andcall:(TapActionButtonBlock)callBack
{
    _callBack = callBack;
    _type = type;
    [self setUpRippleButton];
    
}

//设置button
- (void)setUpRippleButton
{
    
    _rippleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, HEIGHT_FIT(432), HEIGHT_FIT(432))];
    _rippleButton.backgroundColor = NAVIGATIONBAR_COLOR;
    [_rippleButton setTitle:LANGUE_STRING(@"开始搜索") forState:UIControlStateNormal];
    _rippleButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    [_rippleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rippleButton.layer.cornerRadius = HEIGHT_FIT(432) * 0.5;
    _rippleButton.layer.masksToBounds = YES;
    [_rippleButton addTarget:self action:@selector(tapStartSearch) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rippleButton];
}

//点击开始搜索
- (void)tapStartSearch
{
    _callBack();
    
}

//波纹结束的Rect
- (CGRect)makeEndRect
{
    CGRect endRect = CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, HEIGHT_FIT(432), HEIGHT_FIT(432));
    endRect = CGRectInset(endRect, -150, -150);
    return endRect;
}

//添加波纹Layer
- (void)addRippleLayer
{
    
    CAShapeLayer *rippleLayer = [[CAShapeLayer alloc] init];
    rippleLayer.position = _rippleButton.center;
    rippleLayer.bounds = CGRectMake(0, 0, HEIGHT_FIT(432), HEIGHT_FIT(432));
    rippleLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, HEIGHT_FIT(432), HEIGHT_FIT(432))];
    rippleLayer.path = path.CGPath;
    rippleLayer.strokeColor = NAVIGATIONBAR_COLOR.CGColor;
    if (RippleTypeRing == _type) {
        rippleLayer.lineWidth = WIDTH_FIT(30);
    } else {
        rippleLayer.lineWidth = 1.5;
    }
    
    if (RippleTypeLine == _type || RippleTypeRing == _type) {
        rippleLayer.fillColor = [UIColor clearColor].CGColor;
    } else if (RippleTypeCircle == _type) {
        rippleLayer.fillColor = [UIColor greenColor].CGColor;
    } else if (RippleTypeMixed == _type) {
        rippleLayer.fillColor = [UIColor grayColor].CGColor;
    }
    
    [self.layer insertSublayer:rippleLayer below:_rippleButton.layer];
    
    //添加动画
    UIBezierPath *beginPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_rippleButton.frame.origin.x, _rippleButton.frame.origin.y, HEIGHT_FIT(432), HEIGHT_FIT(432))];
    CGRect endRect = [self makeEndRect];
    UIBezierPath *endPath = [UIBezierPath bezierPathWithOvalInRect:endRect];
    
    rippleLayer.path = endPath.CGPath;
    rippleLayer.opacity = 0.0;
    
    CABasicAnimation *rippleAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    rippleAnimation.fromValue = (__bridge id _Nullable)(beginPath.CGPath);
    rippleAnimation.toValue = (__bridge id _Nullable)(endPath.CGPath);
    rippleAnimation.duration = 1.5;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:0.6];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.0];
    opacityAnimation.duration = 1.5;
    
    [rippleLayer addAnimation:opacityAnimation forKey:@""];
    [rippleLayer addAnimation:rippleAnimation forKey:@""];
    
    [self performSelector:@selector(removeRippleLayer:) withObject:rippleLayer afterDelay:5.0];
    
    //定时显示
    if (_times > 0) {
        _times-- ;
        [_rippleButton setTitle:[NSString stringWithFormat:@"%ld",(long)_times] forState:UIControlStateNormal];
    }else{
        _rippleButton.userInteractionEnabled = YES;
        [_rippleButton setTitle:LANGUE_STRING(@"开始搜索") forState:UIControlStateNormal];
    }
    
}

//移除波纹Layer
- (void)removeRippleLayer:(CAShapeLayer *)rippleLayer
{
    
    [rippleLayer removeFromSuperlayer];
    rippleLayer = nil;
}

//关闭定时器
- (void)closeRippleTimer
{
    
    if (_rippleTimer) {
        if ([_rippleTimer isValid]) {
            [_rippleTimer invalidate];
        }
        _rippleTimer = nil;
    }
}

@end
