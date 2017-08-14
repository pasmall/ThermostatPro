//
//  SearchDeviceViewController.m
//  ThermostatDevicePro
//
//  Created by lyric on 2017/6/7.
//  Copyright © 2017年 lyric. All rights reserved.
//

#import "SearchDeviceViewController.h"
#import "BorderTextField.h"
#import "RippleView.h"
#import "DeviceInfoEditViewController.h"



@interface SearchDeviceViewController ()<UITextFieldDelegate>{
    BOOL isSearch;
}

@property(nonatomic , strong)BorderTextField *ssidTextField;
@property(nonatomic , strong)BorderTextField *passwordTextField;
@property(nonatomic , strong)RippleView *rippleView;

@end

@implementation SearchDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册键盘事件
    [self registerForKeyboardNotifications];

    //刷新搜索按钮
    _rippleView.rippleButton.enabled = YES;
    self.passwordTextField.enabled = YES;
    [_rippleView.rippleButton setTitle:LANGUE_STRING(@"开始搜索") forState:UIControlStateNormal];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //移除键盘监听事件
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"搜索设备");
    //自定义返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回@3x"] style:UIBarButtonItemStyleDone target:self action:@selector(tapBack)];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(0, -WIDTH_FIT(54), 0, WIDTH_FIT(54));
    
    //SSID显示框
    NSString *ssidString = LANGUE_STRING(@"SSID");
    CGFloat ssidStringWidth = [ssidString widthForFont:[UIFont systemFontOfSize:PX_TO_PT(45)]];
    UILabel *ssidLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_FIT(81), HEIGHT_FIT(129) + CGRectGetMaxY(self.navigationController.navigationBar.frame), ssidStringWidth + 1, HEIGHT_FIT(150))];
    ssidLabel.textAlignment = NSTextAlignmentRight;
    ssidLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    ssidLabel.text = ssidString;
    [self.view addSubview:ssidLabel];
    self.ssidTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ssidLabel.frame) + WIDTH_FIT(15), ssidLabel.y, SCREEN_WIDTH - CGRectGetMaxX(ssidLabel.frame) - WIDTH_FIT(15) - WIDTH_FIT(81) , ssidLabel.height)];
    [self.view addSubview:self.ssidTextField];
    
    
    //SSID密码输入框
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ssidLabel.frame) + HEIGHT_FIT(36), ssidStringWidth + WIDTH_FIT(81), HEIGHT_FIT(150))];
    passwordLabel.textAlignment = NSTextAlignmentRight;
    passwordLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    passwordLabel.text = LANGUE_STRING(@"密码");
    [self.view addSubview:passwordLabel];
    self.passwordTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame) + WIDTH_FIT(15), passwordLabel.y, SCREEN_WIDTH - CGRectGetMaxX(passwordLabel.frame) - WIDTH_FIT(15) - WIDTH_FIT(81), passwordLabel.height)];
    self.passwordTextField.layer.borderColor = NAVIGATIONBAR_COLOR.CGColor;
    [self.passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    
    UIColor *attrsColor = COLOR_HEXSTRING(@"#808080");
    NSDictionary *attrs = @{NSForegroundColorAttributeName : attrsColor,NSFontAttributeName:[UIFont systemFontOfSize:PX_TO_PT(45)]};
    NSAttributedString *passwordTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"路由器WI-FI密码") attributes:attrs];
    self.passwordTextField.attributedPlaceholder = passwordTip;
    self.passwordTextField.returnKeyType = UIReturnKeyGoogle;
    self.passwordTextField.delegate  = self;
    [self.view addSubview:self.passwordTextField];
    
    
    //搜索按钮
    CGRect frame = CGRectMake(0, 0, HEIGHT_FIT(432), HEIGHT_FIT(432));
    frame.origin.x = (SCREEN_WIDTH - HEIGHT_FIT(432)) / 2  ;
    frame.origin.y = CGRectGetMaxY(passwordLabel.frame) + (SCREEN_HEIGHT - CGRectGetMaxY(passwordLabel.frame)) * 0.5 - HEIGHT_FIT(432) / 2;
    self.rippleView = [[RippleView alloc] initWithFrame:frame];
    [self.view addSubview:self.rippleView];
    
    @WeakObject(self);
    [_rippleView showWithRippleType:RippleTypeRing andcall:^{
        
        @StrongObject(self);
        [self tapSearchAction];
    }];
    
    //获取wifi名称
    self.ssidTextField.text = [[AppDataManager sharedAppDataManager] getWifiName];
    self.ssidTextField.userInteractionEnabled = NO;
    
    
}

- (void)tapBack
{
    if (isSearch) {
        UIAlertController *tipAlertController = [UIAlertController alertControllerWithTitle:nil  message:LANGUE_STRING(@"搜索过程大约需要3分钟，取消并重新开始？") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *OkAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"好的") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAlertAction = [UIAlertAction actionWithTitle:LANGUE_STRING(@"等待") style:UIAlertActionStyleCancel handler:nil];
        [tipAlertController addAction:OkAction];
        [tipAlertController addAction:cancelAlertAction];
        [self presentViewController:tipAlertController animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}


//取消输入
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//搜索事件处理
- (void)tapSearchAction
{
    isSearch = YES;
    [self.view endEditing:YES];
    
    self.passwordTextField.enabled = NO;
    _rippleView.times = 181;
    _rippleView.rippleButton.enabled = NO;
    [_rippleView addRippleLayer];
    _rippleView.rippleTimer = [NSTimer timerWithTimeInterval:1.0 target:_rippleView selector:@selector(addRippleLayer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_rippleView.rippleTimer forMode:NSRunLoopCommonModes];
    //模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_rippleView removeFromParentView];
        isSearch = NO;
        [self.navigationController pushViewController:[DeviceInfoEditViewController new] animated:YES];
        
    });
    
}


#pragma mark 注册键盘的监听
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:duration animations:^{
        self.rippleView.y = SCREEN_HEIGHT -keyboardSize.height - self.rippleView.height;
        _rippleView.y = self.rippleView.y;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.rippleView.centerY = CGRectGetMaxY(self.passwordTextField.frame) + (SCREEN_HEIGHT - CGRectGetMaxY(self.passwordTextField.frame)) * 0.5;
        _rippleView.y = self.rippleView.y;
    }];
}

#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField) {
        [self tapSearchAction];
    }
    
    return YES;
}




@end
