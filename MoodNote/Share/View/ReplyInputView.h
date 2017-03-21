//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <UIKit/UIKit.h>
//改变根据文字改变TextView的高度
typedef void (^ContentSizeBlock)(CGSize contentSize);
//添加评论
typedef void (^replyAddBlock)(NSString *replyText,NSInteger inputTag);
@interface ReplyInputView : UIView
@property (nonatomic,assign)NSInteger replyTag;

-(void)setContentSizeBlock:(ContentSizeBlock) block;
-(void)setReplyAddBlock:(replyAddBlock)block;
-(id)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView;
@end
