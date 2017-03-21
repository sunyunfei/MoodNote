//
//  BaseNavView.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/14.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "BaseNavView.h"
@interface BaseNavView()
@property(nonatomic,strong)UIButton *returnBtn;
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation BaseNavView

- (instancetype)initNavView:(NSString *)title andRightShow:(BOOL)show andRightImage:(NSString *)imageName{

    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,screenWidth , 44);
        self.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
        [self loadUI:title andShow:show andImage:imageName];
    }
    return self;
}

- (void)loadUI:(NSString *)title andShow:(BOOL)show andImage:(NSString *)imageName{

    _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnBtn.frame = CGRectMake(8, 0, 44, 44);
    _returnBtn.backgroundColor = [UIColor blueColor];
    [_returnBtn addTarget:self action:@selector(clickReturnBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_returnBtn];
   
    if (show) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(screenWidth - 8 - 44, 0, 44, 44);
        _rightBtn.backgroundColor = [UIColor blueColor];
        [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightBtn];
    }
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44 + 8, 0, screenWidth - 44 - 8 - 44 - 8, 44)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = title;
    [self addSubview:_titleLabel];
}

//返回事件
- (void)clickReturnBtn{

    if (self.returnBlock) {
        self.returnBlock();
    }
}

//右边按钮事件
- (void)clickRightBtn{

    if (self.rightBlock) {
        self.rightBlock();
    }
}
@end
