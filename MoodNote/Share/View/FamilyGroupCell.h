//
//  CreateShareVC.m
//  MoodNote
//
//  Created by 李梦飞 on 2017/2/12.
//  Copyright © 2017年 李梦飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamilyGroupFrame.h"
typedef void (^ImageBlock)(NSArray *imageViews,NSInteger clickTag);
@interface FamilyGroupCell : UITableViewCell
@property (nonatomic,strong)FamilyGroupFrame *familyGroupFrame;
@property (weak,nonatomic)UIButton *replyButton;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (strong,nonatomic)ImageBlock imageBlock;
@property(nonatomic,copy)void(^labelBlock)(NSString *name,NSInteger row);
@end
