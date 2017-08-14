//
//  EditNameViewController.m
//  HotWindPro
//
//  Created by lyric on 2017/4/11.
//  Copyright © 2017年 lyice. All rights reserved.
//

#import "EditNameViewController.h"
#import "BorderTextField.h"

@interface EditNameViewController ()<UITextFieldDelegate>

@property(nonatomic , strong)BorderTextField *nameTextField; //昵称修改输入框
@property(nonatomic , strong)UIButton *okButton;//确定按钮

@end

@implementation EditNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
}

//设置UI
- (void)setUI
{
    
    //导航栏设置
    self.navigationItem.title = LANGUE_STRING(@"修改设备名称");
    
    //新昵称输入框
    self.nameTextField = [[BorderTextField alloc]initWithFrame:CGRectMake(0, HEIGHT_FIT(150) + 64, HEIGHT_FIT(1107) , HEIGHT_FIT(150))];
    self.nameTextField.centerX = self.view.centerX;
    self.nameTextField.text = [[AppDataManager sharedAppDataManager] getCurrentDevice].deviceName;
    self.nameTextField.returnKeyType = UIReturnKeyDone;
    self.nameTextField.delegate = self;
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIColor *attrsColor = COLOR_HEXSTRING(@"#808080");
    NSDictionary *attrs = @{NSForegroundColorAttributeName : attrsColor};
    NSAttributedString *nameTip = [[NSAttributedString alloc]initWithString:LANGUE_STRING(@"请输入设备名称")  attributes:attrs];
    self.nameTextField.attributedPlaceholder = nameTip;
    [self.view addSubview:self.nameTextField];
    

    //确定按钮
    self.okButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameTextField.frame) + HEIGHT_FIT(114), HEIGHT_FIT(1107), HEIGHT_FIT(165))];
    self.okButton.centerX = self.view.centerX;
    self.okButton.backgroundColor = NAVIGATIONBAR_COLOR;
    [self.okButton setTitle:LANGUE_STRING(@"完成") forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:PX_TO_PT(60)];
    [self.okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.okButton addTarget:self action:@selector(tapOkButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.okButton];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.nameTextField becomeFirstResponder];

}

//修改昵称
- (void)tapOkButton
{
    //判断输入不能为空
    if (self.nameTextField.text.length < 1) {
        [MBProgressHUD showTextTip:LANGUE_STRING(@"名称不能为空")];
        return;
    }
    
    //获取当前操作的设备，操作
    if ([[AppDataManager sharedAppDataManager] getCurrentDevice] != nil) {
        ThermostatDeviceModel *deviceObject = [[AppDataManager sharedAppDataManager] getCurrentDevice];
        [deviceObject changeDeviceName:self.nameTextField.text];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark  UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.nameTextField) {
        [self tapOkButton];
    }
    
    return YES;
}





@end
