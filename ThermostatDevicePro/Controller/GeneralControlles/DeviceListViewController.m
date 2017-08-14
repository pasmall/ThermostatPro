//
//  DeviceListViewController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/7.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "DeviceListViewController.h"
#import "ZQLeftSlipManager.h"
#import "ZYBannerView.h"
#import "DeviceTableViewCell.h"
#import "SheetEditDeviceView.h"
#import "LeftForAboutViewController.h"
#import "SearchDeviceViewController.h"
#import "EditNameViewController.h"
#import "EditPasswordViewController.h"
#import "AboutWeViewController.h"
#import "SettingDeviceViewController.h"
#import "AddDeviceViewController.h"
#import "DeviceTabBarController.h"

@interface DeviceListViewController ()<UITableViewDataSource,UITableViewDelegate,ZYBannerViewDataSource,DeviceTableViewCellDelegate,LeftForAboutViewControllerDelegate>
    
@property (nonatomic , strong)NSArray *bannerImageArray;
@property (nonatomic , strong)UITableView *deviceListTableView;
@property (nonatomic , strong)UIView *backView;
@property (nonatomic , strong)UILabel *addTitleLabel;//搜索设备字样（引用目的，中英切换时，更新操作）

@end

@implementation DeviceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setUI];
    [self getData];
    
    //设置侧滑控制器和主控制器
    LeftForAboutViewController *leftViewController = [[LeftForAboutViewController alloc]init];
    leftViewController.delegate = self;
    [[ZQLeftSlipManager sharedManager] setLeftViewController:leftViewController coverViewController:self];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //判断中间的添加设备按钮是否显示
    if ( [AppDataManager sharedAppDataManager].currentDevices.count) {
        self.backView.hidden = YES;
    }else{
        self.backView.hidden = NO;
        self.addTitleLabel.text = LANGUE_STRING(@"搜索设备");
    }
    [self.deviceListTableView reloadData];
        
    self.navigationItem.title = LANGUE_STRING(@"温控器");
    
}
    
    
- (void)setUI
{
        
    //导航栏设置
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(132),  PX_TO_PT(132))];
    [leftButton setImage:[UIImage imageNamed:@"更多@3x"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(36), 0, PX_TO_PT(36));
    [leftButton addTarget:self action:@selector(tapLeftSlip) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lefttItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = lefttItem;
        
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(132),  PX_TO_PT(132))];
    [rightButton setImage:[UIImage imageNamed:@"添加@3x"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"添加@3x"] forState:UIControlStateHighlighted];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, PX_TO_PT(42), 0, -PX_TO_PT(42));
    rightButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [rightButton addTarget:self action:@selector(tapRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
        
        //创建HeaderView
    ZYBannerView  *banner = [[ZYBannerView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_WIDTH * 0.5)];
    banner.dataSource = self;
    banner.shouldLoop = YES;
    banner.autoScroll = YES;
        
        //创建设备tableView
    self.deviceListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStylePlain];
    self.deviceListTableView.delegate = self;
    self.deviceListTableView.dataSource =self;
    self.deviceListTableView.showsVerticalScrollIndicator = NO;
    self.deviceListTableView.tableHeaderView = banner;
    self.deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.deviceListTableView];
        
    //不自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //数据接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotif) name:@"UpateUIAboutDevice" object:nil];
        
}

- (void)receiveNotif
{
    [self.deviceListTableView reloadData];
    
}
    
//设置数据
- (void)getData
{
    self.bannerImageArray = @[@"banner_default@3x",@"banner2@3x",@"banner3@3x"];
}
    
#pragma mark 控件懒加载
- (UIView *)backView
{
    if (!_backView) {
        _backView = [UIView new];
        _backView.width = HEIGHT_FIT(150) * 2;
        _backView.height = HEIGHT_FIT(150) * 2;
        _backView.centerX = self.deviceListTableView.centerX;
        _backView.centerY = (SCREEN_HEIGHT - SCREEN_WIDTH * 0.5 - 64) * 0.5 + SCREEN_WIDTH * 0.5;
        
        UIImageView *addImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"搜索设备"]];
        addImageView.contentMode = UIViewContentModeScaleAspectFit;
        addImageView.width = HEIGHT_FIT(150);
        addImageView.height = HEIGHT_FIT(150);
        addImageView.centerX = _backView.width * 0.5;
        [_backView addSubview:addImageView];
        
        self.addTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(165), _backView.width, 24)];
        _addTitleLabel.text = LANGUE_STRING(@"搜索设备");
        _addTitleLabel.textColor = COLOR(60, 60, 60);
        _addTitleLabel.textAlignment = NSTextAlignmentCenter;
        _addTitleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
        [_backView addSubview:_addTitleLabel];
        
        //添加事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchDevice)];
        [_backView addGestureRecognizer:tap];
        
        [self.deviceListTableView addSubview:_backView];
    }
    return _backView;
}


#pragma mark Action

//侧滑事件
- (void)tapLeftSlip
{
    
    if ([ZQLeftSlipManager sharedManager].showLeft) {
        [[ZQLeftSlipManager sharedManager] dismissLeftView];
    }else{
        [[ZQLeftSlipManager sharedManager] showLeftView];
    }
    
    
}

//添加设备
- (void)tapRightAction
{
    
    UIAlertController *addDeviceAlertController = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addNewDeviceAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"新设备") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        if ([[[AppDataStone shareAppDataStone] getWifiName] isEqualToString:@"Not Found"]) {
        //            [MBProgressHUD showTextTip:LANGUE_STRING(@"未连接到WI-IF,请检查手机局域网设置")];
        //            return;
        //        }
        [self.navigationController pushViewController:[SearchDeviceViewController new] animated:YES];
    }];
    UIAlertAction *haveDeviceAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"已配置过的设备") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[AddDeviceViewController new] animated:YES];
    }];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [addDeviceAlertController addAction:addNewDeviceAlertAction];
    [addDeviceAlertController addAction:haveDeviceAlertAction];
    [addDeviceAlertController addAction:cancelAlertAction];
    [self presentViewController:addDeviceAlertController animated:YES completion:nil];
    
}

//搜索设备
- (void)searchDevice
{
    if ([[[AppDataManager sharedAppDataManager] getWifiName] isEqualToString:@"Not Found"]) {
        [MBProgressHUD showTextTip: LANGUE_STRING(@"未连接到WI-IF,请检查手机局域网设置")];
        return;
    }
    
    [self.navigationController pushViewController:[SearchDeviceViewController new] animated:YES];
}

#pragma mark ZYBannerViewDataSource
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    return self.bannerImageArray.count;
}
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    
    NSString *imageName = self.bannerImageArray[index];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = banner.bounds;
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleToFill;
    return imageView;
    
}

#pragma mark UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [AppDataManager sharedAppDataManager].currentDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"devices";
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.thermostatModel = [AppDataManager sharedAppDataManager].currentDevices[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PX_TO_PT(231);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThermostatDeviceModel *deviceObject = [AppDataManager sharedAppDataManager].currentDevices[indexPath.row];
    if (deviceObject.deviceNetState == DeviceNetStateTypeOn) {
        [AppDataManager sharedAppDataManager].currentDeviceSerialID = deviceObject.deviceSerialID;
        
        //进入设备控制
        [self presentViewController:[DeviceTabBarController new] animated:YES completion:nil];
    }
}

#pragma mark HotWindDeviceTableViewCellDelegate
- (void)tapEditButtonWithDeviceModel:(ThermostatDeviceModel *)device
{
    
    @WeakObject(self);
    SheetEditDeviceView *editView = [SheetEditDeviceView initWithThermostatDevice:device andcall:^(SheetEditDeviceView *editView, TapViewEditType choiceType) {
        
        @StrongObject(self);
        [editView dismissEditDeviceView];
        switch (choiceType) {
            case TapViewEditTypeName:{//修改昵称
                
                [AppDataManager sharedAppDataManager].currentDeviceSerialID = device.deviceSerialID;
                [self.navigationController pushViewController:[EditNameViewController new] animated:YES];
            }
            break;
            case TapViewEditTypePassword:{//修改密码
                
                [AppDataManager sharedAppDataManager].currentDeviceSerialID = device.deviceSerialID;
                [self.navigationController pushViewController:[EditPasswordViewController new] animated:YES];
            }
            break;
            case TapViewEditTypeDelete:{ //删除设备
                
                UIAlertController *tipAlertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@%lld",LANGUE_STRING(@"删除设备"),(long long)device.deviceSerialID]  message:LANGUE_STRING(@"删除设备后，所有相关联动都会受到影响，该设备会恢复到初始值") preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *OkAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    NSUInteger objectIndex = [[AppDataManager sharedAppDataManager].currentDevices indexOfObject:device];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:objectIndex inSection:0];
                    
                    [[AppDataManager sharedAppDataManager] deleteThermostatDevice:device.deviceSerialID];
                    
                    [self.deviceListTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

                    if ( [AppDataManager sharedAppDataManager].currentDevices.count) {
                        self.backView.hidden = YES;
                    }else{
                        self.backView.hidden = NO;
                    }
                }];
                UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"取消") style:UIAlertActionStyleCancel handler:nil];
                [tipAlertController addAction:OkAction];
                [tipAlertController addAction:cancelAlertAction];
                [self presentViewController:tipAlertController animated:YES completion:nil];
            }
            break;
            
            default:
            break;
        }
        
    }];
    [editView showEditDeviceView];
}

#pragma mark LeftForAboutViewControllerDelegate
- (void)didSelectedToPushViewController:(LeftViewActionType )type
{
    switch (type) {
        case LeftViewActionTypeSetting:
        [self.navigationController pushViewController:[SettingDeviceViewController new] animated:YES];
        break;
        case LeftViewActionTypeAbout:
        [self.navigationController pushViewController:[AboutWeViewController new] animated:YES];
        break;
        
        default:
        break;
    }
    
}



@end
