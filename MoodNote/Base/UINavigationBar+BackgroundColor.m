//
//  UINavigationBar+BackgroundColor.m
//  YangLiWu
//
//  Created by 李梦飞 on 2017/2/14.
//  Copyright © 2017年 haidai. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>
static char overlayKey;
@implementation UINavigationBar (BackgroundColor)

- (UIView *)overlay{

    return objc_getAssociatedObject(self, &overlayKey);
    
}

- (void)setOverlay:(UIView *)overlay{

    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yf_setBackgroundColor:(UIColor *)backgroundColor{

    if(!self.overlay){
    
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height + 20)];
        
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [self insertSubview:self.overlay atIndex:0];
    }
    
    self.overlay.backgroundColor = backgroundColor;  
}
@end
