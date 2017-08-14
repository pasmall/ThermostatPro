//
//  AboutWeViewController.m
//  HotWindPro
//
//  Created by lyric on 2017/3/31.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "AboutWeViewController.h"

@interface AboutWeViewController ()

@end

@implementation AboutWeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"关于我们");
    [self setUI];
    
}

- (void)setUI
{
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame) + HEIGHT_FIT(150) , HEIGHT_FIT(300), HEIGHT_FIT(300))];
    iconImageView.backgroundColor = NAVIGATIONBAR_COLOR;
    iconImageView.layer.cornerRadius = HEIGHT_FIT(21);
    iconImageView.layer.masksToBounds = YES;
    [iconImageView setImage:[UIImage imageNamed:@"IOS设备图"]];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    iconImageView.centerX = self.view.centerX;
    [self.view  addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + HEIGHT_FIT(30), SCREEN_WIDTH, 24)];
    
    titleLabel.textAlignment  = NSTextAlignmentCenter;
    titleLabel.textColor = NAVIGATIONBAR_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    titleLabel.text = LANGUE_STRING(@"温控器");
    [self.view addSubview:titleLabel];
    
    //介绍信息
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.y + 24 + HEIGHT_FIT(42), SCREEN_WIDTH - 20, 0)];
    NSString *tipString = LANGUE_STRING(@"温控器系列秉承科技改变生活的理念，把小产品落地和大数据挖掘完美相结合，为千家万户提供一系列智能舒适、节能环保、价廉物美的智能设备。");
    tipLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
    CGFloat tipLabelHeight = [tipString heightForFont:tipLabel.font width:SCREEN_WIDTH -20];
    tipLabel.height = tipLabelHeight;
    tipLabel.text = tipString;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor = COLOR(33, 198, 211);
    [self.view addSubview:tipLabel];
    
    //版本信息
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH -20, 0)];
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.numberOfLines = 0;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *versionInfo = [NSString stringWithFormat:@"%@ \n Copyright©2017 GALAXYWIND NetWork Systems Co.,Ltd. \n All rights reserved" ,[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    CGFloat versionLabelHeight = [versionInfo heightForFont:versionLabel.font width:SCREEN_WIDTH - 20];
    versionLabel.text = versionInfo;
    versionLabel.height = versionLabelHeight;
    versionLabel.y = SCREEN_HEIGHT - versionLabelHeight - 20;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    //联系方式
    UILabel *contactLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 24)];
    contactLabel.y = versionLabel.y - 24 - 10;
    contactLabel.font = [UIFont systemFontOfSize:12];
    contactLabel.text = LANGUE_STRING(@"联系方式");
    contactLabel.textAlignment = NSTextAlignmentCenter;
    contactLabel.textColor = COLOR(33, 198, 211);
    [self.view addSubview:contactLabel];
    
    
}

@end
