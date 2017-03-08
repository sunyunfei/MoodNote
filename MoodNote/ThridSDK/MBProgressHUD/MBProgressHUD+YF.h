//
//  MBProgressHUD+YF.h
//  MB显示Demo
//
//  Created by 孙云 on 15/12/14.
//  Copyright © 2015年 haidai. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (YF)
//显示旋转
+(void)YFshowHUD:(UIView *)view labelText:(NSString *)text;
//隐藏
+(void)YFhiddenHUD:(UIView *)view;
//新的开始
+(void)YFhiddenOldHUDandShowNewHUD:(UIView *)view newText:(NSString *)text;
//显示信息
+(void)YFshowMessage:(UIView *)view showText:(NSString *)text;
@end
