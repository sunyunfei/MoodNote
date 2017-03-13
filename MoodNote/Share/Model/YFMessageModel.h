//
//  YFMessageModel.h
//  防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface YFMessageModel : NSObject

///发布说说的id
@property(nonatomic,copy)NSString *message_id;

///发布说说的内容
@property(nonatomic,copy)NSString *message;

///发布说说的时间标签
@property(nonatomic,copy)NSString *timeTag;

///发布说说的类型）
@property(nonatomic,copy)NSString *message_type;

///发布说说者id
@property(nonatomic,copy)NSString *userId;

///发布说说者名字
@property(nonatomic,copy)NSString *userName;

///发布说说者头像
@property(nonatomic,copy)NSString *photo;

///评论小图
@property(nonatomic,copy)NSMutableArray *messageSmallPics;

///评论相关的所有信息
@property(nonatomic,copy)NSMutableArray *commentModelArray;


-(instancetype)initWithDic:(BmobObject *)bmob;
@end
