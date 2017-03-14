//
//  YFMessageModel.m
//  防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "YFMessageModel.h"

@implementation YFMessageModel

-(instancetype)initWithDic:(BmobObject *)bmob{

    self = [super init];
    if (self) {
        
        if ([bmob objectForKey:@"objectId"]) {
            self.message_id = [bmob objectForKey:@"objectId"];
        }
        
        if ([bmob objectForKey:@"message"]) {
            self.message = [bmob objectForKey:@"message"];
        }
        
        if ([bmob objectForKey:@"userId"]) {
            self.userId = [bmob objectForKey:@"userId"];
        }
        
        if ([bmob objectForKey:@"userName"]) {
            self.userName = [bmob objectForKey:@"userName"];
        }
        
        if ([bmob objectForKey:@"photo"]) {
            self.photo = [bmob objectForKey:@"photo"];
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        self.timeTag = [dateFormatter stringFromDate:bmob.updatedAt];
    }
    return self;
}

-(NSMutableArray *)commentModelArray{
    if (_commentModelArray==nil) {
        _commentModelArray = [NSMutableArray array];
    }
    return _commentModelArray;
}

-(NSMutableArray *)messageSmallPics{
    if (_messageSmallPics==nil) {
        _messageSmallPics = [NSMutableArray array];
    }
    return _messageSmallPics;
}
@end
