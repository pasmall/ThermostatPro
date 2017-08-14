//
//  SettingDeviceTableViewCell.m
//  HotWindPro
//
//  Created by lyric on 2017/3/30.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "SettingDeviceTableViewCell.h"

@interface SettingDeviceTableViewCell ()

@property(nonatomic , strong)UIImageView *iconImageView;

@end

@implementation SettingDeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImageView];
        
        [self setSubViewFrame];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    }

    return self;
}

//设置cell子控件frame
- (void)setSubViewFrame
{
    
    _iconImageView.frame = CGRectMake(WIDTH_FIT(48), 0,  0, HEIGHT_FIT(150));
    _iconImageView.centerY = HEIGHT_FIT(231) * 0.5;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(231) - HEIGHT_FIT(3) , SCREEN_WIDTH, HEIGHT_FIT(3))];
    lineView.backgroundColor = COLOR(203, 203, 203);
    [self addSubview:lineView];
    
}

//设置右边为开关按钮
- (void)setImageName:(NSString *)imageName andSwitchValue:(BOOL)switchValue
{

    self.switchButton.on = switchValue;
    _iconImageView.width = WIDTH_FIT(150);
    _iconImageView.image = [UIImage imageNamed:imageName];
    
}


//设置右边为Button
- (void)setImageName:(NSString *)imageName andLangueType:(LangueType)type
{
    
    switch (type) {
        case LangueTypeChinese:
           [self.selectedButton setImage:[UIImage imageNamed:@"简体中文"] forState:UIControlStateNormal];
            break;
        case LangueTypeEnglish:
            [self.selectedButton setImage:[UIImage imageNamed:@"English"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }

    _iconImageView.width = WIDTH_FIT(177);
    if (imageName == nil) return;
    _iconImageView.image = [UIImage imageNamed:imageName];
    
    

}
#pragma mark 懒加载
- (UISwitch *)switchButton
{
    if (!_switchButton) {
        self.switchButton = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - WIDTH_FIT(48), 0, 51, 31)];
        self.switchButton.centerY = HEIGHT_FIT(231) * 0.5;
        [self.switchButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.switchButton];
    }
    return _switchButton;
}

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        self.selectedButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - WIDTH_FIT(180) - WIDTH_FIT(48), 0, WIDTH_FIT(180), WIDTH_FIT(150))];
        self.selectedButton.centerY = HEIGHT_FIT(231) * 0.5;
        [self.selectedButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectedButton];
    }
    return _selectedButton;
}

#pragma mark Action
//代理
- (void)tapAction
{
    if ([self.delegate respondsToSelector:@selector(tapActionWithCell:)]) {
        [self.delegate tapActionWithCell:self];
    }
}




@end
