//
//  YFShareRectManager.m
//  再防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "YFShareRectManager.h"
#define K_MARGAIN 8//边界
#define K_WIDTH [UIScreen mainScreen].bounds.size.width//总宽
#define K_HEIGH [UIScreen mainScreen].bounds.size.height//总高
#define K_IMageGeight 140//图片最大总高
@implementation YFShareRectManager

- (instancetype)initWithObject:(YFMessageModel *)model{

    self = [super init];
    if (self) {
        
        [self rectSet:model];
        self.messageModel = model;
    }
    return self;
}

//rect设置
- (void)rectSet:(YFMessageModel *)model{

    //头像
    _iconRect = CGRectMake(K_MARGAIN, K_MARGAIN, 30, 30);
    
    //名字
    _nameRect = CGRectMake(K_MARGAIN * 2 + 30, K_MARGAIN, (K_WIDTH - K_MARGAIN - 30) / 2, 20);
    
    //时间
    _timeRect = CGRectMake(CGRectGetWidth(_nameRect) + _nameRect.origin.x, K_MARGAIN, K_WIDTH - CGRectGetWidth(_iconRect) - K_MARGAIN - K_MARGAIN - CGRectGetWidth(_nameRect)-K_MARGAIN, 20);
   
    //内容
    CGFloat contentX = K_MARGAIN * 2 + CGRectGetWidth(_iconRect);
    //算出来内容的高度
    CGSize contentSize = [model.message boundingRectWithSize:CGSizeMake(K_WIDTH  - contentX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    CGFloat contentY = K_MARGAIN * 2 + CGRectGetHeight(_nameRect);
    
    _contentRect = CGRectMake(contentX, contentY, K_WIDTH  - contentX, contentSize.height);
    
    //图片的高度
    CGFloat imageY = contentY + contentSize.height + K_MARGAIN;
    CGFloat imageH = 0;
    //首先判断有么有图片
    if (model.messageSmallPics.count > 0) {
        
        //说明有图片,判断是否多于一行
        if (model.messageSmallPics.count > 4) {
            
            imageH = K_IMageGeight;
        }else{
        
            imageH = K_IMageGeight / 2;
        }
        
    }
    _imageRect = CGRectMake(K_MARGAIN + contentX, imageY, K_WIDTH - K_MARGAIN - contentX, imageH);
    
    //评论按钮
    CGFloat btnX = K_WIDTH - K_MARGAIN - 40;
    CGFloat btnY = imageY + imageH + K_MARGAIN;
    _commentBtnRect = CGRectMake(btnX, btnY, 40, 30);
    
    //评论内容
    CGFloat commentY = btnY + 30 + K_MARGAIN;
    CGFloat commentHeight = 0;
    //计算出所有的高度
    for (YFCommentModel *commentModel in model.commentModelArray) {
        
        NSMutableString *comment = [NSMutableString string];
        if (commentModel.commentByUserId) {
            
            //说明是回复的评论的
            [comment appendString:[NSString stringWithFormat:@"%@回复%@:",commentModel.commentUserName,commentModel.commentByUserName]];
            [comment appendString:commentModel.commentText];
            
        }else{
        
            [comment appendString:[NSString stringWithFormat:@"%@:",commentModel.commentUserName]];
            [comment appendString:commentModel.commentText];
        }
        //开始计算
        CGSize commentSize = [comment boundingRectWithSize:CGSizeMake(K_WIDTH -K_MARGAIN-contentX, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        //计算总的高度
        commentHeight += commentSize.height;
    }
    
    NSLog(@"commentHeight = %.2f",commentHeight);
    
    _commentRect = CGRectMake(0, commentY, K_WIDTH, commentHeight);
    
    //总的高度
    _allHeight = _commentRect.origin.y + commentHeight + 8;
}
@end
