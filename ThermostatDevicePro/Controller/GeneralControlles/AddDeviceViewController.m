//
//  AddDeviceViewController.m
//  HotWindPro
//
//  Created by lyric on 2017/3/29.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "BorderTextField.h"
#import "UITextField+NumberFormat.h"

#define MAX_SERIAL_LENGTH 15 //序列号最大长度(加上空格) 实际长度为12位

@interface AddDeviceViewController ()<UITextFieldDelegate>{
    long long serialID;
}

@property(nonatomic , strong)BorderTextField *serialIDTextField;
@property(nonatomic , strong)BorderTextField *passwordTextField;
@property(nonatomic , strong)UIButton *okButton;

@end

@implementation AddDeviceViewController

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
    [self.view addSubview:self.serialIDTextField];
    UIColor *attrsColor = COLOR_HEXSTRING(@"#808080");
    NSDictionary *attrs = @{NSForegroundColorAttributeName : attrsColor};
    NSAttributedString *serialIDTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"请输入12位设备序列号")  attributes:attrs];
    self.serialIDTextField.attributedPlaceholder = serialIDTip;
    [self.serialIDTextField setKeyboardType:UIKeyboardTypeNumberPad];
    self.serialIDTextField.delegate = self;
    [self.serialIDTextField becomeFirstResponder];
    
    //密码输入框
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH_FIT(81), CGRectGetMaxY(idLabel.frame) + HEIGHT_FIT(36), idLabel.width , HEIGHT_FIT(150))];
    passwordLabel.textAlignment = NSTextAlignmentRight;
    passwordLabel.font = [UIFont systemFontOfSize:PX_TO_PT(45)];
    passwordLabel.text = LANGUE_STRING(@"密    码");
    [self.view addSubview:passwordLabel];
    self.passwordTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordLabel.frame) + WIDTH_FIT(15), passwordLabel.y, SCREEN_WIDTH - CGRectGetMaxX(passwordLabel.frame) - WIDTH_FIT(15) - WIDTH_FIT(81), passwordLabel.height)];
    [self.passwordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [self.passwordTextField setSecureTextEntry:YES];
    self.passwordTextField.delegate = self;
    [self.view addSubview:self.passwordTextField];
    NSAttributedString *passwordTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"请输入设备密码")  attributes:attrs];
    self.passwordTextField.attributedPlaceholder = passwordTip;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    
    //确定按钮
    self.okButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(passwordLabel.frame) + HEIGHT_FIT(114), HEIGHT_FIT(1107), HEIGHT_FIT(165))];
    self.okButton.centerX = self.view.centerX;
    self.okButton.backgroundColor = [UIColor lightGrayColor];
    [self.okButton setTitle:LANGUE_STRING(@"确认") forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(tapOkButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    

    //添加textField监听
    [self.serialIDTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
}

//监听textField是否有输入
-(void)CheckTextFieldInput:(UITextField *)textField{
    
    if (_serialIDTextField == textField) {
        if (_serialIDTextField.text.length > 14) {
            _serialIDTextField.text = [_serialIDTextField.text substringToIndex:14];
        }
    }
    
    
    
    if (_serialIDTextField.text.length > 0 &&  _passwordTextField.text.length > 0 ) {
        self.okButton.enabled = YES;
        self.okButton.backgroundColor = NAVIGATIONBAR_COLOR;
    }else{
        self.okButton.enabled = NO;
        self.okButton.backgroundColor = [UIColor lightGrayColor];
    }

}

//取消输入
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//点击确认(添加设备)
- (void)tapOkButton
{

    [self.view endEditing:YES];
    
    if (_serialIDTextField.text.length != MAX_SERIAL_LENGTH - 1 ) {
        
        [MBProgressHUD showTextTip:LANGUE_STRING(@"请输入12位设备序列号")];
        return;
    }
    
    if ( _passwordTextField.text.length < 1) {
        
        [MBProgressHUD showTextTip:LANGUE_STRING(@"请输入设备密码")];
        return;
    }
    
    serialID = [[_serialIDTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] longLongValue];
    
    
    [[AppDataManager sharedAppDataManager] addThermostatDeviceWithName:nil andPassword:self.passwordTextField.text andSid:serialID];
    [self.navigationController popToRootViewControllerAnimated:YES];
  
}

#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if(self.serialIDTextField == textField) {
        return [UITextField numberFormatTextField:_serialIDTextField shouldChangeCharactersInRange:range replacementString:string textFieldType:kPhoneNumberTextFieldType];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.passwordTextField) {
        [self tapOkButton];
    }
    
    return YES;
}







@end
