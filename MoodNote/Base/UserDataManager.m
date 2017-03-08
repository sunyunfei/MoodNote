//
//  UserDataManager.m
//  fdNews-iOS
//
//  Created by 孙云飞 on 2017/3/4.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "UserDataManager.h"
static NSString *userStatus = @"userStatus";
static NSString *userMobile = @"userMobile";
static NSString *user_Id = @"userId";
static NSString *userPwd = @"userPwd";
@implementation UserDataManager
//保存登陆状态
+ (void)saveUserStatus:(BOOL)status andUserMobile:(NSString *)mobile andUserPwd:(NSString *)pwd andUserId:(NSString *)userId{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:status forKey:userStatus];
    [defaults setObject:mobile forKey:userMobile];
    [defaults setObject:pwd forKey:userPwd];
    [defaults setObject:userId forKey:user_Id];
    [defaults synchronize];
}

//判断是否登陆
+ (BOOL)isLogin{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:userStatus];
}

+ (NSString *)obtainUserMobile{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:userMobile];
}
+ (NSString *)obtainUserId{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:user_Id];
}

+ (NSString *)obtainUserPwd{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:userPwd];
}

//注销
+ (void)deleteDataForUser{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:userMobile];
    [defaults removeObjectForKey:userPwd];
    [defaults removeObjectForKey:user_Id];
    [defaults setBool:NO forKey:userStatus];
    [defaults synchronize];
}
@end
