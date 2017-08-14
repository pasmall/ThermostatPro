//
//  DeviceInfoEditViewController.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "DeviceInfoEditViewController.h"
#import "BorderTextField.h"
#import "ThermostatDeviceModel.h"


@interface DeviceInfoEditViewController ()<UITextFieldDelegate>{
    long long serialID;
}

@property(nonatomic , strong)BorderTextField *serialIDTextField;
@property(nonatomic , strong)BorderTextField *nameTextField;
@property(nonatomic , strong)BorderTextField *passwordTextField;
@property(nonatomic , strong)UIButton *okButton;


@end

@implementation DeviceInfoEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI
{
 
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"设备信息");
    
    //序列号显示框
    NSString *ssidString = LANGUE_STRING(@"密    码");
    CGFloat ssidStringWidth = [ssidString widthForFont:[UIFont systemFontOfSize:PX_TO_PT(45)]];
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_FIT(81), HEIGHT_FIT(129) + CGRectGetMaxY(self.navigationController.navigationBar.frame), ssidStringWidth + 2, HEIGHT_FIT(150))];
    idLabel.textAlignment = NSTextAlignmentRight;
    idLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    idLabel.text = LANGUE_STRING(@"序列号");
    [self.view addSubview:idLabel];
    self.serialIDTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(idLabel.frame) + WIDTH_FIT(15), idLabel.y, SCREEN_WIDTH - CGRectGetMaxX(idLabel.frame) - WIDTH_FIT(15) - WIDTH_FIT(81), idLabel.height)];
    self.serialIDTextField.enabled = NO;
    [self.view addSubview:self.serialIDTextField];
    
    
    //昵称输入框
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_FIT(81), CGRectGetMaxY(idLabel.frame) + HEIGHT_FIT(36), idLabel.width , HEIGHT_FIT(150))];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    nameLabel.text = LANGUE_STRING(@"昵    称");
    [self.view addSubview:nameLabel];
    self.nameTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + WIDTH_FIT(15), nameLabel.y, SCREEN_WIDTH - CGRectGetMaxX(nameLabel.frame) - WIDTH_FIT(15) - WIDTH_FIT(81), nameLabel.height)];
    [self.nameTextField setKeyboardType:UIKeyboardTypeDefault];
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.delegate = self;
    self.nameTextField.layer.borderColor = NAVIGATIONBAR_COLOR.CGColor;
    UIColor *attrsColor = COLOR_HEXSTRING(@"#808080");
    NSDictionary *attrs = @{NSForegroundColorAttributeName : attrsColor};
    NSAttributedString *nameTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"请输入设备昵称")  attributes:attrs];
    self.nameTextField.attributedPlaceholder = nameTip;
    [self.view addSubview:self.nameTextField];
    
    //密码输入框
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_FIT(81), CGRectGetMaxY(nameLabel.frame) + HEIGHT_FIT(36),  idLabel.width, HEIGHT_FIT(150))];
    passwordLabel.textAlignment = NSTextAlignmentRight;
    passwordLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    passwordLabel.text = LANGUE_STRING(@"密    码");
    [self.view addSubview:passwordLabel];
    self.passwordTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame) + WIDTH_FIT(15), passwordLabel.y, SCREEN_WIDTH - CGRectGetMaxX(passwordLabel.frame) - WIDTH_FIT(15) - WIDTH_FIT(81), passwordLabel.height)];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    self.passwordTextField.layer.borderColor = NAVIGATIONBAR_COLOR.CGColor;
    [self.view addSubview:self.passwordTextField];
    
    
    //确定按钮
    self.okButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(passwordLabel.frame) + HEIGHT_FIT(114), HEIGHT_FIT(1107), HEIGHT_FIT(165))];
    self.okButton.centerX = self.view.centerX;
    self.okButton.backgroundColor = [UIColor lightGrayColor];
    [self.okButton setTitle:LANGUE_STRING(@"确认") forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(tapOkButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    NSAttributedString *passwordTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"请输入设备密码")  attributes:attrs];
    self.passwordTextField.attributedPlaceholder = passwordTip;
    [self.passwordTextField resignFirstResponder];
    [self.passwordTextField setSecureTextEntry:YES];
    
    //模拟数据
    serialID = arc4random() % 100000000000 + 100000000000 ;
    self.serialIDTextField.text = [NSString getStringWithSerialID:serialID];
    self.nameTextField.text = @"温控器";
    
    //添加textField监听
    [self.passwordTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
    

}

#pragma mark Aciton
//取消输入
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//点击确认(添加数据 或者 修改数据)
- (void)tapOkButton
{
    [self.view endEditing:YES];
    
    if (_nameTextField.text.length < 1 ) {
        
        [MBProgressHUD showTextTip:LANGUE_STRING(@"昵称不能为空")];
        return;
    }
    
    if ( _passwordTextField.text.length < 1) {
        
        [MBProgressHUD showTextTip:LANGUE_STRING(@"请输入设备密码")];
        return;
    }
    
    [[AppDataManager sharedAppDataManager] addThermostatDeviceWithName:_nameTextField.text andPassword:_passwordTextField.text andSid:serialID];


    [self.navigationController popToRootViewControllerAnimated:YES];
}


//监听textField是否有输入
-(void)CheckTextFieldInput:(UITextField *)textField{
    
    if (_nameTextField.text.length > 0 &&  _passwordTextField.text.length > 0 ) {
        self.okButton.enabled = YES;
        self.okButton.backgroundColor = NAVIGATIONBAR_COLOR;
    }else{
        self.okButton.enabled = NO;
        self.okButton.backgroundColor = [UIColor lightGrayColor];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    
    if (textField == self.passwordTextField) {
        [self tapOkButton];
    }
    
    return YES;
}



@end
