//
//  LeftForAboutViewController.m
//  HotWindPro
//
//  Created by 聂自强 on 2017/3/23.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "LeftForAboutViewController.h"
#import "LeftBarTableViewCell.h"
#import "ZQLeftSlipManager.h"

@interface LeftForAboutViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong)UITableView *infoTableView;
@property (nonatomic , strong)NSArray *infoArray;//title数组
@property (nonatomic , strong)NSArray *imageNameArray;//imageName数组
@property (nonatomic , strong)UILabel *titleLabel; //显示图标下的文字

@end

@implementation LeftForAboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];

}

- (void)setUI
{
    
    //创建header
    UIView *iconHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_FIT(759), HEIGHT_FIT(708))];
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HEIGHT_FIT(180), HEIGHT_FIT(180))];
    iconImageView.layer.borderWidth = 1;
    iconImageView.layer.borderColor = [UIColor blackColor].CGColor;
    iconImageView.layer.cornerRadius = HEIGHT_FIT(180) /2;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView setImage:[UIImage imageNamed:@"用户名"]];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.center = iconHeaderView.center;
    [iconHeaderView  addSubview:iconImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + HEIGHT_FIT(30), WIDTH_FIT(759), 24)];
    self.titleLabel.textAlignment  = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(51)];
    [iconHeaderView addSubview:self.titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, iconHeaderView.height - HEIGHT_FIT(3) , WIDTH_FIT(759), HEIGHT_FIT(3))];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [iconHeaderView addSubview:lineView];
    
    [self.view addSubview:iconHeaderView];
    
    
    //创建设备tableView
    self.infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(iconHeaderView.frame) , WIDTH_FIT(759), SCREEN_HEIGHT - CGRectGetMaxY(iconHeaderView.frame)) style:UITableViewStylePlain];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource =self;
    self.infoTableView.showsVerticalScrollIndicator = NO;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infoTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.infoTableView];
    
}

//获取数据
- (void)getData
{
    self.infoArray =@[LANGUE_STRING(@"系统设置"),LANGUE_STRING(@"关于我们")];
    self.imageNameArray = @[@"设置",@"关于"];
    [self.infoTableView reloadData];
    self.titleLabel.text = LANGUE_STRING(@"温控器");
}


#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"left_bar";
    LeftBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LeftBarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setTitile:self.infoArray[indexPath.row] andImageName:self.imageNameArray[indexPath.row]];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(171);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[ZQLeftSlipManager sharedManager]dismissLeftView];
    switch (indexPath.row) {
        case LeftViewActionTypeSetting:{
            if ([self.delegate respondsToSelector:@selector(didSelectedToPushViewController:)]) {
                [self.delegate didSelectedToPushViewController:LeftViewActionTypeSetting];
            }
        }
            break;
        case LeftViewActionTypeAbout:{
            if ([self.delegate respondsToSelector:@selector(didSelectedToPushViewController:)]) {
                [self.delegate didSelectedToPushViewController:LeftViewActionTypeAbout];
            }
        }
            break;
            
        default:
            break;
    }

}


@end
