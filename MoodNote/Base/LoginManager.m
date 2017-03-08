//
//  LoginManager.m
//  fdNews-iOS
//
//  Created by 孙云飞 on 2017/3/4.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "LoginManager.h"
#import "LoginVC.h"
#import "BaseTabbarVC.h"
@implementation LoginManager

//单例
+ (instancetype)shareLoginManager{

    static LoginManager *login = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        login = [[self alloc]init];
    });
    return login;
}

//調用登陆界面
- (void)loadLoginVC{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginVC *login = [story instantiateViewControllerWithIdentifier:@"login"];
    login.title = @"登陆";
    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:login];
    [UIApplication sharedApplication].keyWindow.rootViewController = vc;
}

- (void)loadTabbarVC:(UIViewController *)vc{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseTabbarVC *tabbar = [story instantiateViewControllerWithIdentifier:@"base"];
    [vc presentViewController:tabbar animated:NO completion:nil];
}
@end
