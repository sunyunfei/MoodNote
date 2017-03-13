//
//  BmobManager.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "YFBmobManager.h"
#import <BmobSDK/Bmob.h>
#import "NoteModel.h"
@implementation YFBmobManager
//登陆接口
+ (void)loginForAccount:(NSString *)account
           withPassword:(NSString *)pwd
                success:(void(^)())successBlock
                failure:(void(^)())failureBlock{

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
+ (void)registerForAccount:(NSString *)account
              withPassword:(NSString *)pwd
                   success:(void(^)())successBlock
                   failure:(void(^)())failureBlock{

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
+ (void)obtainPersonMessageSuccess:(void(^)(NSString *icon,NSString *name))successBlock
                           failure:(void(^)())failureBlock{

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


//图片上传
+ (void)updateDataToBMOB:(NSData *)data
                 andName:(NSString *)name
                 success:(void(^)(NSString *url))successBlock
                 failure:(void(^)())failureBlock{

    //上传图片
    BmobFile *file = [[BmobFile alloc] initWithFileName:name withFileData:data];
    [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            successBlock(file.url);
        }else{
        
            failureBlock();
        }
    }];
}


//插入笔记数据
+ (void)insertNote:(NoteModel *)noteModel success:(void(^)())successBlock
           failure:(void(^)())failureBlock{

    BmobObject *note = [BmobObject objectWithClassName:@"Note_MoodNote"];
    [note setObject:noteModel.note_time forKey:@"note_time"];
    [note setObject:noteModel.note_type forKey:@"note_type"];
    [note setObject:noteModel.note_image forKey:@"note_image"];
    [note setObject:noteModel.note_video forKey:@"note_video"];
    [note setObject:noteModel.note_weather forKey:@"note_weather"];
    [note setObject:noteModel.note_location forKey:@"note_location"];
    [note setObject:noteModel.user_id forKey:@"user_id"];
    [note setObject:noteModel.note_content forKey:@"note_content"];
    [note saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            successBlock();
        }else{
        
            failureBlock();
        }
    }];
}

//首页数据获取
+ (void)queryNoteDataSuccess:(void(^)(NSMutableArray *noteArray))successBlock
                     failure:(void(^)())failureBlock{

    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Note_MoodNote"];
    [bquery clearCachedResult];
    //条件
    [bquery whereKey:@"user_id" equalTo:[UserDataManager obtainUserId]];
    NSMutableArray *noteArray = [NSMutableArray array];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject *obj in array) {
                
                NoteModel *model = [[NoteModel alloc]initWithBmob:obj];
                [noteArray addObject:model];
            }
            
            successBlock(noteArray);
            
        }else{
            
            failureBlock();
        }
        
    }];
}

//删除数据
+ (void)deleteNoteData:(NSString *)noteId
               success:(void(^)())successBlock
               failure:(void(^)())failureBlock{

    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Note_MoodNote"];
    [bquery getObjectInBackgroundWithId:noteId block:^(BmobObject *object, NSError *error) {
        
        if (object) {
            
            [object deleteInBackground];
            successBlock();
        }else{
        
            failureBlock();
        }
    }];
}

//修改笔记
+ (void)updateNoteData:(NoteModel *)noteModel success:(void(^)())successBlock
               failure:(void(^)())failureBlock{

    BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"Note_MoodNote" objectId:noteModel.note_id];
    //设置
    [obj setObject:noteModel.note_content forKey:@"note_content"];
    [obj setObject:noteModel.note_image forKey:@"note_image"];
    [obj setObject:noteModel.note_video forKey:@"note_video"];
    
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            successBlock();
        }else{
            NSLog(@"error = %@",error);
            failureBlock();
        }
    }];
}
@end
