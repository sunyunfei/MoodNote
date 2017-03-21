//
//  LoginManager.h
//  fdNews-iOS
//
//  Created by 李梦飞 on 2017/2/4.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject
//单例
+ (instancetype)shareLoginManager;
//調用登陆界面
- (void)loadLoginVC;
- (void)loadTabbarVC:(UIViewController *)vc;
@end
