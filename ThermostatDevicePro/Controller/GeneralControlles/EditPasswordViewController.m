//
//  EditPasswordViewController.m
//  HotWindPro
//
//  Created by lyric on 2017/4/11.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "BorderTextField.h"

@interface EditPasswordViewController ()<UITextFieldDelegate>

@property(nonatomic , strong)BorderTextField *oldPasswordTextField;
@property(nonatomic , strong)BorderTextField *aNewPasswordTextField;
@property(nonatomic , strong)BorderTextField *bNewPasswordTextField;
@property(nonatomic , strong)UIButton *okButton;

@end

@implementation EditPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI
{
    
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"修改设备密码");
    
    //旧密码输入框
    self.oldPasswordTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(150) + 64, HEIGHT_FIT(1107) , HEIGHT_FIT(150))];
    self.oldPasswordTextField.centerX = self.view.centerX;
    [self.oldPasswordTextField setSecureTextEntry:YES];
    [self.oldPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    UIColor *attrsColor = COLOR_HEXSTRING(@"#808080");
    NSDictionary *attrs = @{NSForegroundColorAttributeName : attrsColor};
    NSAttributedString *oldPasswordTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"旧密码")  attributes:attrs];
    self.oldPasswordTextField.attributedPlaceholder = oldPasswordTip;
    self.oldPasswordTextField.delegate = self;
    self.oldPasswordTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.oldPasswordTextField];
    
    
    //新密码输入框
    self.aNewPasswordTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_oldPasswordTextField.frame) + HEIGHT_FIT(150) / 2, HEIGHT_FIT(1107) , HEIGHT_FIT(150))];
    self.aNewPasswordTextField.centerX = self.view.centerX;
    [self.aNewPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [self.aNewPasswordTextField setSecureTextEntry:YES];
    NSAttributedString *aNewPasswordTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"新密码")  attributes:attrs];
    self.aNewPasswordTextField.attributedPlaceholder = aNewPasswordTip;
    self.aNewPasswordTextField.delegate = self;
    self.aNewPasswordTextField.returnKeyType = UIReturnKeyNext;
    [self.view addSubview:self.aNewPasswordTextField];
    
    //新密码确认输入框
    self.bNewPasswordTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_aNewPasswordTextField.frame) + HEIGHT_FIT(150) / 2, HEIGHT_FIT(1107) , HEIGHT_FIT(150))];
    self.bNewPasswordTextField.centerX = self.view.centerX;
    [self.bNewPasswordTextField setKeyboardType:UIKeyboardTypeASCIICapable];
    [self.bNewPasswordTextField setSecureTextEntry:YES];
    NSAttributedString *bNewPasswordTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"再次输入新密码")  attributes:attrs];
    self.bNewPasswordTextField.attributedPlaceholder = bNewPasswordTip;
    self.bNewPasswordTextField.delegate = self;
    self.bNewPasswordTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.bNewPasswordTextField];
    
    
    //确定按钮
    self.okButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bNewPasswordTextField.frame) + HEIGHT_FIT(114), HEIGHT_FIT(1107), HEIGHT_FIT(165))];
    self.okButton.centerX = self.view.centerX;
    self.okButton.backgroundColor = [UIColor lightGrayColor];
    [self.okButton setTitle:LANGUE_STRING(@"完成") forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(tapOkButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    
    //添加textField监听
    [self.bNewPasswordTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
    [self.aNewPasswordTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
    [self.oldPasswordTextField addTarget:self action:@selector(CheckTextFieldInput:) forControlEvents:UIControlEventEditingChanged];
    
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.oldPasswordTextField becomeFirstResponder];
    
}

//修改新密码
- (void)tapOkButton
{

    //结束编辑
    [self.view endEditing:YES];
    
    //判断两次新密码是否输入一致
    if (![self.aNewPasswordTextField.text isEqualToString:self.bNewPasswordTextField.text] ) {
        
        [MBProgressHUD showTextTip:LANGUE_STRING(@"两次新密码输入不一致，请确认")];
        return;
    }
    
    //获取当前操作的设备，操作
    ThermostatDeviceModel *deviceObject = [[AppDataManager sharedAppDataManager] getCurrentDevice];
    if ([deviceObject.devicePassWord isEqualToString:self.oldPasswordTextField.text]) {
        
        [deviceObject changeDevicePassword:self.aNewPasswordTextField.text];
        [MBProgressHUD showTextTip:@"密码修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showTextTip:LANGUE_STRING(@"原密码错误")];
    }

}

//监听textField是否有输入
-(void)CheckTextFieldInput:(UITextField *)textField{
    
    if (_oldPasswordTextField.text.length > 0 &&  _aNewPasswordTextField.text.length > 0 && _bNewPasswordTextField.text.length > 0 ) {
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

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.oldPasswordTextField) {
        [self.aNewPasswordTextField becomeFirstResponder];
    }
    
    if (textField == self.aNewPasswordTextField) {
        [self.bNewPasswordTextField becomeFirstResponder];
    }
    
    if (textField == self.bNewPasswordTextField) {
        [self tapOkButton];
    }
    
    return YES;
}




@end
