//
//  MineVC.m
//  MoodNote
//
//  Created by 孙云飞 on 2017/3/6.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import "MineVC.h"
#import "LoginManager.h"
@interface MineVC ()
@property (weak, nonatomic) IBOutlet UIButton *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *outLabel;

@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //ui设置
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame) / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.outLabel.layer.cornerRadius = 5;
    self.outLabel.layer.masksToBounds = YES;
    
    [self p_loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//数据请求
- (void)p_loadData{

    __block typeof(self)weakSelf = self;
    [YFBmobManager obtainPersonMessageSuccess:^(NSString *icon, NSString *name) {
        
        [weakSelf.nameLabel setTitle:name forState:UIControlStateNormal];
        
        icon.length <= 5 ? NSLog(@"说明没有头像，用系统默认的") : @(1);
    } failure:^{
        
        [MBProgressHUD YFshowMessage:weakSelf.view showText:@"数据请求出错误了，请重新登陆"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        
    }else{
    
        //删除本地保存数据
        [UserDataManager deleteDataForUser];
        //退出操作
        [[LoginManager shareLoginManager] loadLoginVC];
    }
}

@end
