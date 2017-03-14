//
//  InputView.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "InputView.h"
@interface InputView()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *textField;//输入框
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *tapView;
@property(nonatomic,strong)UIButton *sendBtn;
@end
@implementation InputView

- (instancetype)init{

    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        _tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(self.frame) - 216 - 30)];
        _tapView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
        [_tapView addGestureRecognizer:tap];
        [self addSubview:_tapView];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, CGRectGetWidth(self.frame), 216)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(8, 8, CGRectGetWidth(self.frame) - 48, 30)];
        _textField.placeholder = @"输入";
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.delegate = self;
        [_bgView addSubview:_textField];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(8 + CGRectGetWidth(_textField.frame),8 , 40, 30);
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        _sendBtn.backgroundColor = [UIColor blueColor];
        [_sendBtn addTarget:self action:@selector(clickSenderBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_sendBtn];
    }
    return self;
}

- (void)layoutSubviews{

    if (self.mode == Replay_Mode) {
        
        _textField.placeholder = [NSString stringWithFormat:@"回复:%@",self.commentModel.commentUserName];
        [_sendBtn setTitle:@"回复" forState:UIControlStateNormal];
    }else{
        
        _textField.placeholder = @"有什么感想呢";
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    }
}

- (void)clickSenderBtn{

    if (self.textField.text.length <= 0) {
        return;
    }
    
    YFCommentModel *model = [[YFCommentModel alloc]init];
    if (self.mode == Replay_Mode) {
        
        //回复事件
        model.commentUserName = [UserDataManager obtainUserName];
        model.commentUserId = [UserDataManager obtainUserId];
        model.commentText = _textField.text;
        model.commentByUserId = self.commentModel.commentUserId;
        model.commentByUserName = self.commentModel.commentUserName;
    }else{
    
        model.commentUserName = [UserDataManager obtainUserName];
        model.commentUserId = [UserDataManager obtainUserId];
        model.commentText = _textField.text;
    }
    [self.messageModel.commentModelArray addObject:model];
    //表刷新
    if (self.refreshBlock) {
        self.refreshBlock(self.messageModel);
        
        [self tapEvent];
    }
    
    //插入评论
    
    [YFBmobManager insertComment:self.messageModel.message_id andCommentModel:model sucess:^{
        
        NSLog(@"评论插入成功");
    } failure:^{
        NSLog(@"评论插入失败");
    }];
}
//隐藏
- (void)tapEvent{

    [UIView animateWithDuration:0.3 animations:^{
        
        _bgView.transform = CGAffineTransformIdentity;
    }];
    [_textField resignFirstResponder];
    //注销view
    [self removeFromSuperview];
}

//显示
- (void)showInWindows{

    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        _bgView.transform = CGAffineTransformMakeTranslation(0, -216 - 30);
    }];
    //吊起键盘
    [_textField becomeFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [UIView animateWithDuration:0.3 animations:^{
        
        _bgView.transform = CGAffineTransformIdentity;
    }];
    [_textField resignFirstResponder];
    //注销view
    [self removeFromSuperview];
    return YES;
}
@end
