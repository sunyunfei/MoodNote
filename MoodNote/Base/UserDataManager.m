//
//  UserDataManager.m
//  fdNews-iOS
//
//  Created by 李梦飞 on 2017/2/4.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "UserDataManager.h"
static NSString *userStatus = @"userStatus";
static NSString *userMobile = @"userMobile";
static NSString *user_Id = @"userId";
static NSString *userPwd = @"userPwd";
static NSString *user_name = @"userName";
static NSString *user_icon = @"userIcon";
@implementation UserDataManager
//保存登陆状态
+ (void)saveUserStatus:(BOOL)status andUserMobile:(NSString *)mobile andUserPwd:(NSString *)pwd andUserId:(NSString *)userId andUserName:(NSString *)name andUserIcon:(NSString *)icon{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:status forKey:userStatus];
    [defaults setObject:mobile forKey:userMobile];
    [defaults setObject:pwd forKey:userPwd];
    [defaults setObject:userId forKey:user_Id];
    [defaults setObject:name forKey:user_name];
    [defaults setObject:icon forKey:user_icon];
    [defaults synchronize];
}

+ (void)saveIcon:(NSString *)icon{

     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     [defaults setObject:icon forKey:user_icon];
     [defaults synchronize];
}

+ (void)saveName:(NSString *)name{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:user_name];
    [defaults synchronize];
}

+ (void)saveColor:(BOOL)flag{

    NSLog(@"flag = %i",flag);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:flag forKey:@"color"];
    [defaults synchronize];
}

+ (BOOL)obtainColor{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"color"];
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

+ (NSString *)obtainUserIcon{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:user_icon];
}
+ (NSString *)obtainUserName{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:user_name];
}

//注销
+ (void)deleteDataForUser{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:userMobile];
    [defaults removeObjectForKey:userPwd];
    [defaults removeObjectForKey:user_Id];
    [defaults setBool:NO forKey:userStatus];
    [defaults removeObjectForKey:user_name];
    [defaults removeObjectForKey:user_icon];
    [defaults synchronize];
}
@end
