//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

//用来处理图片点击后放大的效果
#import <UIKit/UIKit.h>
typedef void(^didRemoveImage)(void);
@interface ShowImageView : UIView
@property (nonatomic,copy)didRemoveImage removeImg;
-(id)initWithFrame:(CGRect)frame byClickTag:(NSInteger)clickTag appendArray:(NSArray *)appendArray;
@end

