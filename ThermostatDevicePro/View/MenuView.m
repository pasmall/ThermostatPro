//
//  MenuView.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/14.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "MenuView.h"

@interface MenuView(){
    NSArray *dataArr;
}


@property (weak,nonatomic)UIView *backgroundView;    //屏幕下方看不到的view

@end

@implementation MenuView

//初始化一个菜单
+(instancetype)menuWithArray:(NSArray *)dataArray andcall:(MenuViewBlock)callBack
{
    MenuView *menu = [[MenuView alloc]initWithFrame:[UIScreen mainScreen].bounds andArray:dataArray];
    menu.callBack = callBack;
    return menu;

}

- (instancetype)initWithFrame:(CGRect)frame andArray:(NSArray*)dataArray
{
    self = [super initWithFrame:frame];
    if (self) {
        dataArr = dataArray;
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    //首先创建一个位于屏幕下方看不到的view
    UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
    [bgView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
    self.backgroundView = bgView;
    
    //self
    self.backgroundColor = [UIColor clearColor];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [self setFrame: CGRectMake(0, 0,HEIGHT_FIT(534), HEIGHT_FIT(180) * dataArr.count + HEIGHT_FIT(21))];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(21), self.width, self.height - HEIGHT_FIT(21))];
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft|UIRectCornerBottomRight  cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = contentView.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    contentView.layer.mask = maskLayer;
    [self addSubview:contentView];
    
    for (int i = 0; i < dataArr.count; i++) {
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, i * HEIGHT_FIT(180), self.width, HEIGHT_FIT(180))];
        bgView.backgroundColor = [UIColor clearColor];
        [contentView addSubview:bgView];
        //添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMenuView:)];
        [bgView addGestureRecognizer:tap];
        bgView.tag = 10+i;
        
        NSDictionary *dic = dataArr[i];
        UIImageView *iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"image"]]];
        iconImg.frame = CGRectMake(HEIGHT_FIT(42), 0, HEIGHT_FIT(96), HEIGHT_FIT(96));
        iconImg.centerY = HEIGHT_FIT(90);
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(HEIGHT_FIT(174), 0, self.width - HEIGHT_FIT(174), HEIGHT_FIT(180))];
        titleLab.centerY = HEIGHT_FIT(90);
        titleLab.font = [UIFont systemFontOfSize:HEIGHT_FIT(54)];
        titleLab.textColor = [UIColor whiteColor];
        titleLab.text = dic[@"title"];
        [bgView addSubview:iconImg];
        [bgView addSubview:titleLab];
    }
    
    UIImageView *SanJiao = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"小三角@3x"]];
    SanJiao.frame = CGRectMake(self.width - HEIGHT_FIT(36), 0.1, HEIGHT_FIT(36) , HEIGHT_FIT(21) );
    [self addSubview:SanJiao];

}

#pragma mark Action
- (void)tapMenuView:(UITapGestureRecognizer *)tap
{
    _callBack(tap.view.tag - 10);
    [self dismissMenuWithAnimate:NO];
}



- (void)tapDismiss
{
    [self dismissMenuWithAnimate:NO];
}

- (void)showMenuWithPoint:(CGPoint)point andAnimate:(BOOL)isAnimate
{

    self.x = point.x;
    self.y = point.y;
    if (isAnimate) {
        self.alpha = 0.0;
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        
        [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
            self.alpha = 1.0;
        } completion:NULL];
        
    }else{
        [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
        
    }
    
    

}

- (void)dismissMenuWithAnimate:(BOOL)isAnimate
{
    if (isAnimate) {
        [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
            [self removeFromSuperview];
            
        }];
        
    }else{

        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }
}





@end
