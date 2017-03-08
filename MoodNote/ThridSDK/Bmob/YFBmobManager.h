//
//  BmobManager.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFBmobManager : NSObject
//登陆接口
+ (void)loginForAccount:(NSString *)account withPassword:(NSString *)pwd success:(void(^)())successBlock failure:(void(^)())failureBlock;

//注册接口
+ (void)registerForAccount:(NSString *)account withPassword:(NSString *)pwd success:(void(^)())successBlock failure:(void(^)())failureBlock;

//个人信息获取接口
+ (void)obtainPersonMessageSuccess:(void(^)(NSString *icon,NSString *name))successBlock failure:(void(^)())failureBlock;
@end
