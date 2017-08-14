//
//  DeviceOperationViewController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/8.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "DeviceOperationViewController.h"
#import "ZQPickerView.h"
#import "RoundShowView.h"
#import "MenuView.h"
#import "UIDevice+Platform.h"

#define BUTTON_COUNT 6
#define ROW_COUNT 3

typedef enum {
    DeviceActionTypeTime = 11,
    DeviceActionTypeSwitch,
    DeviceActionTypeScene,
    DeviceActionTypeLock,
    DeviceActionTypeModel,
    DeviceActionTypeWind,
    
    
} DeviceActionType;

@interface DeviceOperationViewController ()<ZQPickerViewDelegate>{

    ThermostatDeviceModel *currentDevice;
    ZQPickerView *picker;
    UIView *bgView;
}

@property (nonatomic , strong)UIImageView *lockImageView;
@property (nonatomic , strong)UIImageView *sceneImageView;
@property (nonatomic , strong)UIImageView *windImageView;
@property (nonatomic , strong)RoundShowView *roundView;

@property(nonatomic , strong)NSMutableArray *operateButtons;//储存设备的操作按钮




@end

@implementation DeviceOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //模拟环境温度和湿度
    currentDevice = [[AppDataManager sharedAppDataManager] getCurrentDevice];
    currentDevice.ambientTemp = arc4random() % 40;
    currentDevice.ambientHumidity = arc4random() % 90;
    
    [self setUI];
    
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    //导航设置
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(132),  PX_TO_PT(132))];
    [leftButton setImage:[UIImage imageNamed:@"返回@3x"] forState:UIControlStateNormal];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -PX_TO_PT(42), 0, PX_TO_PT(42));
    [leftButton addTarget:self action:@selector(tapBackButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lefttItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = lefttItem;

    self.navigationItem.title = currentDevice.deviceName;
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(132),  PX_TO_PT(132))];
    [rightButton setImage:[UIImage imageNamed:@"三点@3x"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"三点@3x"] forState:UIControlStateHighlighted];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, PX_TO_PT(42), 0, -PX_TO_PT(42));
    [rightButton addTarget:self action:@selector(tapRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //不自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //控制面板显示页面
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, HEIGHT_FIT(1095))];
    bgView.backgroundColor = NAVIGATIONBAR_COLOR;
    [self.view addSubview:bgView];
    
    _lockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH_FIT(121), bgView.height - WIDTH_FIT(123), WIDTH_FIT(90), WIDTH_FIT(90))];
    [bgView addSubview:_lockImageView];
    
    _sceneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, _lockImageView.y, WIDTH_FIT(90), WIDTH_FIT(90))];
    _sceneImageView.centerX = SCREEN_WIDTH * 0.5;
    [bgView addSubview:_sceneImageView];
    
    _windImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -  WIDTH_FIT(121) - HEIGHT_FIT(72), _lockImageView.y, WIDTH_FIT(90), WIDTH_FIT(90))];
    [bgView addSubview:_windImageView];
    
    
    _roundView = [[RoundShowView alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(57), HEIGHT_FIT(834), HEIGHT_FIT(834))];
    _roundView.centerX = SCREEN_WIDTH * 0.5;
    [_roundView showWaitingView:1.2 andHumidity:60];
    [bgView addSubview:_roundView];
    
    //温度横向选择
    picker = [[ZQPickerView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH/2, CGRectGetMaxY(bgView.frame), SCREEN_WIDTH * 2,  HEIGHT_FIT(270))];
    picker.delegate = self;
    [self.view addSubview:picker];
    
    if ([UIDevice isScreenIPHONE4]) {
        [self setOperateUIIphone4];
    }else{
        [self setOperateUINormal];
    }

    
    [self updateUIInfo];
    
    //数据接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotif) name:@"UpateUIAboutDevice" object:nil];
}

- (void)receiveNotif
{
    [self updateUIInfo];
    
}

//操作面板
- (void)setOperateUINormal
{
    //操作按钮
    CGFloat viewHeight = SCREEN_HEIGHT - 64 - 49 - bgView.height - HEIGHT_FIT(270);
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + HEIGHT_FIT(270), SCREEN_WIDTH, PX_TO_PT(3))];
    line1.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + HEIGHT_FIT(270) + viewHeight / 2, SCREEN_WIDTH, PX_TO_PT(3))];
    line2.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [self.view addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /3, CGRectGetMaxY(bgView.frame) + HEIGHT_FIT(270), PX_TO_PT(3),viewHeight)];
    line3.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [self.view addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2/3, CGRectGetMaxY(bgView.frame) + HEIGHT_FIT(270), PX_TO_PT(3),viewHeight)];
    line4.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [self.view addSubview:line4];
    
    NSArray *imagesArray = @[@"on@3x",@"开关@3x",@"情景@3x",@"锁@3x",@"模式@3x",@"风速@3x"];
    self.operateButtons = [NSMutableArray array];
    //2.循环创建
    for (int i = 0; i < BUTTON_COUNT; i ++) {
        int row = i / ROW_COUNT ;
        UIButton *operateButton = [[UIButton alloc]initWithFrame:CGRectMake((i % ROW_COUNT) * (SCREEN_WIDTH / ROW_COUNT), CGRectGetMaxY(bgView.frame) + HEIGHT_FIT(270)  + row * (viewHeight / 2), SCREEN_WIDTH / ROW_COUNT, viewHeight / 2)];
        
        [operateButton setImage:[[UIImage imageNamed:imagesArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        operateButton.tag = i + 11;
        [operateButton addTarget:self action:@selector(tapOperateAction:) forControlEvents:UIControlEventTouchUpInside];
        operateButton.contentEdgeInsets = UIEdgeInsetsMake((operateButton.height - HEIGHT_FIT(165))/2, (operateButton.width - HEIGHT_FIT(165))/2, (operateButton.height - HEIGHT_FIT(165))/2, (operateButton.width - HEIGHT_FIT(165))/2);
        operateButton.tintColor = NAVIGATIONBAR_COLOR;
        [self.view addSubview:operateButton];
        [self.operateButtons addObject:operateButton];
    }

}

- (void)setOperateUIIphone4
{
    //操作按钮
    CGFloat viewHeight = SCREEN_HEIGHT - 64 - 49 - bgView.height - HEIGHT_FIT(270);
    
    UIScrollView *operateView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame) + HEIGHT_FIT(270), SCREEN_WIDTH, viewHeight)];
    operateView.contentSize = CGSizeMake(SCREEN_WIDTH, viewHeight * 2);
    [self.view addSubview:operateView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PX_TO_PT(3))];
    line1.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [operateView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, viewHeight, SCREEN_WIDTH, PX_TO_PT(3))];
    line2.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [operateView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /3, 0, PX_TO_PT(3),viewHeight*2)];
    line3.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [operateView addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2/3, 0, PX_TO_PT(3),viewHeight*2)];
    line4.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.1];
    [operateView addSubview:line4];
    
    NSArray *imagesArray = @[@"on@3x",@"开关@3x",@"情景@3x",@"锁@3x",@"模式@3x",@"风速@3x"];
    self.operateButtons = [NSMutableArray array];
    //2.循环创建
    for (int i = 0; i < BUTTON_COUNT; i ++) {
        int row = i / ROW_COUNT ;
        UIButton *operateButton = [[UIButton alloc]initWithFrame:CGRectMake((i % ROW_COUNT) * (SCREEN_WIDTH / ROW_COUNT), row * viewHeight, SCREEN_WIDTH / ROW_COUNT, viewHeight)];
        
        [operateButton setImage:[[UIImage imageNamed:imagesArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        operateButton.tag = i + 11;
        [operateButton addTarget:self action:@selector(tapOperateAction:) forControlEvents:UIControlEventTouchUpInside];
        operateButton.contentEdgeInsets = UIEdgeInsetsMake((operateButton.height - 56)/2, (operateButton.width - 56)/2, (operateButton.height - 56)/2, (operateButton.width - 56)/2);
        operateButton.tintColor = NAVIGATIONBAR_COLOR;
        [operateView addSubview:operateButton];
        [self.operateButtons addObject:operateButton];
    }
    
    //添加下滑的提示箭头
    UIImageView *lowImageView = [[UIImageView alloc]init];
    lowImageView.frame = CGRectMake(0, SCREEN_HEIGHT - 49 -16, 16, 10);
    lowImageView.centerX = SCREEN_WIDTH /2;
    lowImageView.image = [UIImage imageNamed:@"63下拉显示"];
    [self.view addSubview:lowImageView];
}


//更新控件的状态
- (void)updateUIInfo
{
    [self updateRoundView];
    [self updateLockImageView];
    [self updateSceneImageView];
    [self updateWindImageView];
    [self updateZQPickerView];
    [self updateButtons];
    [self updateTimerButton];
    
}

#pragma mark 控件信息更新
//锁状态
- (void)updateLockImageView
{
    switch (currentDevice.deviceLockMode) {
        case DeviceLockModelTypeNo:
            [_lockImageView setImage:[UIImage imageNamed:@"锁(小)@3x"]];
            _lockImageView.alpha = 0.5;
            
            break;
        case DeviceLockModelTypeLimtOnAndOff:
            [_lockImageView setImage:[UIImage imageNamed:@"童锁开关除外@3x"]];
            _lockImageView.alpha = 1;
            
            break;
        case DeviceLockModelTypeLimtAll:
            [_lockImageView setImage:[UIImage imageNamed:@"锁(小)@3x"]];
            _lockImageView.alpha = 1;
            
            break;
            
        default:
            break;
    }

}

//情景图标
- (void)updateSceneImageView
{
    switch (currentDevice.deviceSceneMode) {
        case DeviceSceneModelTypeCTemp:
            [_sceneImageView setImage:[UIImage imageNamed:@"情景_恒温@3x"]];
            break;
        case DeviceSceneModelTypeEnergySaving:
            [_sceneImageView setImage:[UIImage imageNamed:@"情景_节能@3x"]];
            break;
        case DeviceSceneModelTypeLeaveHome:
            [_sceneImageView setImage:[UIImage imageNamed:@"情景_离家@3x"]];
            break;
            
        default:
            break;
    }
    
    switch (currentDevice.deviceState) {
        case DeviceStateTypeOff:
            _sceneImageView.alpha = 0.5;
            break;
        case DeviceStateTypeOn:
            _sceneImageView.alpha = 1;
            break;
            
        default:
            break;
    }
}

//风速
- (void)updateWindImageView
{
    switch (currentDevice.deviceWindMode) {
        case DeviceWindModelTypeLow:
            [_windImageView setImage:[UIImage imageNamed:@"自动1@3x"]];
            break;
        case DeviceWindModelTypeMiddle:
            [_windImageView setImage:[UIImage imageNamed:@"自动2@3x"]];
            break;
        case DeviceWindModelTypeHigh:
            [_windImageView setImage:[UIImage imageNamed:@"自动3@3x"]];
            break;
            
        default:
            break;
    }
    
    switch (currentDevice.deviceState) {
        case DeviceStateTypeOff:
            _windImageView.alpha = 0.5;
            break;
        case DeviceStateTypeOn:
            _windImageView.alpha = 1;
            break;
            
        default:
            break;
    }
    

}

//温度选择器
- (void)updateZQPickerView
{
    picker.scrollItem = currentDevice.deviceTemp;
    
    switch (currentDevice.deviceState) {
        case DeviceStateTypeOff:
            picker.userInteractionEnabled = NO;
            picker.textColor = [UIColor grayColor];
            break;
        case DeviceStateTypeOn:
            picker.userInteractionEnabled = YES;
            picker.textColor = NAVIGATIONBAR_COLOR;
            break;
            
        default:
            break;
    }
    
}

//定时按钮
- (void)updateTimerButton
{
    
    switch (currentDevice.deviceState) {
        case DeviceStateTypeOff:
            [self.operateButtons[0] setImage:[[UIImage imageNamed:@"on@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            break;
        case DeviceStateTypeOn:
            [self.operateButtons[0] setImage:[[UIImage imageNamed:@"off@3x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

//情景按钮 & 锁按钮 & mode按钮 & 风速按钮
- (void)updateButtons
{
    switch (currentDevice.deviceState) {
        case DeviceStateTypeOff:
            for (int idx = 2; idx < BUTTON_COUNT; idx ++) {
                if (idx == 3) {
                    continue;
                }
                UIButton *button = self.operateButtons[idx];
                button.tintColor = [UIColor grayColor];
                button.enabled = NO;
            }
            break;
        case DeviceStateTypeOn:
            for (int idx = 2; idx < BUTTON_COUNT; idx ++) {
                if (idx == 3) {
                    continue;
                }
                UIButton *button = self.operateButtons[idx];
                button.tintColor = NAVIGATIONBAR_COLOR;
                button.enabled = YES;
            }
            break;
            
        default:
            break;
    }
    
}

//更新圆形图
- (void)updateRoundView
{
    NSTimeInterval time = [currentDevice.deviceTimer  timeIntervalSinceNow];
    if (time > 0) {
        @WeakObject(self);
        [_roundView showTimeViewWithTime:time andFinish:^{
            [selfWeak updateUIInfo];
        }];
    }else{
        [_roundView removeTimer];
    }
    
    switch (currentDevice.deviceState) {
        case DeviceStateTypeOff:
            [_roundView showWaitingView:currentDevice.ambientTemp andHumidity:currentDevice.ambientHumidity];
            break;
        case DeviceStateTypeOn:
            [_roundView showViewWithMode:currentDevice.deviceMode andAmbient:currentDevice.ambientTemp andHumidity:currentDevice.ambientHumidity andTemp:currentDevice.deviceTemp];
            break;
            
        default:
            break;
    }

}

#pragma mark Action
//返回主页面
- (void)tapBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击右边按钮
- (void)tapRightAction
{
    MenuView *menu = [MenuView menuWithArray:@[@{@"image":@"24小时温度曲线@3x",@"title":LANGUE_STRING(@"24小时曲线")}] andcall:^(NSInteger choiceIndex) {
        NSLog(@"%ld",choiceIndex);
    }];
    
    [menu showMenuWithPoint:CGPointMake(SCREEN_WIDTH - WIDTH_FIT(534) - PX_TO_PT(132) /2, 64) andAnimate:YES];
}

//操作按钮点击
- (void)tapOperateAction:(UIButton *)operateButton
{
    //按钮点击的反馈
    if ([AppDataManager sharedAppDataManager].shakeStatue & [AppDataManager sharedAppDataManager].soundState) {
        //声音+震动
        [[AppDataManager sharedAppDataManager] palySoundAndShake];
    }else{
        //声音
        if ([AppDataManager sharedAppDataManager].soundState) {
            [[AppDataManager sharedAppDataManager] palySound];
        }
        //震动
        if ([AppDataManager sharedAppDataManager].shakeStatue) {
            [[AppDataManager sharedAppDataManager] palyShake];
        }
    }
    
    switch (operateButton.tag) {
        case DeviceActionTypeTime:
            [self tapTimerAction];
            break;
        case DeviceActionTypeSwitch:
            [self tapSwitchAction];
            break;
        case DeviceActionTypeScene:
            [self tapSceneAction];
            break;
        case DeviceActionTypeLock:
            [self tapLockAction];
            break;
        case DeviceActionTypeModel:
            [self tapModeAction];
            break;
        case DeviceActionTypeWind:
            [self tapWindAction];
            break;
            
        default:
            break;
    }


}

//设备开关
- (void)tapSwitchAction
{
    
    [currentDevice tapDeviceOnOrOffAction];

    [self updateRoundView];
    [self updateSceneImageView];
    [self updateWindImageView];
    [self updateZQPickerView];
    [self updateButtons];
    [self updateTimerButton];

}

//情景模式
- (void)tapSceneAction
{
    [currentDevice tapDeviceSceneAction];
    [self updateSceneImageView];
}

//童锁
- (void)tapLockAction
{
    [currentDevice tapDeviceLockAction];
    [self updateLockImageView];
}

//风速
- (void)tapWindAction
{
    [currentDevice tapDeviceWindModelAction];
    [self updateWindImageView];
}

//model
- (void)tapModeAction
{
    [currentDevice tapDeviceModelAction];
    [_roundView showViewWithMode:currentDevice.deviceMode andAmbient:currentDevice.ambientTemp andHumidity:currentDevice.ambientHumidity andTemp:currentDevice.deviceTemp];
}

//定时
- (void)tapTimerAction
{
    @WeakObject(_roundView);
    @WeakObject(self);
    [currentDevice tapDeviceTimeActionBlock:^{
        NSTimeInterval time = [currentDevice.deviceTimer  timeIntervalSinceNow];
        [_roundViewWeak showTimeViewWithTime:time andFinish:^{
            [selfWeak updateUIInfo];
        }];
    }];
    
    
}

#pragma mark PickerDelegate
- (void)didSelectValue:(float)value
{
    [currentDevice changeTempValue:value];
    [_roundView updateTemp:value];
}







@end
