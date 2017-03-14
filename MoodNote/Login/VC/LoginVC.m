//
//  LoginVC.m
//  fdNews-iOS
//
//  Created by 孙云飞 on 2017/3/4.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "LoginManager.h"
#import "BaseTabbarVC.h"
@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *mobileField;//账号
@property (weak, nonatomic) IBOutlet UITextField *pwdField;//密码
- (IBAction)clickLoginBtn:(UIButton *)sender;//点击登陆
- (IBAction)clickRegisterBtn:(UIButton *)sender;//点击注册

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

//登陆
- (IBAction)clickLoginBtn:(UIButton *)sender {
    
    //判断账号和密码是否不为空
    if (self.mobileField.text.length <= 0 || self.pwdField.text.length <= 0) {
        
        [MBProgressHUD YFshowMessage:self.view showText:@"账号或者密码不能为空"];
        return;
    }
    
    //开始请求数据
    __block typeof(self)weakSelf = self;
    [YFBmobManager loginForAccount:self.mobileField.text withPassword:self.pwdField.text success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [[LoginManager shareLoginManager] loadTabbarVC:weakSelf];
        });
        
    } failure:^{
        
        [MBProgressHUD YFshowMessage:weakSelf.view showText:@"账号或者密码错误"];
    }];
    
}

//注册
- (IBAction)clickRegisterBtn:(UIButton *)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterVC *vc = [story instantiateViewControllerWithIdentifier:@"register"];
    vc.title =@"注册";
    [self.navigationController pushViewController:vc animated:YES];
}

@end
