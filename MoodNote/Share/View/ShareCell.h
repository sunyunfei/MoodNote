//
//  ShareCell.h
//  再防朋友圈
//
//  Created by 孙云飞 on 2017/3/13.
//  Copyright © 2017年 孙云飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFShareRectManager.h"
@interface ShareCell : UITableViewCell
@property(nonatomic,strong)YFShareRectManager *rectManager;//数据
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,copy)void(^refreshCell)(NSIndexPath *path);
@end
