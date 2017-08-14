//
//  SmartSettingViewController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "SmartSettingViewController.h"
#import "SmartTableViewCell.h"
#import "TimersViewController.h"


@interface SmartSettingViewController ()<UITableViewDelegate , UITableViewDataSource>

@property (nonatomic , strong)UITableView *smartTableView;
@property (nonatomic , strong)NSArray *imageNameArray;
@property (nonatomic , strong)NSArray *titleArray;

@end

@implementation SmartSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getData];
    [self setUI];
    
}

- (void)getData
{
    self.imageNameArray = @[@"智能恒温@3x",@"温度曲线@3x",@"定时@3x"];
    self.titleArray = @[LANGUE_STRING(@"智能恒温"),LANGUE_STRING(@"温度曲线"),LANGUE_STRING(@"定时器")];
}

- (void)setUI
{
    
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"智能设置");
    
    //创建tableView
    self.smartTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.smartTableView.delegate = self;
    self.smartTableView.dataSource =self;
    self.smartTableView.showsVerticalScrollIndicator = NO;
    self.smartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.smartTableView];
    
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


  SmartTableViewCell *cell = [[SmartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SmartCell"];
    NSString *title = self.titleArray[indexPath.row];
    if ([title isEqualToString:LANGUE_STRING(@"智能恒温")]) {
        [cell setTitle:LANGUE_STRING(@"智能恒温") andImageName:self.imageNameArray[indexPath.row] andSwitch:YES andInfoText:LANGUE_STRING(@"开启后，将室内温度恒温控制在设置的范围内。") andType:indexPath.row];
    }else if ([title isEqualToString:LANGUE_STRING(@"温度曲线")]){
        [cell setTitle:LANGUE_STRING(@"温度曲线") andImageName:self.imageNameArray[indexPath.row] andSwitch:YES andInfoText:LANGUE_STRING(@"开启后，空调将按曲线自动设置温度。") andType:indexPath.row];
    }else if ([title isEqualToString:LANGUE_STRING(@"定时器")]){
        [cell setTitle:LANGUE_STRING(@"定时器") andImageName:self.imageNameArray[indexPath.row] andSwitch:YES andInfoText:LANGUE_STRING(@"开启后，将室内温度恒温控制在设置的范围内。") andType:indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return WIDTH_FIT(204);
    }else{
        return WIDTH_FIT(348);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[TimersViewController new] animated:YES];
    }

}

@end
