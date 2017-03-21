//
//  BaseVC.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/14.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

- (void)baseLoadTitle:(NSString *)title andShowLeft:(BOOL)show andShowRight:(BOOL)show2 andreturnTitle:(NSString *)returnTitle;
- (void)baseReturnBtn;
- (void)baseRightBtn;
@end
