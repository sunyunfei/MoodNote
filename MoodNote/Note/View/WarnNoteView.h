//
//  WarnNoteView.h
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WarnNoteView : NSObject
@property(nonatomic,copy)void(^clickCateoryBtn)(NSInteger tag);//点击的哪一个按钮
//加载视图
- (void)loadWarnView;
//隐藏视图
- (void)hiddenView;
@end
