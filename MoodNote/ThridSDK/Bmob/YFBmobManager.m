//
//  BmobManager.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "YFBmobManager.h"
#import <BmobSDK/Bmob.h>
#import "NoteModel.h"
#import "YFCommentModel.h"
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
                
                //首先判断name，和icon有没有值
                NSString *name = [obj objectForKey:@"userName"];
                if (name == nil || name.length <= 0) {
                    name = account;
                }
                NSString *icon = [obj objectForKey:@"userIcon"];
                if (icon == nil || icon.length <= 0) {
                    icon = @"http://b.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=f0c5c08030d3d539c16807c70fb7c566/8ad4b31c8701a18bbef9f231982f07082838feba.jpg";
                }
                //记录登陆的状态
                [UserDataManager saveUserStatus:YES andUserMobile:account andUserPwd:pwd andUserId:obj.objectId andUserName:name andUserIcon:icon];
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

//个人信息的更改
+ (void)updatePersonMessage:(void(^)())successBlock failure:(void(^)())failureBlock{

    BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"Note_User" objectId:[UserDataManager obtainUserId]];
    [obj setObject:[UserDataManager obtainUserName] forKey:@"userName"];
    [obj setObject:[UserDataManager obtainUserIcon] forKey:@"userIcon"];
    
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            successBlock();
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
    [obj setObject:noteModel.note_type forKey:@"note_type"];
    
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            successBlock();
        }else{
            NSLog(@"error = %@",error);
            failureBlock();
        }
    }];
}

+ (void)obtainShareData:(void(^)(NSMutableArray *dataArray))successBlock failure:(void(^)())failureBlock{
    
    //首先请求分享的内容
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Note_Comment"];
    [bquery clearCachedResult];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        //如果有数据
        if (array) {
            
            for (BmobObject *bmob in array) {
                FamilyGroup *model = [[FamilyGroup alloc]initWithDic:bmob];
                [dataArray addObject:model];
            }
            
            successBlock(dataArray);
        }else{
            
            failureBlock();
        }
    }];
}

//分享图片请求
+ (void)obtainShareImage:(NSString *)messageId success:(void(^)(NSMutableArray *imageArray))successBlock failure:(void(^)())failureBlock{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Note_ShareImage"];
    [bquery clearCachedResult];
    [bquery whereKey:@"message_id" equalTo:messageId];
    NSMutableArray *dataArray = [NSMutableArray array];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject *bmob in array) {
                
                if ([bmob objectForKey:@"share_image"]) {
                    
                    [dataArray addObject:[bmob objectForKey:@"share_image"]];
                }
            }
            
            successBlock(dataArray);
        }else{
            
            failureBlock();
        }
    }];
}

//评论请求
+ (void)obtainComment:(NSString *)messageId sucess:(void(^)(NSMutableArray *commentArray))successBlock failure:(void(^)())failureBlock{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Note_Comment2"];
    [bquery clearCachedResult];
    [bquery whereKey:@"message_id" equalTo:messageId];
    NSMutableArray *dataArray = [NSMutableArray array];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject *bmob in array) {
                
                YFCommentModel *model = [[YFCommentModel alloc]initWithDic:bmob];
                [dataArray addObject:model];
            }
            successBlock(dataArray);
        }
        else{
            
            failureBlock();
        }
    }];
}

//插入评论
+ (void)insertComment:(NSString *)messageId andCommentModel:(YFCommentModel *)model sucess:(void(^)())successBlock failure:(void(^)())failureBlock{
    
    BmobObject *obj = [BmobObject objectWithClassName:@"Note_Comment2"];
    [obj setObject:messageId forKey:@"message_id"];
    [obj setObject:model.commentUserName forKey:@"comment_userName"];
    [obj setObject:model.commentText forKey:@"comment_text"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            successBlock();
        }else{
        
            failureBlock();
        }
    }];
}

//插入分享
+ (void)insertShare:(FamilyGroup *)model andImageArray:(NSArray *)imageArray sucess:(void(^)())successBlock failure:(void(^)())failureBlock{

    BmobObject *obj = [BmobObject objectWithClassName:@"Note_Comment"];
    [obj setObject:model.name forKey:@"userName"];
    [obj setObject:model.icon forKey:@"photo"];
    [obj setObject:model.userId forKey:@"userId"];
    [obj setObject:model.shuoshuoText forKey:@"message"];
    NSString *cid = [YFBmobManager getTimeNow];
    [obj setObject:cid forKey:@"cid"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            //获得对应的messageid
            BmobQuery *bquery = [BmobQuery queryWithClassName:@"Note_Comment"];
            [bquery whereKey:@"cid" equalTo:cid];
            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                
                //如果有
                if (array.count > 0) {
                    
                    BmobObject *bmob = array[0];
                    NSString *messageId = bmob.objectId;
                    //上传图片
                    if (imageArray.count > 0) {
                        
                        for(int i = 0;i < imageArray.count;i ++){
                            
                            [YFBmobManager updateShareImage:imageArray[i] andId:messageId sucess:^{
                                
                                if (i == imageArray.count - 1) {
                                    
                                    //说明都上传完了
                                    successBlock();
                                }
                            } failure:^{
                                failureBlock();
                            }];
                        }
                    }else{
                    
                        //说明都上传完了
                        successBlock();
                    }
                }
            }];
        }else{
        
            failureBlock();
        }
    }];
}

//分享图片上传
+ (void)updateShareImage:(UIImage *)image andId:(NSString *)messageId sucess:(void(^)())successBlock failure:(void(^)())failureBlock{

    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [YFBmobManager updateDataToBMOB:imageData andName:[NSString stringWithFormat:@"share%@.jpg",[YFBmobManager getTimeNow]] success:^(NSString *url) {
        
        //上传url
        BmobObject *obj = [BmobObject objectWithClassName:@"Note_ShareImage"];
        [obj setObject:messageId forKey:@"message_id"];
        [obj setObject:url forKey:@"share_image"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                successBlock();
            }else{
            
                failureBlock();
            }
        }];
    } failure:^{
        
        failureBlock();
    }];
}

/**
 *  返回当前时间
 *
 */
+ (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    //取出个随机数
    int last = arc4random() % 10000;
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@-%i", date,last];
    //NSLog(@"%@", timeNow);
    return timeNow;
}
@end
