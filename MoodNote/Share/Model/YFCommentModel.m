//
//  YFCommentModel.m
//  防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "YFCommentModel.h"

@implementation YFCommentModel

/*
 @property (nonatomic, assign) BOOL isExpand;
 
 @property(nonatomic,copy)NSString *commentId;
 
 @property(nonatomic,copy)NSString *commentUserId;
 
 @property(nonatomic,copy)NSString *commentUserName;
 
 @property(nonatomic,copy)NSString *commentPhoto;
 
 @property(nonatomic,copy)NSString *commentText;
 @property(nonatomic,copy)NSString *commentByUserId;
 @property(nonatomic,copy)NSString *commentByUserName;
 @property(nonatomic,copy)NSString *commentByPhoto;
 @property(nonatomic,copy)NSString *createDateStr;
 @property(nonatomic,copy)NSString *checkStatus;
 */

-(instancetype)initWithDic:(BmobObject *)bmob{

    self = [super init];
    if (self) {
        
        if ([bmob objectForKey:@"comment_id"]) {
            self.commentId = [bmob objectForKey:@"comment_id"];
        }
        
        if ([bmob objectForKey:@"comment_userId"]) {
            self.commentUserId = [bmob objectForKey:@"comment_userId"];
        }
        
        if ([bmob objectForKey:@"comment_userName"]) {
            self.commentUserName = [bmob objectForKey:@"comment_userName"];
        }
        
        if ([bmob objectForKey:@"comment_photo"]) {
            self.commentPhoto = [bmob objectForKey:@"comment_photo"];
        }
        
        if ([bmob objectForKey:@"comment_text"]) {
            self.commentText = [bmob objectForKey:@"comment_text"];
        }
        if ([bmob objectForKey:@"comment_byUserId"]) {
            self.commentByUserId = [bmob objectForKey:@"comment_byUserId"];
        }
        
        if ([bmob objectForKey:@"comment_byUserName"]) {
            self.commentByUserName = [bmob objectForKey:@"comment_byUserName"];
        }
        
        if ([bmob objectForKey:@"comment_byUserPhoto"]) {
            self.commentByPhoto = [bmob objectForKey:@"comment_byUserPhoto"];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        self.createDateStr = [dateFormatter stringFromDate:bmob.updatedAt];
    }
    return self;
}
@end
