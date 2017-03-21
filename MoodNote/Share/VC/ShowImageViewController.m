//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "ShowImageViewController.h"
#import "ShowImageView.h"

@interface ShowImageViewController ()
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    ShowImageView *showImageView = [[ShowImageView alloc]initWithFrame:self.view.bounds byClickTag:self.clickTag appendArray:self.imageViews];
    
    [self.view addSubview:showImageView];
    showImageView.removeImg = ^(){
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
