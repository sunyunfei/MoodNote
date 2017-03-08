//
//  MBProgressHUD+YF.m
//  MB显示Demo
//
//  Created by 孙云 on 15/12/14.
//  Copyright © 2015年 haidai. All rights reserved.
//

#import "MBProgressHUD+YF.h"

@implementation MBProgressHUD (YF)
/**
 *   旋转显示
 */
+(void)YFshowHUD:(UIView *)view labelText:(NSString *)text
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    //hud.labelText = text;
    [hud show:YES];
}
/**
 *  隐藏
 *
 */
+(void)YFhiddenHUD:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}
/**
 *  隐藏旧的显示新的
 *
 *  @param view <#view description#>
 */
+(void)YFhiddenOldHUDandShowNewHUD:(UIView *)view newText:(NSString *)text
{
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    [hud removeFromSuperViewOnHide];
}
/**
 *  显示信息
 *
 */
+(void)YFshowMessage:(UIView *)view showText:(NSString *)text
{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
    [hud removeFromSuperViewOnHide];
}
@end
