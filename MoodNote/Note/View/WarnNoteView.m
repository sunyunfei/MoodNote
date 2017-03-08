//
//  WarnNoteView.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "WarnNoteView.h"
@interface WarnNoteView()
@property(nonatomic,strong)UIView *bgView;
@end
@implementation WarnNoteView

//加载视图
- (void)loadWarnView{

    //首先一个底部的灰色背景
    _bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickBgView)];
    [_bgView addGestureRecognizer:tap];
    //主窗口加载
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_bgView];
    
    //按钮
    NSArray *array = @[@"文字笔记",@"图片笔记",@"视频笔记"];
    for(int i = 0;i < 3;i++){
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(CGRectGetWidth(_bgView.frame) - 115, 40 * i + 50, 100, 40);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
}

//按钮事件
- (void)clickBtn:(UIButton *)sender{

    self.clickCateoryBtn(sender.tag);
    //隐藏
    [self hiddenView];
}

- (void)clickBgView{

    [self hiddenView];
}

- (void)hiddenView{

    if (self.bgView) {
        
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }
}
@end
