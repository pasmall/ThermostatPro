//
//  LeftBarTableViewCell.m
//  HotWindPro
//
//  Created by lyric on 2017/3/28.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "LeftBarTableViewCell.h"

@interface LeftBarTableViewCell()


@property(nonatomic , strong)UIImageView *iconImageView;
@property(nonatomic , strong)UILabel *titleLabel;
@property(nonatomic , strong)UIImageView *nextImageView;
@property(nonatomic , strong)UIView *lineView;

@end

@implementation LeftBarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.tintColor = NAVIGATIONBAR_COLOR;
        [self addSubview:_iconImageView];
        
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
        [self addSubview:_titleLabel];
        
        _nextImageView = [[UIImageView alloc]init];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
        _nextImageView.tintColor = NAVIGATIONBAR_COLOR;
        
        [_nextImageView setImage:[[UIImage imageNamed:@"箭头"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        [self addSubview:_nextImageView];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineView];
        
        self.backgroundColor  = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    return self;
}

//给cell设置title和图片
- (void)setTitile:(NSString *)title andImageName:(NSString *)imageName
{
    
    _titleLabel.text = title;
    _iconImageView.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self setSubViewFrame];
    
    if ([imageName isEqualToString:@"设置"]) {
        _iconImageView.frame = CGRectMake(WIDTH_FIT(60), 0,  HEIGHT_FIT(64) * 1.3, HEIGHT_FIT(64) * 1.3);
        _iconImageView.centerY = PX_TO_PT(171) * 0.5;
    }
}

//设置cell子控件frame
- (void)setSubViewFrame
{
    
    _iconImageView.frame = CGRectMake(WIDTH_FIT(60), 0,  HEIGHT_FIT(64) * 1.2, HEIGHT_FIT(64) * 1.2);
    _iconImageView.centerY = PX_TO_PT(171) * 0.5;
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame) + WIDTH_FIT(60), 0, WIDTH_FIT(400), 24);
    _titleLabel.centerY = PX_TO_PT(171) * 0.5;
    
    _nextImageView.frame = CGRectMake(WIDTH_FIT(759) -WIDTH_FIT(90) - WIDTH_FIT(30) , 0, WIDTH_FIT(90) * 1.3, WIDTH_FIT(90) * 1.3);
    _nextImageView.centerY = PX_TO_PT(171) * 0.5;
    
    _lineView.frame = CGRectMake(0, PX_TO_PT(171) - HEIGHT_FIT(3) , WIDTH_FIT(759), HEIGHT_FIT(3));
    
}

@end
