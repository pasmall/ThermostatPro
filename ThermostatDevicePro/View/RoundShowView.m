//
//  RoundShowView.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "RoundShowView.h"
#import "NSString+Add.h"

@interface RoundShowView()<CAAnimationDelegate>
{
    UIImageView *imageLoad;
    CAGradientLayer *gradientLayer;
    UILabel *ctempLabel;
    UILabel *humidityLabel;
    UILabel *modelLabel;
    UILabel *tempLabel;
    CAShapeLayer *subLayer;
    
    CAGradientLayer *gradient;
    UILabel *titleLabel;
    
    UIView *afterTimeView;
    UIImageView *timeImageView;
    UILabel *timeLabel;
    
    dispatch_source_t dis_timer;
    Finish finishBlock;
    
    UIImageView *slurImageView;
}
@property (nonatomic, strong) NSTimer *timer;


@end


@implementation RoundShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        
        //渐变背景
        gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer.cornerRadius = self.width  * 0.5;
        gradientLayer.masksToBounds = YES;
        [self.layer addSublayer:gradientLayer];
        
        
        
        
        //两个图标
        UIImageView *img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(123), WIDTH_FIT(48), WIDTH_FIT(48))];
        [img1 setImage:[UIImage imageNamed:@"湿度@3x"]];
        img1.contentMode = UIViewContentModeScaleToFill;
        img1.x = self.width /2 - WIDTH_FIT(60) - WIDTH_FIT(48);
        
        UIImageView *img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(123), WIDTH_FIT(48), WIDTH_FIT(48))];
        [img2 setImage:[UIImage imageNamed:@"室温"]];
        img2.x = self.width /2 + WIDTH_FIT(60);
        [self addSubview:img1];
        [self addSubview:img2];
        
        //室内温度和湿度
        humidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img1.frame)+ HEIGHT_FIT(21), WIDTH_FIT(60)*2 + HEIGHT_FIT(48), 18)];
        humidityLabel.textColor = [UIColor whiteColor];
        humidityLabel.textAlignment = NSTextAlignmentCenter;
        humidityLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(39)];
        humidityLabel.centerX = img1.centerX;
        [self addSubview:humidityLabel];
        
        ctempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img2.frame)+ HEIGHT_FIT(21), WIDTH_FIT(60)*2 + HEIGHT_FIT(48), 18)];
        ctempLabel.textColor = [UIColor whiteColor];
        ctempLabel.textAlignment = NSTextAlignmentCenter;
        ctempLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(39)];
        ctempLabel.centerX = img2.centerX;
        [self addSubview:ctempLabel];
        
        //显示调节温度值 或者 待机
        UIFont *tempFont = [UIFont systemFontOfSize:HEIGHT_FIT(240)];
        tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ctempLabel.frame) + HEIGHT_FIT(45), self.width, [@"27" heightForFont:tempFont width:self.width])];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.font = tempFont;
        [self addSubview:tempLabel];
        
        //模式
        UIFont *modelFont = [UIFont systemFontOfSize:WIDTH_FIT(48)];
        modelLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, tempLabel.y, 0, [@"" heightForFont:modelFont width:self.width])];
        modelLabel.textColor = [UIColor whiteColor];
        modelLabel.font = modelFont;
        modelLabel.hidden = YES;
        [self addSubview:modelLabel];

        
        subLayer = [CAShapeLayer layer];
        subLayer.lineWidth = 1;
        subLayer.lineCap = kCALineCapRound;
        subLayer.frame = CGRectMake(- HEIGHT_FIT(36) /2 , - HEIGHT_FIT(36) /2, self.width + HEIGHT_FIT(36), self.height + HEIGHT_FIT(36));
        subLayer.fillColor = [UIColor clearColor].CGColor;
        subLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6].CGColor;
        subLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0,self.width + HEIGHT_FIT(36), self.height + HEIGHT_FIT(36))].CGPath;
        subLayer.strokeEnd = 1;
        subLayer.hidden = YES;
        [self.layer addSublayer:subLayer];
        
        //创建倒计时视图
        afterTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - WIDTH_FIT(132) - WIDTH_FIT(54), self.width, WIDTH_FIT(90))];
        afterTimeView.backgroundColor = [UIColor clearColor];
        [self addSubview:afterTimeView];
        
        timeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, afterTimeView.height, afterTimeView.height)];
        timeImageView.tintColor = [UIColor blackColor];
        [timeImageView setImage:[[UIImage imageNamed:@"定时开@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        NSString *timeStr = @"00:00:00";
        CGFloat timeWidth = [timeStr widthForFont:[UIFont systemFontOfSize:WIDTH_FIT(51)]];
        timeImageView.x = afterTimeView.width / 2 - (timeWidth  + afterTimeView.height) / 2;
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame), 0, timeWidth + HEIGHT_FIT(6), afterTimeView.height)];
        timeLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:0.6];
        timeLabel.text = timeStr;
        timeLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(51)];
        [afterTimeView addSubview:timeImageView];
        [afterTimeView addSubview:timeLabel];
        afterTimeView.alpha = 0;
        
        //开启设备的图
        imageLoad = [[UIImageView alloc] initWithFrame:CGRectMake(- HEIGHT_FIT(45), - HEIGHT_FIT(45), frame.size.width + HEIGHT_FIT(90), frame.size.height + HEIGHT_FIT(90))];
        imageLoad.hidden = YES;
        imageLoad.image = [UIImage imageNamed:@"i8_自动"];
        [self addSubview:imageLoad];
        
        //高斯模糊图
        slurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(- HEIGHT_FIT(36), - HEIGHT_FIT(36), frame.size.width + HEIGHT_FIT(72) , frame.size.height + HEIGHT_FIT(72))];
        slurImageView.hidden = YES;
        slurImageView.image = [UIImage imageNamed:@"i8_高斯模糊"];
        [self addSubview:slurImageView];
        
        //渐变背景
        gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, self.width , self.height );
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        gradient.cornerRadius = self.width  * 0.5;
        gradient.masksToBounds = YES;
        gradient.hidden = YES;
        gradient.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
        gradient.borderWidth = 1;
        [self.layer addSublayer:gradient];
        
        titleLabel = [[UILabel alloc]initWithFrame:tempLabel.frame];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:WIDTH_FIT(240)];
        titleLabel.alpha = 0;
        [self addSubview:titleLabel];

    }
    return self;
    
}

#pragma mark UI-Change
//开始旋转动画
- (void)startAnimation
{

    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.byValue = @(M_PI*2);
    rotateAnimation.duration = 10;
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.delegate = self;
    [imageLoad.layer addAnimation:rotateAnimation forKey:@"rotateAnimation"];
}


//展示提示
- (void)showModeChangeViewWithColors:(NSArray *)colors andTitle:(NSString *)title
{
    //渐变背景
    gradient.colors = colors;
    titleLabel.text = title;
    gradient.hidden = NO;
    titleLabel.alpha = 1;
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        gradient.hidden = YES;
    }];
    

}


#pragma mark mathod
- (void)showTimeViewWithTime:(NSInteger)time andFinish:(Finish)block
{
    
    finishBlock = block;
    switch ([[AppDataManager sharedAppDataManager] getCurrentDevice].deviceState) {
        case DeviceStateTypeOff:
            [timeImageView setImage:[[UIImage imageNamed:@"定时开@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            break;
        case DeviceStateTypeOn:
            [timeImageView setImage:[[UIImage imageNamed:@"定时关@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            break;
            
        default:
            break;
    }
    
    
    
    [self startTimerWithTime:time];
    
    [UIView animateWithDuration:0.5 animations:^{
        afterTimeView.alpha = 1;
    }];

    
    
}

- (void)removeTimer
{
    [self hiddenAfterTimeView];
    if (dis_timer != nil) {
        dispatch_source_cancel(dis_timer);
    }
}

- (void)hiddenAfterTimeView
{
    [UIView animateWithDuration:0.5 animations:^{
        afterTimeView.alpha = 0;
    }];
}

//开始倒计时
- (void)startTimerWithTime:(NSInteger)time
{
    if (dis_timer != nil) {
        dispatch_source_cancel(dis_timer);
    }
    
    __block NSInteger second = time;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dis_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(dis_timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    dispatch_source_set_event_handler(dis_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second >= 0) {
                timeLabel.text = [NSString getTimeStringWithTime:second];
                second--;
            }
            else
            {
                dispatch_source_cancel(dis_timer);
                [self hiddenAfterTimeView];
                [[[AppDataManager sharedAppDataManager] getCurrentDevice] tapDeviceOnOrOffAction];
                if (finishBlock != nil) {
                    finishBlock();
                }
                
            }
        });
    });
    //启动源
    dispatch_resume(dis_timer);


}

//待机
- (void)showWaitingView:(float)ctemp andHumidity:(NSUInteger)ambientHumidity
{
    tempLabel.text = LANGUE_STRING(@"待机");
    humidityLabel.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)ambientHumidity,@"%"];
    ctempLabel.text = [NSString stringWithFormat:@"%.1f℃",ctemp];
    
    gradientLayer.frame = CGRectMake(0, 0, self.width , self.height );
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"a6ff94"].CGColor,
                             (__bridge id)[UIColor colorWithHexString:@"38c1ff"].CGColor];
    
    gradientLayer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    gradientLayer.borderWidth = 1;
    subLayer.hidden = NO;
    imageLoad.hidden = YES;
    modelLabel.hidden = YES;
    slurImageView.hidden = YES;
}

//开机状态模式切换
- (void)showViewWithMode:(DeviceModelType)type andAmbient:(float)ctemp andHumidity:(NSUInteger)ambientHumidity andTemp:(float)temp
{
    
    switch (type) {
        case DeviceModelTypeHot:
            [self showHeatingView:ctemp andHumidity:ambientHumidity andTemp:temp];
            
            break;
        case DeviceModelTypeCool:
            [self showCoolingView:ctemp andHumidity:ambientHumidity andTemp:temp];
            
            break;
        case DeviceModelTypeChangeAir:
            [self showAiringView:ctemp andHumidity:ambientHumidity andTemp:temp];
            
            break;
            
        default:
            break;
    }
    
    gradientLayer.borderWidth = 0;
    subLayer.hidden = YES;
    modelLabel.hidden = NO;
    slurImageView.hidden = NO;
    [imageLoad.layer removeAllAnimations];
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [self startAnimation];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}


//制冷
- (void)showCoolingView:(float)ctemp andHumidity:(NSUInteger)ambientHumidity andTemp:(float)temp
{
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"2343d2"].CGColor,
                        (__bridge id)[UIColor colorWithHexString:@"54bdf1"].CGColor];
    gradientLayer.colors = colors;
    [self showModeChangeViewWithColors:colors andTitle:LANGUE_STRING(@"制冷")];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCtemp:ctemp];
        [self updateTemp:temp];
        [self updateHumidity:ambientHumidity];
        [self updateModeLabelFrameWithTitle:LANGUE_STRING(@"制冷") andTemp:temp];
    });
    imageLoad.image = [UIImage imageNamed:@"i8_制冷"];
    imageLoad.hidden = NO;


}

//制热
- (void)showHeatingView:(float)ctemp andHumidity:(NSUInteger)ambientHumidity andTemp:(float)temp
{
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"ff5c23"].CGColor,
                        (__bridge id)[UIColor colorWithHexString:@"ffd1d1"].CGColor];
    gradientLayer.colors = colors;
    [self showModeChangeViewWithColors:colors andTitle:LANGUE_STRING(@"制热")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCtemp:ctemp];
        [self updateTemp:temp];
        [self updateHumidity:ambientHumidity];
        [self updateModeLabelFrameWithTitle:LANGUE_STRING(@"制热") andTemp:temp];
    });
    imageLoad.image = [UIImage imageNamed:@"i8_制热"];
    imageLoad.hidden = NO;


}

//换气
- (void)showAiringView:(float)ctemp andHumidity:(NSUInteger)ambientHumidity andTemp:(float)temp
{
    NSArray *colors = @[(__bridge id)[UIColor colorWithHexString:@"a6cff9"].CGColor,
                        (__bridge id)[UIColor colorWithHexString:@"3498ff"].CGColor];
    gradientLayer.colors = colors;
    [self showModeChangeViewWithColors:colors andTitle:LANGUE_STRING(@"换气")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCtemp:ctemp];
        [self updateTemp:temp];
        [self updateHumidity:ambientHumidity];
        [self updateModeLabelFrameWithTitle:LANGUE_STRING(@"换气") andTemp:temp];
    });
    imageLoad.image = [UIImage imageNamed:@"i8_送风"];
    imageLoad.hidden = NO;

}

//更新mode显示的位置
- (void)updateModeLabelFrameWithTitle:(NSString *)str andTemp:(float)temp
{
    NSString *tempStr = [NSString stringWithFormat:@"%.1f",temp];
    CGFloat tempWidth = [tempStr widthForFont:[UIFont systemFontOfSize:HEIGHT_FIT(240)]];
    NSString *cStr = @"℃";
    CGFloat cWidth = [cStr widthForFont:[UIFont systemFontOfSize:HEIGHT_FIT(120)]];
    
    NSString *modeStr = str;
    CGFloat modeWidth = [modeStr widthForFont:modelLabel.font];
    modelLabel.width = modeWidth;
    modelLabel.x =  (self.width + tempWidth + cWidth ) /2 - modeWidth;
    modelLabel.centerY = (tempLabel.centerY + tempLabel.y ) /2;
    modelLabel.text = modeStr;

}

//更新信息
- (void)updateCtemp:(float)ctemp
{
    ctempLabel.text = [NSString stringWithFormat:@"%.1f℃",ctemp];

}

- (void)updateHumidity:(NSUInteger)ambientHumidity
{
    humidityLabel.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)ambientHumidity,@"%"];
}

- (void)updateTemp:(float)temp
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f℃",temp]];
    NSRange range1 = NSMakeRange(0, attributedString.length - 1);
    NSRange range2 = NSMakeRange(attributedString.length - 1 , 1);
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:HEIGHT_FIT(240)] range:range1];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:HEIGHT_FIT(120)] range:range2];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0 , attributedString.length)];
    tempLabel.attributedText = attributedString;

    [self updateModeLabelFrameWithTitle:modelLabel.text andTemp:temp];
}


- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

@end
