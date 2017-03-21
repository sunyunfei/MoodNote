//
//  RegisterVC.m
//  fdNews-iOS
//
//  Created by 李梦飞 on 2017/2/4.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()
@property (weak, nonatomic) IBOutlet UITextField *mobileField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
- (IBAction)clickRegisterBtn:(UIButton *)sender;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerBtn.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//注册按钮
- (IBAction)clickRegisterBtn:(UIButton *)sender {
    
    //判断是否有空
    if (self.mobileField.text.length != 11 || self.pwdField.text.length < 6) {
        
        [MBProgressHUD YFshowMessage:self.view showText:@"账号或者密码格式不对"];
        return;
    }
    
    //判断验证码是否正确
    
    if (![self.codeField.text isEqualToString:@"123456"]) {
        
        [MBProgressHUD YFshowMessage:self.view showText:@"验证码填写不正确"];
        return;
    }
    
    //注册开始
    __block typeof(self)weakSelf = self;
    [YFBmobManager registerForAccount:self.mobileField.text withPassword:self.pwdField.text success:^{
        
        [MBProgressHUD YFshowMessage:weakSelf.view showText:@"注册成功，请登陆"];
        [weakSelf performSelector:@selector(returnLogin) withObject:weakSelf afterDelay:0.5];
    } failure:^{
        [MBProgressHUD YFshowMessage:weakSelf.view showText:@"注册失败，请重试"];
    }];
    
    
    

}
//返回登陆界面
- (void)returnLogin{

    [self.navigationController popViewControllerAnimated:YES];
}
@end
