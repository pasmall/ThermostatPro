//
//  SettingDeviceViewController.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "SettingDeviceViewController.h"
#import "SettingDeviceTableViewCell.h"
#import "EnumPickerView.h"

@interface SettingDeviceViewController ()<UITableViewDelegate , UITableViewDataSource , SettingDeviceTableViewCellDelegate>

@property (nonatomic , strong)UITableView *infoTableView;
@property (nonatomic , strong)NSArray *imageNameArray;

@end

@implementation SettingDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getData];
    [self setUI];
}

- (void)getData
{
    self.imageNameArray = @[@"澳柯玛声音@3x",@"澳柯玛震动@3x",@"澳柯玛语言@3x"];
}

- (void)setUI
{
    
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"系统设置");
    
    //创建tableView
    self.infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource =self;
    self.infoTableView.showsVerticalScrollIndicator = NO;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.infoTableView];
    
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.imageNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"device_setting";
    SettingDeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SettingDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case SettingCellTypeSound:{
            [cell setImageName:_imageNameArray[indexPath.row] andSwitchValue:[AppDataManager sharedAppDataManager].soundState];
            cell.cellType = SettingCellTypeSound;
        }
            break;
        case SettingCellTypeShake:{
            [cell setImageName:_imageNameArray[indexPath.row] andSwitchValue:[AppDataManager sharedAppDataManager].shakeStatue];
            cell.cellType = SettingCellTypeShake;
        }
            break;
        case SettingCellTypeLangue:{
            [cell setImageName:_imageNameArray[indexPath.row] andLangueType:[AppDataManager sharedAppDataManager].currentLangueType];
            cell.cellType = SettingCellTypeLangue;
        }
            break;
            
        default:
            break;
    }

    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_FIT(231);
}

#pragma mark SettingDeviceTableViewCellDelegate
- (void)tapActionWithCell:(SettingDeviceTableViewCell *)cell
{
    switch (cell.cellType) {
        case SettingCellTypeSound:{ //点击声音开关按钮
            [AppDataManager sharedAppDataManager].soundState = ![AppDataManager sharedAppDataManager].soundState;
            cell.switchButton.on = [AppDataManager sharedAppDataManager].soundState;
        }
            break;
        case SettingCellTypeShake:{//点击震动开关按钮
            [AppDataManager sharedAppDataManager].shakeStatue = ![AppDataManager sharedAppDataManager].shakeStatue;
            cell.switchButton.on = [AppDataManager sharedAppDataManager].shakeStatue;
        }
            break;
        case SettingCellTypeLangue:{ //点击选择语言按钮
            
            NSArray *titles = @[@[@"简体中文",@"English"]];

            EnumPickerView *picker = [EnumPickerView sheetStringPickerWithTitleStrings:titles andHeaderTitle:LANGUE_STRING(@"语言") andSubObjectCom:[AppDataManager sharedAppDataManager].currentLangueType andSubObjectRow:0 andPickerType:PickerViewTypeHaveImage andcall:^(NSInteger com, NSInteger row) {
                [AppDataManager sharedAppDataManager].currentLangueType = com;
                [cell setImageName:nil andLangueType:[AppDataManager sharedAppDataManager].currentLangueType];
                self.navigationItem.title = LANGUE_STRING(@"系统设置");
            }];
            [picker showPicker];
 
        }
            break;
            
        default:
            break;
    }

}


@end
