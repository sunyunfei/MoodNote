//
//  BaseNavVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/14.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "BaseNavVC.h"
#import "UINavigationBar+BackgroundColor.h"
@interface BaseNavVC ()

@end

@implementation BaseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self loadColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadColor) name:@"change" object:nil];
}

- (void)loadColor{

    [self.navigationBar yf_setBackgroundColor:[UserDataManager obtainColor] ? openColor : closeColor ];
    
}


@end
