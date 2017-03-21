//
//  YFCommentModel.m
//  防朋友圈
//
//  Created by 李梦飞 on 2017/2/13.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "YFCommentModel.h"

@implementation YFCommentModel

-(instancetype)initWithDic:(BmobObject *)bmob{

    self = [super init];
    if (self) {
        
        if ([bmob objectForKey:@"comment_id"]) {
            self.commentId = [bmob objectForKey:@"comment_id"];
        }
        
        if ([bmob objectForKey:@"comment_userName"]) {
            self.commentUserName = [bmob objectForKey:@"comment_userName"];
        }
        
        if ([bmob objectForKey:@"comment_text"]) {
            self.commentText = [bmob objectForKey:@"comment_text"];
        }
        
    }
    return self;
}
@end
