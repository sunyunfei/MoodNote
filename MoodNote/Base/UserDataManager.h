//
//  UserDataManager.h
//  fdNews-iOS
//
//  Created by 李梦飞 on 2017/2/4.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject
//保存登陆状态
+ (void)saveUserStatus:(BOOL)status andUserMobile:(NSString *)mobile andUserPwd:(NSString *)pwd andUserId:(NSString *)userId andUserName:(NSString *)name andUserIcon:(NSString *)icon;

+ (void)saveIcon:(NSString *)icon;
+ (void)saveName:(NSString *)name;
+ (void)saveColor:(BOOL)flag;//颜色
//判断是否登陆
+ (BOOL)isLogin;
+ (NSString *)obtainUserMobile;
+ (NSString *)obtainUserId;
+ (NSString *)obtainUserPwd;
+ (NSString *)obtainUserIcon;
+ (NSString *)obtainUserName;
+ (BOOL)obtainColor;
//注销
+ (void)deleteDataForUser;
@end
