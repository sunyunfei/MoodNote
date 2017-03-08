//
//  LoginManager.h
//  fdNews-iOS
//
//  Created by 孙云飞 on 2017/3/4.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject
//单例
+ (instancetype)shareLoginManager;
//調用登陆界面
- (void)loadLoginVC;
- (void)loadTabbarVC:(UIViewController *)vc;
@end
