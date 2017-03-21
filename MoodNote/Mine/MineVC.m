//
//  MineVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/6.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import "MineVC.h"
#import "LoginManager.h"
#import "PhotoShowManager.h"
#import <SDWebImage/UIButton+WebCache.h>
@interface MineVC ()
@property (weak, nonatomic) IBOutlet UIButton *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;//主题设置
@property (weak, nonatomic) IBOutlet UILabel *outLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
- (IBAction)clickIconBtn:(id)sender;

- (IBAction)clickNameBtn:(UIButton *)sender;
- (IBAction)clickSwitchBtn:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UILabel *outBtn;
@end

@implementation MineVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //ui设置
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame) / 2;
    self.iconImageView.layer.masksToBounds = YES;
    self.outLabel.layer.cornerRadius = 5;
    self.outLabel.layer.masksToBounds = YES;
    
    [self.nameLabel setTitle:[UserDataManager obtainUserName] forState:UIControlStateNormal];
    [self.iconImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserDataManager obtainUserIcon]] forState:UIControlStateNormal];
    self.bgView.backgroundColor = [UserDataManager obtainColor] ? openColor:closeColor;
    self.outBtn.backgroundColor = [UserDataManager obtainColor] ? openColor:closeColor;
    [self.switchBtn setOn:[UserDataManager obtainColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//数据请求
/*
- (void)p_loadData{

    __block typeof(self)weakSelf = self;
    [YFBmobManager obtainPersonMessageSuccess:^(NSString *icon, NSString *name) {
        
        [weakSelf.nameLabel setTitle:name forState:UIControlStateNormal];
        
        icon.length <= 5 ? NSLog(@"说明没有头像，用系统默认的") : @(1);
    } failure:^{
        
        [MBProgressHUD YFshowMessage:weakSelf.view showText:@"数据请求出错误了，请重新登陆"];
    }];
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
            {
            
                //主题设置
                
            }
                break;
            case 1:{
            
                //反馈
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"输入需要反馈的问题" preferredStyle:UIAlertControllerStyleAlert];
                
                [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    
                    textField.placeholder = @"亲，有什么问题呢";
                }];
                __block typeof(self)weakSelf = self;
                [alertVC addAction:[UIAlertAction actionWithTitle:@"反馈" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //获得输入
                    UITextField *field = alertVC.textFields.firstObject;
                    if(field.text.length <= 0){
                    
                        [MBProgressHUD YFshowMessage:weakSelf.view showText:@"反馈的问题在哪里呢"];
                        return ;
                    }
                    [MBProgressHUD YFshowMessage:weakSelf.view showText:@"反馈的问题已经提交"];
                    NSLog(@"反馈的问题:%@",field.text);
                    
                }]];
                
                [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                
                [self presentViewController:alertVC animated:YES completion:nil];
            }
                break;
            case 2:{
            
                //版本更新
                //反馈
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经是最新版本" preferredStyle:UIAlertControllerStyleAlert];
                [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertVC animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
        
    }else{
    
        //删除本地保存数据
        [UserDataManager deleteDataForUser];
        //退出操作
        [[LoginManager shareLoginManager] loadLoginVC];
    }
}

//头像
- (IBAction)clickIconBtn:(id)sender {
    
    [self p_loadSheet];
}

//名字
- (IBAction)clickNameBtn:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请修改名字" preferredStyle:UIAlertControllerStyleAlert];
    
    __block typeof(self)weakSelf = self;
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text = [UserDataManager obtainUserName];
    }];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获得输入
        UITextField *field = alertVC.textFields.firstObject;
        if (field.text.length > 0) {
            [UserDataManager saveName:field.text];
            [weakSelf.nameLabel setTitle:field.text forState:UIControlStateNormal];
            [YFBmobManager updatePersonMessage:^{
                [MBProgressHUD YFshowMessage:weakSelf.view showText:@"更改名字成功"];
            } failure:^{
                
                [MBProgressHUD YFshowMessage:weakSelf.view showText:@"更改名字失败"];
            }];
        }else{
        
            [MBProgressHUD YFshowMessage:weakSelf.view showText:@"名字不能为空"];
        }
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//主题
- (IBAction)clickSwitchBtn:(UISwitch *)sender {
    
    [UserDataManager saveColor:sender.isOn];
    self.bgView.backgroundColor = sender.isOn ? openColor:closeColor;
    self.outBtn.backgroundColor = sender.isOn ? openColor:closeColor;
    //发出一个通知,改变
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil];
}

#pragma mark ----弹出框设置
- (void)p_loadSheet{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择类型" preferredStyle:UIAlertControllerStyleActionSheet];
    __block typeof(self)weakSelf = self;
    UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf p_showPhoto:0];
    }];
    UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf p_showPhoto:1];
    }];
    
    UIAlertAction *alert4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:alert1];
    [alertVC addAction:alert2];
    [alertVC addAction:alert4];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

//选择模式
- (void)p_showPhoto:(NSInteger)mode{
    
    //跳转相册
    PhotoShowManager *photoManager = [PhotoShowManager sharePhotoManager];
    //图像传递
    __block typeof(self)weakSelf = self;
    photoManager.iconBlock = ^(UIImage *icon){
        
        [weakSelf.iconImageView setBackgroundImage:icon forState:UIControlStateNormal];
    };
    
    photoManager.updateBlock = ^(NSString *url){
        
        [UserDataManager saveIcon:url];
        [YFBmobManager updatePersonMessage:^{
            [MBProgressHUD YFshowMessage:self.view showText:@"更改头像成功"];
        } failure:^{
            [MBProgressHUD YFshowMessage:self.view showText:@"更改头像失败"];
        }];
    };
    
    photoManager.updateVideoBlock = ^(NSString *url){
        
        
    };
    [photoManager skipPhotoAlbumVC:mode];
}

@end
