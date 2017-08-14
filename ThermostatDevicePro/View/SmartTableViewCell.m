//
//  SmartTableViewCell.m
//  ThermostatDevicePro
//
//  Created by 聂自强 on 2017/6/11.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "SmartTableViewCell.h"

@implementation SmartTableViewCell{
    UIImageView *iconImageView;
    UILabel *titleLab;
    UISwitch *switchButton;
    UILabel *infoLab;
    UIView *whiteBg;
    UIView *grayBg;
    UILabel *konwLab;
    NSInteger cellType;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        whiteBg = [[UIView alloc]init];
        whiteBg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteBg];
        
        iconImageView = [[UIImageView alloc]init];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        iconImageView.tintColor = COLOR(0, 171, 222);
        [whiteBg addSubview:iconImageView];
        
        titleLab = [[UILabel alloc]init];
        titleLab.font = [UIFont systemFontOfSize:WIDTH_FIT(60)];
        [whiteBg addSubview:titleLab];
        
        switchButton = [[UISwitch alloc]init];
        [switchButton addTarget:self action:@selector(tapSwitchButton) forControlEvents:UIControlEventTouchUpInside];
        [whiteBg addSubview:switchButton];
        
        
        grayBg = [[UIView alloc]init];
        grayBg.backgroundColor = COLOR(239, 239, 239);
        [self.contentView addSubview:grayBg];
        
        infoLab = [[UILabel alloc]init];
        infoLab.font = [UIFont systemFontOfSize:WIDTH_FIT(36)];
        infoLab.textColor = COLOR(140, 140, 140);
        [grayBg addSubview:infoLab];
        
        
        konwLab = [[UILabel alloc]init];
        konwLab.font = [UIFont systemFontOfSize:WIDTH_FIT(39)];
        konwLab.textColor = COLOR(40, 170, 229);
        [grayBg addSubview:konwLab];
        
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
    
}

- (void)setTitle:(NSString *)title andImageName:(NSString *)imgName andSwitch:(BOOL)isOn andInfoText:(NSString *)info andType:(NSInteger)type
{
    
    cellType = type;
    titleLab.text = title;
    iconImageView.image = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    if (cellType == 0) {
        infoLab.text = info;
        [self setSubViewFrame];
        switchButton.on = [[AppDataManager sharedAppDataManager] getCurrentDevice].deviceCTemp;
        
    }else if (cellType == 1){
        infoLab.text = info;
        [self setSubViewFrame];
        switchButton.on = [[AppDataManager sharedAppDataManager] getCurrentDevice].deviceTempGraph;
        
    }else{
        [self setSubViewFrameAngle];
    }
 
}

- (void)setSubViewFrame
{
    whiteBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, WIDTH_FIT(204));
    iconImageView.frame = CGRectMake(WIDTH_FIT(30), 0, WIDTH_FIT(132),WIDTH_FIT(132));
    iconImageView.centerY = whiteBg.height / 2;
    titleLab.frame = CGRectMake(WIDTH_FIT(60) + iconImageView.width , 0, SCREEN_WIDTH / 2,  whiteBg.height);
    switchButton.frame =CGRectMake(0, 0, 51, 31);
    switchButton.centerY = whiteBg.height / 2;
    switchButton.x = SCREEN_WIDTH - WIDTH_FIT(48) - 51;
    
    grayBg.frame = CGRectMake(0, WIDTH_FIT(204), SCREEN_WIDTH, WIDTH_FIT(144));
    infoLab.frame = CGRectMake(WIDTH_FIT(30), 0, SCREEN_WIDTH * 0.7, grayBg.height);
    NSString *kownStr = LANGUE_STRING(@"了解详情");
    CGFloat kownWidth = [kownStr widthForFont:[UIFont systemFontOfSize:WIDTH_FIT(39)]];
    konwLab.frame = CGRectMake(SCREEN_WIDTH - kownWidth - WIDTH_FIT(30), 0, kownWidth, grayBg.height);
    konwLab.text = kownStr;
    
}

- (void)setSubViewFrameAngle
{
    whiteBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, WIDTH_FIT(204));
    iconImageView.frame = CGRectMake(WIDTH_FIT(30), 0, WIDTH_FIT(132),WIDTH_FIT(132));
    iconImageView.centerY = whiteBg.height / 2;
    titleLab.frame = CGRectMake(WIDTH_FIT(60) + iconImageView.width , 0, SCREEN_WIDTH / 2,  whiteBg.height);
    [switchButton removeFromSuperview];
    [grayBg removeFromSuperview];
    
    UIImageView *nextImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    nextImage.tintColor = NAVIGATIONBAR_COLOR;
    nextImage.frame = CGRectMake(SCREEN_WIDTH - WIDTH_FIT(162), 0, WIDTH_FIT(132),  WIDTH_FIT(132));
    nextImage.centerY = whiteBg.height / 2;
    [whiteBg addSubview:nextImage];

}

- (void)tapSwitchButton
{
    ThermostatDeviceModel *device = [[AppDataManager sharedAppDataManager] getCurrentDevice];
    if (cellType == 0) {
        [device tapDeviceCTempSwitch];
        switchButton.on = device.deviceCTemp;
        
    }else{
        [device tapDeviceTempGraphSwitch];
        switchButton.on = device.deviceTempGraph;
    }

}



@end
