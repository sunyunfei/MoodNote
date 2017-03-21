//
//  BaseTabbarVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "BaseTabbarVC.h"

@interface BaseTabbarVC ()
@property(nonatomic,strong)UIView *bgView;
@end

@implementation BaseTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 设置一个自定义 View,大小等于 tabBar 的大小
    _bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    // 将自定义 View 添加到 tabBar 上
    [self.tabBar insertSubview:_bgView atIndex:0];
    [self loadColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:@"change" object:nil];
}

- (void)loadColor{

    // 给自定义 View 设置颜色
    _bgView.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
    
}
@end
