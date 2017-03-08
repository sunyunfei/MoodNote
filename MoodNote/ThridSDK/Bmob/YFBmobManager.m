//
//  BmobManager.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "YFBmobManager.h"
#import <BmobSDK/Bmob.h>
@implementation YFBmobManager
//登陆接口
+ (void)loginForAccount:(NSString *)account withPassword:(NSString *)pwd success:(void(^)())successBlock failure:(void(^)())failureBlock{

    //网络请求
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Note_User"];
    [bquery whereKey:@"userAccount" equalTo:account];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            
            //比较密码是否正确
            BmobObject *obj = array[0];
            if ([pwd isEqualToString:[obj objectForKey:@"userPassword"]]) {
                //到这里数据登录成功
                
                //记录登陆的状态
                [UserDataManager saveUserStatus:YES andUserMobile:account andUserPwd:pwd andUserId:obj.objectId];
                //成功回調
                successBlock();
            }else{
                
                failureBlock();
            }
        }else{
            
            failureBlock();
        }
    }];
}

//注册接口
+ (void)registerForAccount:(NSString *)account withPassword:(NSString *)pwd success:(void(^)())successBlock failure:(void(^)())failureBlock{

    //注册
    BmobObject *userData = [BmobObject objectWithClassName:@"Note_User"];
    [userData setObject:account forKey:@"userAccount"];
    [userData setObject:pwd forKey:@"userPassword"];
    [userData saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            successBlock();
        }else{
            
            failureBlock();
        }
    }];
}

//个人信息获取接口
+ (void)obtainPersonMessageSuccess:(void(^)(NSString *icon,NSString *name))successBlock failure:(void(^)())failureBlock{

    //网络请求
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Note_User"];
    NSLog(@"userId = %@",[UserDataManager obtainUserId]);
    [bquery getObjectInBackgroundWithId:[UserDataManager obtainUserId] block:^(BmobObject *object, NSError *error) {
        
        NSString *name = [UserDataManager obtainUserMobile];
        NSString *icon = @"error";
        if (object) {
            
            if ([object objectForKey:@"userName"]) {
                
                name = [object objectForKey:@"userName"];
            }
            
            //查看是否有头像
            if ([object objectForKey:@"userIcon"]) {
                
                icon = [object objectForKey:@"userIcon"];
            }
            successBlock(icon,name);
        }else{
            
            failureBlock();
        }
    }];
}
@end
