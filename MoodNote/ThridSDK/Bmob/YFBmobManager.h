//
//  BmobManager.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
#import "YFMessageModel.h"
#import "YFCommentModel.h"
@interface YFBmobManager : NSObject
//登陆接口
+ (void)loginForAccount:(NSString *)account
           withPassword:(NSString *)pwd
                success:(void(^)())successBlock
                failure:(void(^)())failureBlock;

//注册接口
+ (void)registerForAccount:(NSString *)account
              withPassword:(NSString *)pwd
                   success:(void(^)())successBlock
                   failure:(void(^)())failureBlock;

//个人信息获取接口
+ (void)obtainPersonMessageSuccess:(void(^)(NSString *icon,NSString *name))successBlock
                           failure:(void(^)())failureBlock;

//图片上传
+ (void)updateDataToBMOB:(NSData *)data
                 andName:(NSString *)name
                 success:(void(^)(NSString *url))successBlock
                 failure:(void(^)())failureBlock;

//插入笔记数据
+ (void)insertNote:(NoteModel *)noteModel success:(void(^)())successBlock
           failure:(void(^)())failureBlock;

//首页数据获取
+ (void)queryNoteDataSuccess:(void(^)(NSMutableArray *noteArray))successBlock
                     failure:(void(^)())failureBlock;

//删除数据
+ (void)deleteNoteData:(NSString *)noteId
               success:(void(^)())successBlock
               failure:(void(^)())failureBlock;

//修改笔记
+ (void)updateNoteData:(NoteModel *)noteModel success:(void(^)())successBlock
               failure:(void(^)())failureBlock;

//分享创建事件接口
//+ (void)createShareData:()

+ (void)obtainShareData:(void(^)(NSMutableArray *dataArray))successBlock failure:(void(^)())failureBlock;
//分享图片请求
+ (void)obtainShareImage:(NSString *)messageId success:(void(^)(NSMutableArray *imageArray))successBlock failure:(void(^)())failureBlock;
//评论请求
+ (void)obtainComment:(NSString *)messageId sucess:(void(^)(NSMutableArray *commentArray))successBlock failure:(void(^)())failureBlock;

//插入评论
+ (void)insertComment:(NSString *)messageId andCommentModel:(YFCommentModel *)model sucess:(void(^)())successBlock failure:(void(^)())failureBlock;

//插入分享
+ (void)insertShare:(YFMessageModel *)model andImageArray:(NSArray *)imageArray sucess:(void(^)())successBlock failure:(void(^)())failureBlock;
@end
