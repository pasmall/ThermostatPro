//
//  DeviceTableViewCell.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/7.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "DeviceTableViewCell.h"

@interface DeviceTableViewCell()

@property(nonatomic , strong)UIImageView *iconImageView;
@property(nonatomic , strong)UILabel *titleLabel;
@property(nonatomic , strong)UILabel *stateLabel;
@property(nonatomic , strong)UIButton *editButton;

@end


@implementation DeviceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"IOS设备图"]];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.backgroundColor = NAVIGATIONBAR_COLOR;
        _iconImageView.layer.cornerRadius = PX_TO_PT(156) /2;
        _iconImageView.layer.masksToBounds = YES;
        [self addSubview:_iconImageView];
        
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#484848"];
        _titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
        [self addSubview:_titleLabel];
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = [UIFont systemFontOfSize:PX_TO_PT(42)];
        [self addSubview:_stateLabel];
        
        _editButton = [[UIButton alloc]init];
        [_editButton setImage:[[UIImage imageNamed:@"关于"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_editButton setTintColor:COLOR(157, 157, 157)];
        [_editButton setContentMode:UIViewContentModeScaleAspectFit];
        [_editButton addTarget:self action:@selector(tapEditButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editButton];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, PX_TO_PT(231) - 1, SCREEN_WIDTH - 10, 1)];
        lineView.backgroundColor = COLOR(220, 220, 220);
        [self addSubview:lineView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return self;
}

    
    
//数据设置
    
- (void)setThermostatModel:(ThermostatDeviceModel *)thermostatModel
{
    _thermostatModel = thermostatModel;
    
    _titleLabel.text = thermostatModel.deviceName;
    
    NSMutableAttributedString *attributedString;
    if (thermostatModel.deviceState == DeviceStateTypeOff) {
        
        attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %lu℃" ,LANGUE_STRING(@"待机") , (unsigned long)thermostatModel.deviceTemp]];
        [attributedString addAttribute:NSForegroundColorAttributeName value: COLOR_HEXSTRING(@"#666666") range:NSMakeRange(0 , attributedString.length)];
        
        
    }else{
        
        switch (thermostatModel.deviceMode) {
            case DeviceModelTypeHot:{
                attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %.1f℃" ,LANGUE_STRING(@"制热") , thermostatModel.deviceTemp]];
            }
            break;
            case DeviceModelTypeCool:{
                attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %.1f℃" ,LANGUE_STRING(@"制冷") , thermostatModel.deviceTemp]];
            }
            break;
            case DeviceModelTypeChangeAir:{
                attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@   %.1f℃" ,LANGUE_STRING(@"换气") , thermostatModel.deviceTemp]];
            }
            break;
            
            default:
            break;
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value: COLOR_HEXSTRING(@"#00c853") range:NSMakeRange(0 , attributedString.length)];
        
    }
    NSRange range1 = NSMakeRange(0, attributedString.length - 1);
    NSRange range2 = NSMakeRange(attributedString.length - 1 , 1);
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:PX_TO_PT(42)] range:range1];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:PX_TO_PT(30)] range:range2];
    _stateLabel.attributedText = attributedString;
    
    
    
   [self setSubViewFrame];
}


//设置cell子控件frame
- (void)setSubViewFrame
{
    
    _iconImageView.frame = CGRectMake(PX_TO_PT(54), PX_TO_PT(37.5),  PX_TO_PT(156), PX_TO_PT(156));
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + PX_TO_PT(39), PX_TO_PT(48), SCREEN_WIDTH* 0.7, PX_TO_PT(60));
    _stateLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + PX_TO_PT(39), CGRectGetMaxY(_titleLabel.frame)+PX_TO_PT(12), SCREEN_WIDTH* 0.5, PX_TO_PT(72));
    _editButton.frame = CGRectMake(SCREEN_WIDTH - PX_TO_PT(231) , 0, PX_TO_PT(231), PX_TO_PT(231));
    _editButton.centerY = PX_TO_PT(231) * 0.5;
    _editButton.contentEdgeInsets = UIEdgeInsetsMake(PX_TO_PT(70.5), PX_TO_PT(87), PX_TO_PT(70.5), PX_TO_PT(54));
}


//编辑按钮点击
- (void)tapEditButton
{
    if ([self.delegate respondsToSelector:@selector(tapEditButtonWithDeviceModel:)]) {
        [self.delegate tapEditButtonWithDeviceModel:_thermostatModel];
    }
    
}
    

@end
