//
//  BaseNavView.h
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/14.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavView : UIView
@property(nonatomic,copy)void(^returnBlock)();
@property(nonatomic,copy)void(^rightBlock)();
- (instancetype)initNavView:(NSString *)title andRightShow:(BOOL)show andRightImage:(NSString *)imageName;
@end
