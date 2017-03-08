//
//  AppDelegate.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/5.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "LoginVC.h"
#import "BaseTabbarVC.h"
#import <BmobSDK/Bmob.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //高德地图
    [AMapServices sharedServices].apiKey =@"17eddda860e07ceda5b69e097f337879";
    
    //Bmob
    [Bmob registerWithAppKey:@"a4345520379aae3dcdb789c11a9b4087"];
    
    //创建windows
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //判断是否登陆
    if ([UserDataManager isLogin]) {
        
        [self loadTabbar];
    }else{
    
        [self loadLoginVC];
    }
    return YES;
}


- (void)loadLoginVC{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginVC *login = [story instantiateViewControllerWithIdentifier:@"login"];
    login.title = @"登陆";
    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController = vc;
}

- (void)loadTabbar{

    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BaseTabbarVC *tabbar = [story instantiateViewControllerWithIdentifier:@"base"];
    self.window.rootViewController = tabbar;
}
@end
