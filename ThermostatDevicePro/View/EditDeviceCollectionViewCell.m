//
//  EditDeviceCollectionViewCell.m
//  HotWindPro
//
//  Created by lyric on 2017/3/28.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "EditDeviceCollectionViewCell.h"

@interface EditDeviceCollectionViewCell ()

@property(nonatomic , strong)UIImageView *iconImageView;//左侧图标
@property(nonatomic , strong)UILabel *titleLabel;//左侧标题

@end

@implementation EditDeviceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconImageView];
        
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_HEXSTRING(@"#4d4d4d");
        _titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(39)];
        [self addSubview:_titleLabel];
          
    }
    return self;
}

//给cell设置title和图片
- (void)setTitile:(NSString *)title andImageName:(NSString *)imageName
{
    
     _titleLabel.text = title;
    _iconImageView.image = [UIImage imageNamed:imageName];
    
    [self setSubViewFrame];
}

//设置cell子控件frame
- (void)setSubViewFrame
{
    
    _titleLabel.frame = CGRectMake(0, HEIGHT_FIT(261) -HEIGHT_FIT(48) - 20, self.width, 20);
    
    _iconImageView.frame = CGRectMake(0, HEIGHT_FIT(33),  HEIGHT_FIT(90), HEIGHT_FIT(90));
    _iconImageView.centerX = self.height / 2;

}



@end
