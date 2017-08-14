//
//  AddTimerTableViewCell.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/12.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "AddTimerTableViewCell.h"

@implementation AddTimerTableViewCell{

    UILabel *titLabel;
    UILabel *valueLabel;
    UISwitch *switchButton;
    UIView *angleLine;
    WeekType repeatWeek;
}

- (instancetype)initWithType:(TimerCellType )type
{
    self = [self init];
    if (self) {
        
        switch (type) {
            case TimerCellTypeWhite:{
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(105), SCREEN_WIDTH, HEIGHT_FIT(2))];
                line.backgroundColor = COLOR(204, 204, 204);
                [self addSubview:line];
            
            }
                break;
            case TimerCellTypeAngle:{
                
                titLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(45), 0, SCREEN_WIDTH /2, PX_TO_PT(132))];
                titLabel.centerY = PX_TO_PT(132) / 2;
                titLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
                [self addSubview:titLabel];
                
                UIImageView *nextImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                nextImage.tintColor = COLOR(199, 199, 204);
                nextImage.frame = CGRectMake(SCREEN_WIDTH - PX_TO_PT(132), 0, PX_TO_PT(132),  PX_TO_PT(132));
                nextImage.centerY = PX_TO_PT(132) / 2;
                [self addSubview:nextImage];
                
                valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH  - PX_TO_PT(132) - 160, 0, 160, PX_TO_PT(132))];
                valueLabel.centerY = PX_TO_PT(132) / 2;
                valueLabel.font = [UIFont systemFontOfSize:PX_TO_PT(42)];
                valueLabel.textColor = COLOR(141, 141, 141);
                valueLabel.textAlignment = NSTextAlignmentRight;
                [self addSubview:valueLabel];
                
                angleLine = [[UIView alloc]initWithFrame:CGRectMake(PX_TO_PT(45), PX_TO_PT(129), SCREEN_WIDTH - PX_TO_PT(45), HEIGHT_FIT(2))];
                angleLine.backgroundColor = COLOR(204, 204, 204);
                [self addSubview:angleLine];
                
            }
                break;
            case TimerCellTypeWeek:{
                titLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(45), 0, SCREEN_WIDTH /2, PX_TO_PT(132))];
                titLabel.centerY = PX_TO_PT(132) / 2;
                titLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
                [self addSubview:titLabel];
                
                //创建选择循环周按钮
                NSArray *titleArr = @[LANGUE_STRING(@"一"),LANGUE_STRING(@"二"),LANGUE_STRING(@"三"),LANGUE_STRING(@"四"),LANGUE_STRING(@"五"),LANGUE_STRING(@"六"),LANGUE_STRING(@"日"),LANGUE_STRING(@"全")];
                for (int i = 0; i < 8; i ++) {
                    int row = i / 4 ;
                    UIButton *subButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - (PX_TO_PT(630)) + (i % 4) * PX_TO_PT(162), 0, PX_TO_PT(102), PX_TO_PT(102))];
                    if (row == 0) {
                        subButton.y = PX_TO_PT(21);
                    }else{
                        subButton.y = PX_TO_PT(141);
                    }
                    subButton.backgroundColor = COLOR(229, 229, 229);
                    [subButton setTitleColor:COLOR(126, 126, 126) forState:UIControlStateNormal];
                    [subButton setTitle:titleArr[i] forState:UIControlStateNormal];
                    subButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(39)];
                    subButton.layer.cornerRadius = PX_TO_PT(102) / 2;
                    subButton.layer.masksToBounds = YES;
                    subButton.tag = i + 11;
                    [subButton addTarget:self action:@selector(tapSubButton:) forControlEvents:UIControlEventTouchUpInside];
                    subButton.selected = NO;
                    [self addSubview:subButton];

                }
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(261), SCREEN_WIDTH, HEIGHT_FIT(2))];
                line.backgroundColor = COLOR(204, 204, 204);
                [self addSubview:line];
            }
                break;
                
            case TimerCellTypeSwitch:{
                titLabel = [[UILabel alloc]initWithFrame:CGRectMake(PX_TO_PT(45), 0, SCREEN_WIDTH /2, PX_TO_PT(132))];
                titLabel.centerY = PX_TO_PT(132) / 2;
                titLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
                [self addSubview:titLabel];
                
                switchButton = [[UISwitch alloc]init];
                switchButton.frame =CGRectMake(0, 0, 51, 31);
                switchButton.centerY = PX_TO_PT(132) / 2;
                switchButton.x = SCREEN_WIDTH - WIDTH_FIT(48) - 51;
                [switchButton addTarget:self action:@selector(tapSwitchButton) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:switchButton];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, PX_TO_PT(129), SCREEN_WIDTH, HEIGHT_FIT(2))];
                line.backgroundColor = COLOR(204, 204, 204);
                [self addSubview:line];
                
            }
                break;
                
            default:
                break;
        }
    }
    
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setTitle:(NSString *)title
{
    titLabel.text = title;
    if ([title isEqualToString:LANGUE_STRING(@"情景")]) {
        angleLine.frame = CGRectMake(0, PX_TO_PT(129), SCREEN_WIDTH, PX_TO_PT(3));
    }
}

- (void)setWeeks:(WeekType)weekType
{
    repeatWeek = weekType;
    if (weekType&1<<0) {
        return;
    }
    if (weekType&1<<1) {
        [self setButtonSelectedWithTag:11];
    }
    
    if (weekType&1<<2){
        [self setButtonSelectedWithTag:12];
    }
    
    if (weekType&1<<3){
        [self setButtonSelectedWithTag:13];
    }
    
    if (weekType&1<<4){
        [self setButtonSelectedWithTag:14];
    }
    
    if (weekType&1<<5){
        [self setButtonSelectedWithTag:15];
    }
    
    if (weekType&1<<6){
        [self setButtonSelectedWithTag:16];
    }
    
    if (weekType&1<<7){
        [self setButtonSelectedWithTag:17];
    }
    
    if (weekType&1<<8){
        [self setButtonSelectedWithTag:18];
    }

}

- (void)setButtonSelectedWithTag:(NSInteger)tag
{
    UIButton *subButton = (UIButton *)[self viewWithTag:tag];
    subButton.selected = YES;
    subButton.backgroundColor = NAVIGATIONBAR_COLOR;
    [subButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setSwitch:(BOOL) isOn
{
    switchButton.on = isOn;
}

- (void)setCellValue:(NSString *)value
{
    valueLabel.text = value;
    
}


- (void)tapSubButton:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected) {
        button.backgroundColor = NAVIGATIONBAR_COLOR;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        button.backgroundColor = COLOR(229, 229, 229);
        [button setTitleColor:COLOR(126, 126, 126) forState:UIControlStateNormal];
    }
    
    if (button.tag == 18) {
        if (button.selected) {
            //全选
            for (int i = 11; i < 18; i ++) {
                UIButton *subButton = (UIButton *)[self viewWithTag:i];
                subButton.selected = YES;
                subButton.backgroundColor = NAVIGATIONBAR_COLOR;
                [subButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
            
        }else{
            //全不选
            for (int i = 11; i < 18; i ++) {
                UIButton *subButton = (UIButton *)[self viewWithTag:i];
                subButton.selected = NO;
                subButton.backgroundColor = COLOR(229, 229, 229);
                [subButton setTitleColor:COLOR(126, 126, 126) forState:UIControlStateNormal];
            }
        }
        
    }
    
    for (int i = 11; i < 19; i ++) {
        UIButton *subButton = (UIButton *)[self viewWithTag:i];
        if (subButton.selected == YES) {
            if (i == 11) {
                repeatWeek |= WeekTypeMon;
            }
            if (i == 12){
                repeatWeek |= WeekTypeTue;
            }
            if (i == 13){
                repeatWeek |= WeekTypeWed;
            }
            if (i == 14){
                repeatWeek |= WeekTypeThu;
            }
            
            if (i == 15){
                repeatWeek |= WeekTypeFir;
            }
            if (i == 16){
                repeatWeek |= WeekTypeSat;
            }
            
            if (i == 17){
                repeatWeek |= WeekTypeSun;
            }
            if (i == 18){
                repeatWeek |= WeekTypeAll;
            }
        }else{
            if (i == 11) {
                repeatWeek &= ~WeekTypeMon;
            }
            if (i == 12){
                repeatWeek &= ~WeekTypeTue;
            }
            if (i == 13){
                repeatWeek &= ~WeekTypeWed;
            }
            if (i == 14){
                repeatWeek &= ~WeekTypeThu;
            }
            
            if (i == 15){
                repeatWeek &= ~WeekTypeFir;
            }
            if (i == 16){
                repeatWeek &= ~WeekTypeSat;
            }
            
            if (i == 17){
                repeatWeek &= ~WeekTypeSun;
            }
            if (i == 18){
                repeatWeek &= ~WeekTypeAll;
            }
            
        }
    }
    [self.delegate getReWeeks:repeatWeek];
    
}

- (void)tapSwitchButton
{
    [self.delegate settingSwitch:switchButton.on];

}

















@end
