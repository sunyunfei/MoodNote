//
//  ShareVC.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/12.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "ShareVC.h"
#import "CreateShareVC.h"
@interface ShareVC ()
- (IBAction)clickShareBtn:(id)sender;

@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickShareBtn:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CreateShareVC" bundle:nil];
    CreateShareVC *vc = [story instantiateViewControllerWithIdentifier:@"create"];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
