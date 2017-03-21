//
//  BaseVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/14.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "BaseVC.h"
@interface BaseVC ()
@property(nonatomic,weak)UIView *baseTopView;
@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseChangeColor) name:@"change" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.baseTopView];
}

- (void)baseLoadTitle:(NSString *)title andShowLeft:(BOOL)show andShowRight:(BOOL)show2 andreturnTitle:(NSString *)returnTitle{

    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    bgView.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
    [self.view addSubview:bgView];
    
    if (show) {
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        returnBtn.frame = CGRectMake(8, 20, 44, 44);
        [returnBtn setImage:[UIImage imageNamed:@"icotab_beforepress_v5"] forState:UIControlStateNormal];
        [returnBtn addTarget:self action:@selector(baseReturnBtn) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:returnBtn];
    }
    
    if (show2) {
       UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(screenWidth - 8 - 44, 20, 44, 44);
        [rightBtn setTitle:returnTitle forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBtn addTarget:self action:@selector(baseRightBtn) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:rightBtn];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(44 + 8, 20, screenWidth - 44 - 8 - 44 - 8, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    [bgView addSubview:titleLabel];
    
    self.baseTopView = bgView;
}

- (void)baseChangeColor{

    self.baseTopView.backgroundColor = [UserDataManager obtainColor] ? openColor : closeColor;
}
- (void)baseReturnBtn{

    NSLog(@"根部返回");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseRightBtn{

   NSLog(@"根部右边按钮");
}

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
