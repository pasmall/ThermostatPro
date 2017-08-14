//
//  TimersViewController.m
//  ThermostatDevicePro
//
//  Created by 聂自强 on 2017/6/11.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "TimersViewController.h"
#import "AddTimerViewController.h"
#import "TimerListTableViewCell.h"

@interface TimersViewController ()<UITableViewDelegate,UITableViewDataSource>{
    ThermostatDeviceModel *currentDevice;
    
}

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *actionView;
@property (nonatomic,strong)UITableView *timersTableView;


@end

@implementation TimersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}


- (void)setUI
{
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"定时器");
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, PX_TO_PT(132),  PX_TO_PT(132))];
    [rightButton setImage:[UIImage imageNamed:@"添加Timer@3x"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, PX_TO_PT(42), 0, -PX_TO_PT(42));
    [rightButton addTarget:self action:@selector(tapRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //创建设备tableView
    self.timersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.timersTableView.delegate = self;
    self.timersTableView.dataSource =self;
    self.timersTableView.showsVerticalScrollIndicator = NO;
    self.timersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.timersTableView];
    
    //不自动调整
    self.automaticallyAdjustsScrollViewInsets = NO;
    currentDevice = [[AppDataManager sharedAppDataManager] getCurrentDevice];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //模拟获取服务器定时器
    
//    self.currentTimers = currentDevice.currentTimers;

    if (currentDevice.currentTimers.count > 0) {
        self.bgView.hidden = YES;
        self.timersTableView.hidden = NO;
        [self.timersTableView reloadData];
    }else{
        self.bgView.hidden = NO;
        self.timersTableView.hidden = YES;
    }
    
    
    
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _bgView.backgroundColor = COLOR(242, 242, 242);
        [self.view addSubview:_bgView];
        
        NSString *ghStr = LANGUE_STRING(@"  规    划    时    间  ");
        UIFont *ghFont = [UIFont systemFontOfSize:HEIGHT_FIT(87)];
        CGFloat ghHeight = [ghStr heightForFont:ghFont width:SCREEN_WIDTH];
        CGFloat ghWidth = [ghStr widthForFont:ghFont];
        UILabel *ghLab = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(342), SCREEN_WIDTH, ghHeight)];
        ghLab.font = ghFont;
        ghLab.text = ghStr;
        ghLab.textAlignment = NSTextAlignmentCenter;

        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - ghWidth) /2 + ghWidth / 4 , 0, 2, ghLab.height * 0.7)];
        line1.backgroundColor = COLOR(168, 168, 168);
        line1.centerY = ghLab.height /2;
        [ghLab addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - ghWidth) /2 + ghWidth / 2  , 0, 2, ghLab.height * 0.7)];
        line2.backgroundColor = COLOR(168, 168, 168);
        line2.centerY = ghLab.height /2;
        [ghLab addSubview:line2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - ghWidth) /2 + ghWidth * 3 /4 , 0, 2, ghLab.height * 0.7)];
        line3.backgroundColor = COLOR(168, 168, 168);
        line3.centerY = ghLab.height /2;
        [ghLab addSubview:line3];
        
        NSString *sxStr = LANGUE_STRING(@"随心所欲");
        UIFont *sxFont = [UIFont systemFontOfSize:HEIGHT_FIT(69)];
        CGFloat sxHeight = [sxStr heightForFont:sxFont width:SCREEN_WIDTH];
        UILabel *sxLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ghLab.frame) + HEIGHT_FIT(87), SCREEN_WIDTH, sxHeight)];
        sxLab.font = sxFont;
        sxLab.text = sxStr;
        sxLab.textColor = COLOR(97, 97, 97);
        sxLab.textAlignment = NSTextAlignmentCenter;
        
        [_bgView addSubview:ghLab];
        [_bgView addSubview:sxLab];
        
        self.actionView.y = SCREEN_HEIGHT - HEIGHT_FIT(843) - 64;
        [_bgView addSubview:_actionView];
        
        UILabel *addLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.actionView.y - HEIGHT_FIT(147) -HEIGHT_FIT(60), SCREEN_WIDTH, HEIGHT_FIT(60))];
        addLab.textColor = [UIColor blackColor];
        addLab.font = [UIFont systemFontOfSize:HEIGHT_FIT(63)];
        addLab.textAlignment = NSTextAlignmentCenter;
        addLab.text = LANGUE_STRING(@"添加您的定时");
        [_bgView addSubview:addLab];
        
        _bgView.hidden = YES;
    }

    
    return _bgView;
}

- (UIView *)actionView
{
    if (!_actionView) {
        _actionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_FIT(483))];
        _actionView.backgroundColor = [UIColor whiteColor];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEIGHT_FIT(3))];
        line1.backgroundColor = COLOR(220, 220, 220);
        [_actionView addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _actionView.height -HEIGHT_FIT(3), SCREEN_WIDTH, HEIGHT_FIT(3))];
        line2.backgroundColor = COLOR(220, 220, 220);
        [_actionView addSubview:line2];
        
        UIView *action1 = [self actionButtonAndTitle:LANGUE_STRING(@"开关定时") andImgaeNamed:@"定时首页定时默认3@"];
        [_actionView addSubview:action1];
        
        UIView *action2 = [self actionButtonAndTitle:LANGUE_STRING(@"阶段定时") andImgaeNamed:@"定时首页阶段定时默认3@"];
        action2.x = SCREEN_WIDTH / 2;
        [_actionView addSubview:action2];
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - HEIGHT_FIT(1.5), 0, HEIGHT_FIT(3), HEIGHT_FIT(204))];
        line3.centerY = _actionView.height /2;
        line3.backgroundColor = COLOR(220, 220, 220);
        [_actionView addSubview:line3];
        
        //添加事件
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAddSwitchTimer)];
        [action1 addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAddTimer)];
        [action2 addGestureRecognizer:tap2];
    
    }
    
    return _actionView;
}

- (UIView *)actionButtonAndTitle:(NSString *)title andImgaeNamed:(NSString *)name
{

    UIView *actionButton = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH /2, HEIGHT_FIT(483))];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.width = HEIGHT_FIT(186);
    imageView.height = HEIGHT_FIT(186);
    imageView.centerX = actionButton.width * 0.5;
    imageView.y = imageView.height / 2;
    [actionButton addSubview:imageView];
    
    UILabel *titLab = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(imageView.frame) + HEIGHT_FIT(75), actionButton.width, 24)];
    titLab.text = title;
    titLab.height = [title heightForFont:[UIFont systemFontOfSize:HEIGHT_FIT(48)] width:actionButton.width];
    titLab.textColor = [UIColor blackColor];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:HEIGHT_FIT(48)];
    [actionButton addSubview:titLab];
    

    return actionButton;
}

#pragma mark Action
- (void)tapAddSwitchTimer
{
    AddTimerViewController *vc = [AddTimerViewController new];
    vc.viewType = 0;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapAddTimer
{
    AddTimerViewController *vc = [AddTimerViewController new];
    vc.viewType = 1;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)tapRightAction
{
    UIAlertController *addDeviceAlertController = [UIAlertController alertControllerWithTitle:nil  message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *addNewDeviceAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"开关定时") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AddTimerViewController *vc = [AddTimerViewController new];
        vc.viewType = 0;
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    UIAlertAction *haveDeviceAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"阶段定时") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AddTimerViewController *vc = [AddTimerViewController new];
        vc.viewType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"取消") style:UIAlertActionStyleCancel handler:nil];
    [addDeviceAlertController addAction:addNewDeviceAlertAction];
    [addDeviceAlertController addAction:haveDeviceAlertAction];
    [addDeviceAlertController addAction:cancelAlertAction];
    [self presentViewController:addDeviceAlertController animated:YES completion:nil];

}

#pragma mark UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return currentDevice.currentTimers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"timer";
    TimerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TimerListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.timer = currentDevice.currentTimers[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WIDTH_FIT(240);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeviceTimerModel *currentTimer = currentDevice.currentTimers[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:LANGUE_STRING(@"删除") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [currentDevice.currentTimers removeObject:currentTimer];
        [currentDevice deleteDeviceTimerWithID:currentTimer.timerID];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        if (currentDevice.currentTimers.count == 0) {
            self.bgView.hidden = NO;
            self.timersTableView.hidden = YES;
        }
        
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LANGUE_STRING(@"编辑") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        AddTimerViewController *vc = [AddTimerViewController new];
        vc.timerID = currentTimer.timerID;
        if (currentTimer.timerType == DeviceTimerModelTypeStage) {
            vc.viewType = 1;
        }else{
            vc.viewType = 0;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
    editAction.backgroundColor = COLOR(204, 204, 204);
    return @[deleteAction, editAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}




@end
