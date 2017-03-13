//
//  YFShareRectManager.h
//  再防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFCommentModel.h"
#import "YFMessageModel.h"
#import <UIKit/UIKit.h>
@interface YFShareRectManager : NSObject
@property(nonatomic,assign)CGRect iconRect;//头像
@property(nonatomic,assign)CGRect nameRect;//名字
@property(nonatomic,assign)CGRect timeRect;//时间
@property(nonatomic,assign)CGRect contentRect;//内容
@property(nonatomic,assign)CGRect imageRect;//图片
@property(nonatomic,assign)CGRect commentBtnRect;//评论按钮
@property(nonatomic,assign)CGRect commentRect;//评论内容
@property(nonatomic,assign)CGFloat allHeight;//总高度
@property(nonatomic,strong)YFMessageModel *messageModel;//数据
- (instancetype)initWithObject:(YFMessageModel *)model;//构造
@end
