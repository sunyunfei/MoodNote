//
//  UserDataManager.h
//  fdNews-iOS
//
//  Created by 孙云飞 on 2017/3/4.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject
//保存登陆状态
+ (void)saveUserStatus:(BOOL)status andUserMobile:(NSString *)mobile andUserPwd:(NSString *)pwd andUserId:(NSString *)userId;
//判断是否登陆
+ (BOOL)isLogin;
+ (NSString *)obtainUserMobile;
+ (NSString *)obtainUserId;
+ (NSString *)obtainUserPwd;
//注销
+ (void)deleteDataForUser;
@end
