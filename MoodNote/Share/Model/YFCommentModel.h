//
//  YFCommentModel.h
//  防朋友圈
//
//  Created by 李梦飞 on 2017/2/13.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface YFCommentModel : NSObject

@property(nonatomic,copy)NSString *commentId;

@property(nonatomic,copy)NSString *commentUserName;

@property(nonatomic,copy)NSString *commentText;

-(instancetype)initWithDic:(BmobObject *)bmob;
@end
