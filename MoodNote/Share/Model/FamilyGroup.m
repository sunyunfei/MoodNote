//
//  FamilyGroup.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/2.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import "FamilyGroup.h"

@implementation FamilyGroup
-(instancetype)initWithDic:(BmobObject *)bmob{

    /*
     @property (strong,nonatomic)NSString *icon;  //头像
     @property (strong,nonatomic)NSString *name;  //昵称
     @property (strong,nonatomic)NSString *shuoshuoText; //说说
     @property (strong,nonatomic)NSString *time;    //发表的时间,存的是nadate，应该要有时间操作
     @property (strong,nonatomic)NSArray *pictures;   //发表的图片
     @property (strong,nonatomic)NSMutableArray *replys;   //评论
     */
    
    self = [super init];
    if (self) {
        
        if ([bmob objectForKey:@"objectId"]) {
            self.messageId = [bmob objectForKey:@"objectId"];
        }
        
        if ([bmob objectForKey:@"message"]) {
            self.shuoshuoText = [bmob objectForKey:@"message"];
        }
        
        
        if ([bmob objectForKey:@"userId"]) {
            self.userId = [bmob objectForKey:@"userId"];
        }
        
        if ([bmob objectForKey:@"userName"]) {
            self.name = [bmob objectForKey:@"userName"];
        }
        
        if ([bmob objectForKey:@"photo"]) {
            self.icon = [bmob objectForKey:@"photo"];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        self.time = [dateFormatter stringFromDate:bmob.updatedAt];
        
        self.replys = [NSMutableArray array];
        self.pictures = [NSMutableArray array];
    }
    return self;
}

@end
